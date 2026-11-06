<?php
// ============================================================
// bulk.php
//
// Two tabs on one page:
//   - "Hak" = the original single-section form (fill fields, get 1 file)
//   - "Dog" = paste multiple sections at once (1 command | count per line),
//             get back multiple .bat files (or one .zip of all of them)
// ============================================================

session_start();

// ============================================================
// HAK: shared helper functions (also reused by Dog below)
// ============================================================

// Takes a string like "mcapr901" and increases the trailing number by $offset.
// Example: incrementTrailingNumber("mcapr901", 1) -> "mcapr902"
// It keeps the same number of digits (zero padding) as the original.
function incrementTrailingNumber($text, $offset)
{
    // This looks for: (anything) followed by (one or more digits) at the end
    if (preg_match('/^(.*?)(\d+)$/', $text, $matches)) {
        $prefixPart = $matches[1];
        $numberPart = $matches[2];
        $digitWidth = strlen($numberPart);

        $newNumber = (int) $numberPart + $offset;
        $newNumberPadded = str_pad($newNumber, $digitWidth, '0', STR_PAD_LEFT);

        return $prefixPart . $newNumberPadded;
    }

    // If there's no trailing number at all, just stick the offset on the end.
    return $text . $offset;
}

// Turns "asukalibo.local" into ["asukalibo", "local"] so we can build dc=asukalibo,dc=local
function splitDomainIntoDcParts($domainName)
{
    return explode('.', $domainName);
}

// Builds the full "cn=...,ou=...,ou=...,dc=...,dc=..." distinguished name.
// $ouParts is a list ordered from closest to the CN to farthest
// (e.g. ["emc1a-cc103", "BSEMC", "students"]).
function buildDistinguishedName($cnValue, $ouParts, $dcParts)
{
    $dn = "cn={$cnValue}";

    foreach ($ouParts as $index => $ouPart) {
        // Only lowercase the first OU (the section name), same as before -
        // the rest are used exactly as typed.
        $ouValue = ($index === 0) ? strtolower($ouPart) : $ouPart;
        $dn .= ",ou={$ouValue}";
    }

    foreach ($dcParts as $dcPart) {
        $dn .= ",dc={$dcPart}";
    }

    return $dn;
}

// Builds one full dsadd command line
function buildDsaddLine($dn, $firstName, $lastName, $password, $mustChangePwd)
{
    return "dsadd user \"{$dn}\" -fn {$firstName} -ln {$lastName} -pwd {$password} -mustchpwd {$mustChangePwd}";
}

// Turns any text into something safe to use as a filename
function sanitizeFileName($text)
{
    $safe = preg_replace('/[^A-Za-z0-9\-_]/', '_', $text);
    return $safe === '' ? 'section' : $safe;
}

// Builds a dsadd group line for a security group
function buildDsaddGroupLine($groupDn)
{
    return "dsadd group \"{$groupDn}\" -secgrp yes -scope g";
}

// Builds one or more dsmod lines that add member DNs to a group.
// Chunks into batches of $chunkSize (default 56) to stay safely under the
// CMD 8,191-character-per-line limit (56 members ≈ 3,700 chars — see RULES.MD Rule 2).
// Returns an ARRAY of strings, one dsmod call per chunk.
function buildDsmodAddMembersLines($groupDn, $memberDns, $chunkSize = 56)
{
    if (empty($memberDns)) {
        return [];
    }

    $lines = [];
    foreach (array_chunk($memberDns, $chunkSize) as $chunk) {
        $quotedMembers = array_map(function ($dn) {
            return "\"{$dn}\"";
        }, $chunk);
        $lines[] = "dsmod group \"{$groupDn}\" -addmbr " . implode(' ', $quotedMembers);
    }

    return $lines;
}

// Builds the Run_all.bat content:
//   STEP 1 - create the mother OU, then one child OU per section (original case preserved)
//   STEP 2 - call each section .bat file in order
//   STEP 3 - call groups.bat if groups were also generated
function buildRunAllBat($sections, $motherOU, $dcParts, $createGroups)
{
    $dcStr = implode(',', array_map(function ($dc) {
        return "dc={$dc}";
    }, $dcParts));

    $lines = [];
    $lines[] = '@echo off';
    $lines[] = '';

    // STEP 1: Create the mother OU first
    $lines[] = "dsadd ou \"ou={$motherOU},{$dcStr}\"";
    $lines[] = '';

    // Then create one child OU per section, preserving the case the user typed
    foreach ($sections as $section) {
        $lines[] = "dsadd ou \"ou={$section['ouName']},ou={$motherOU},{$dcStr}\"";
    }

    $lines[] = '';
    $lines[] = 'echo OU structure created.';
    $lines[] = 'echo.';
    $lines[] = '';

    // STEP 2: Call each section bat file
    foreach ($sections as $section) {
        $lines[] = "call \"{$section['filename']}.bat\"";
        $lines[] = "echo {$section['filename']}.bat is done";
    }

    // STEP 3: Call groups.bat only if the groups option was also checked
    if ($createGroups) {
        $lines[] = '';
        $lines[] = 'call "groups.bat"';
        $lines[] = 'echo groups.bat is done';
    }

    $lines[] = '';
    $lines[] = 'echo ===== ALL DONE =====';
    $lines[] = 'pause';

    return $lines;
}

// Builds the combined mapping.bat content.
// $sectionData is an array of sections, each with:
//   'ouName'   => original-case section name (e.g. "EMC1A-CC103")
//   'users'    => array of [ 'cn' => 'mcapr901', 'dn' => 'cn=mcapr901,...' ]
// $fileServer  => e.g. "DC1"
// $rootFolder  => e.g. "26271stSem"
// $netbios     => e.g. "ASUKALIBO"
//
// The generated script follows whole_section.bat exactly:
// one for-loop over sections, dsquery finds users at runtime — no per-user hardcoding.
// This keeps every line well under the CMD 8,191-character limit regardless of class size.
function buildMappingBat($sectionData, $fileServer, $rootFolder, $netbios, $masterGroup, $homeDrive = 'H')
{
    // Normalize config so SHAREPATH can never come out malformed.
    $fileServer = trim($fileServer, " \\/");
    $rootFolder = trim($rootFolder, " \\/");
    $netbios    = strtoupper(trim($netbios, " \\"));
    $homeDrive  = strtoupper(trim($homeDrive));
    if (!preg_match('/^[A-Z]$/', $homeDrive)) {
        $homeDrive = 'H';
    }

    if ($fileServer === '' || $rootFolder === '' || $netbios === '') {
        return [
            '@echo off',
            'echo ERROR: mapping config is incomplete (file server, root folder, and netbios are required).',
            'pause',
        ];
    }

    // Extract the base AD path from the first user DN.
    // e.g. from "cn=hn1ainc101,ou=cc101-hn1a,ou=students,dc=asukalibo,dc=local"
    // strip cn= and the section ou= to get "ou=students,dc=asukalibo,dc=local"
    $baseAdPath = 'ou=students,dc=' . strtolower($netbios) . ',dc=local'; // safe fallback
    if (!empty($sectionData)) {
        $firstDn = $sectionData[0]['users'][0]['dn'] ?? '';
        if (preg_match('/^cn=[^,]+,ou=[^,]+,(.+)$/i', $firstDn, $adm)) {
            $baseAdPath = $adm[1];
        }
    }

    $lines = [];

    // --- Header: matches whole_section.bat lines 1-6 ---
    $lines[] = '@echo off';
    $lines[] = 'setlocal enabledelayedexpansion';
    $lines[] = '';
    $lines[] = "set \"SHAREPATH=\\\\{$fileServer}\\{$rootFolder}\"";
    $lines[] = "set \"DOMAIN={$netbios}\"";
    $lines[] = '';

    // --- Section list: PHP injects one name per line into the for %%S in (...) block ---
    // This is the ONLY place section names appear — no per-user unrolling, no line-length risk.
    $lines[] = 'for %%S in (';
    foreach ($sectionData as $sec) {
        $lines[] = '    ' . $sec['ouName'];
    }
    $lines[] = ') do (';
    $lines[] = '';

    // --- Loop body: verbatim from whole_section.bat lines 11-58 ---
    // Only $baseAdPath and $homeDrive are substituted dynamically.
    $lines[] = '    set "SECTION=%%S"';
    $lines[] = '';
    $lines[] = '    set "SECTIONPATH=%SHAREPATH%\!SECTION!"';
    $lines[] = '    set "COMMONPATH=!SECTIONPATH!\Common"';
    $lines[] = '';
    $lines[] = '    echo.';
    $lines[] = '    echo ========================================';
    $lines[] = '    echo Processing: !SECTION!';
    $lines[] = '    echo ========================================';
    $lines[] = '';
    $lines[] = '    if not exist "!SECTIONPATH!" mkdir "!SECTIONPATH!"';
    $lines[] = '    if not exist "!COMMONPATH!" mkdir "!COMMONPATH!"';
    $lines[] = '';
    $lines[] = '    icacls "!SECTIONPATH!" /inheritance:r >nul';
    $lines[] = '    icacls "!SECTIONPATH!" /grant "%DOMAIN%\!SECTION!:(OI)(CI)(RX)" || echo ERROR granting !SECTION! on !SECTIONPATH!';
    $lines[] = '    icacls "!SECTIONPATH!" /grant "Administrators:(OI)(CI)(F)" >nul';
    $lines[] = '    icacls "!SECTIONPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul';
    $lines[] = '    icacls "!SECTIONPATH!" /grant "*S-1-3-0:(OI)(CI)(IO)(F)" >nul';
    $lines[] = '';
    $lines[] = '    icacls "!COMMONPATH!" /inheritance:r >nul';
    $lines[] = '    icacls "!COMMONPATH!" /grant "%DOMAIN%\!SECTION!:(OI)(CI)(RX)" || echo ERROR granting !SECTION! on !COMMONPATH!';
    $lines[] = '    icacls "!COMMONPATH!" /grant "Administrators:(OI)(CI)(F)" >nul';
    $lines[] = '    icacls "!COMMONPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul';
    $lines[] = '';
    $lines[] = '    set "MAPPED=0"';
    $lines[] = '';
    $lines[] = '    echo Querying AD for users in ou=!SECTION!...';
    $lines[] = '    echo.';
    $lines[] = '';
    $lines[] = "    for /f \"tokens=1 delims=,\" %%d in ('dsquery user \"ou=!SECTION!,{$baseAdPath}\" -limit 0 2^>nul') do (";
    $lines[] = '        for /f "tokens=2 delims==" %%u in ("%%~d") do (';
    $lines[] = '            set "USER=%%u"';
    $lines[] = '            set "USERPATH=!SECTIONPATH!\!USER!"';
    $lines[] = '            if not exist "!USERPATH!" mkdir "!USERPATH!"';
    $lines[] = '            icacls "!USERPATH!" /inheritance:r >nul';
    $lines[] = '            icacls "!USERPATH!" /grant "%DOMAIN%\!USER!:(OI)(CI)(F)" || echo [WARN] icacls failed for !USER!';
    $lines[] = '            icacls "!USERPATH!" /grant "Administrators:(OI)(CI)(F)" >nul';
    $lines[] = '            icacls "!USERPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul';
    $lines[] = '            icacls "!USERPATH!" /grant "*S-1-3-0:(OI)(CI)(IO)(F)" >nul';
    $lines[] = "            dsmod user \"cn=!USER!,ou=!SECTION!,{$baseAdPath}\" -hmdir \"!SECTIONPATH!\" -hmdrv {$homeDrive}:";
    $lines[] = '            echo [OK]   Mapped !USER!';
    $lines[] = '            set /a MAPPED+=1';
    $lines[] = '        )';
    $lines[] = '    )';
    $lines[] = '';
    $lines[] = '    echo.';
    $lines[] = '    echo Results: !MAPPED! users mapped from AD in !SECTION!';
    $lines[] = '    echo.';
    $lines[] = ')';
    $lines[] = '';

    // --- Footer: verbatim from whole_section.bat lines 61-65 ---
    $lines[] = 'echo ========================================';
    $lines[] = 'echo ALL SECTIONS COMPLETED';
    $lines[] = 'echo ========================================';
    $lines[] = 'echo.';
    $lines[] = 'pause';

    return $lines;
}

// Detects the program a section belongs to based on its OU prefix.
// Order matters: 'ist' must be checked before 'is'.
function detectProgram($sectionName)
{
    $n = strtolower($sectionName);
    if (strpos($n, 'emc')  === 0) return 'BSEMC';
    if (strpos($n, 'btv')  === 0) return 'BTVTED';
    if (strpos($n, 'bpo')  === 0) return 'BPO';
    if (strpos($n, 'ist')  === 0) return 'IST'; // must be before 'is'
    if (strpos($n, 'is')   === 0) return 'IS';
    if (strpos($n, 'se')   === 0) return 'SE';
    if (strpos($n, 'hn')   === 0) return 'HN';
    if (strpos($n, 'ce')   === 0) return 'CE';
    return 'OTHER';
}

// Extracts the logon names (arguments of -ln) from a list of command lines
function extractLogonNames($commands)
{
    $names = [];
    foreach ($commands as $cmd) {
        if (preg_match('/-ln\s+(\"[^\"]+\"|[^\s]+)/i', $cmd, $matches)) {
            $names[] = trim($matches[1], '"');
        }
    }
    return $names;
}

// Inspects a command line that failed parsing to give a more helpful suggestion/error
function detectCommandTypo($line, $lineNumber)
{
    $line = trim($line);
    if ($line === '') return null;

    // Check misspelled dsadd command (e.g. dsad, dssadd)
    if (preg_match('/^(\S+)/', $line, $cmdMatches)) {
        $firstWord = strtolower($cmdMatches[1]);
        if ($firstWord !== 'dsadd' && in_array($firstWord, ['dsad', 'dssadd', 'dsaddd', 'dsadad', 'dsadduser'])) {
            return 'Line ' . $lineNumber . ': Misspelled command. Did you mean "dsadd" instead of "' . htmlspecialchars($cmdMatches[1]) . '"?';
        }
    }

    // Check target of dsadd (must be "user")
    if (preg_match('/^dsadd\s+(\S+)/i', $line, $targetMatches)) {
        $target = strtolower($targetMatches[1]);
        if ($target !== 'user') {
            return 'Line ' . $lineNumber . ': Invalid target. Did you mean "dsadd user" instead of "dsadd ' . htmlspecialchars($targetMatches[1]) . '"?';
        }
    }

    // Check misspelled flags
    if (strpos($line, '-mustchpwd') === false && preg_match('/-must[a-z]+/i', $line, $flagMatches)) {
        return 'Line ' . $lineNumber . ': Misspelled flag. Did you mean "-mustchpwd" instead of "' . htmlspecialchars($flagMatches[0]) . '"?';
    }

    if (strpos($line, '-pwd') === false && preg_match('/-pw[a-z]+/i', $line, $flagMatches)) {
        return 'Line ' . $lineNumber . ': Misspelled flag. Did you mean "-pwd" instead of "' . htmlspecialchars($flagMatches[0]) . '"?';
    }

    return null;
}

// ============================================================
// HAK: single-section form logic
// ============================================================

// Known course code → abbreviation mappings (seed set — extend freely).
// Lookup is case-insensitive; keys should be the course code without spaces.
function getKnownCourseAbbreviations()
{
    return [
        'CC101' => 'inc',
        'CC104' => 'dsa',
        'CT1'   => 'ctw',
    ];
}

// Fallback abbreviation for a course title (used when the course code has no
// known mapping and no manual override was given):
//   - drop stopwords ("to", "in", "and", ...)
//   - first letter of each remaining word, lowercased
//   - numbers kept as-is ("2D Animation" -> "2da", "Web Development 101" -> "wd101")
//   - cap the letter count at 3 (numbers don't count toward the cap)
function abbreviateCourseTitle($title)
{
    $stopwords = ['to', 'in', 'and', 'with', 'of', 'the', 'a', 'an', 'for', 'on', 'at', 'by', 'from', 'using'];
    $words     = preg_split('/[^a-z0-9]+/i', strtolower(trim($title)), -1, PREG_SPLIT_NO_EMPTY);

    $abbrev = '';
    $letters = '';
    $usedLetters = 0;

    foreach ($words as $word) {
        if (in_array($word, $stopwords)) {
            continue;
        }
        if (preg_match('/^(\d+)([a-z]?)$/', $word, $m)) {
            $abbrev .= $m[1];                  // number as-is
            if ($m[2] !== '' && $usedLetters < 3) {
                $letters .= $m[2];             // first letter after the digits
                $usedLetters++;
            }
        } elseif ($usedLetters < 3) {
            $letters .= $word[0];
            $usedLetters++;
        }
    }

    $abbrev .= $letters;

    if ($abbrev === '') {
        $abbrev = substr(preg_replace('/[^a-z0-9]/', '', strtolower($title)), 0, 3);
    }

    return $abbrev;
}

// Resolves the abbreviation used in the CN:
//   1) manual override, if provided
//   2) known course-code table
//   3) auto-generated from the title
function resolveAbbreviation($courseCode, $title, $override)
{
    $override = strtolower(preg_replace('/[^a-z0-9]/', '', $override));
    if ($override !== '') {
        return substr($override, 0, 6);
    }

    $key = strtoupper(preg_replace('/\s+/', '', $courseCode));
    $known = getKnownCourseAbbreviations();
    if (isset($known[$key])) {
        return $known[$key];
    }

    return abbreviateCourseTitle($title);
}

// Generates all the command lines as an array, one per account.
// CN = {program}{section}{abbrev}{year*100 + N}, OU = {course}-{program}{year}{section}.
function generateAllCommands($formData)
{
    $dcParts = splitDomainIntoDcParts($formData['domain']);

    $programL = strtolower(trim($formData['program']));
    $sectionL = strtolower(trim($formData['section']));
    $courseL  = strtolower(preg_replace('/\s+/', '', $formData['courseCode']));
    $abbrev   = resolveAbbreviation($formData['courseCode'], $formData['courseTitle'], $formData['abbrevOverride']);

    $ouName  = "{$courseL}-{$programL}{$formData['yearLevel']}{$sectionL}";
    $ouParts = [$ouName, $formData['motherOU']];

    $commands = [];

    for ($i = 1; $i <= $formData['accountCount']; $i++) {
        $cnValue = "{$programL}{$sectionL}{$abbrev}" . ($formData['yearLevel'] * 100 + $i);

        $dn = buildDistinguishedName($cnValue, $ouParts, $dcParts);

        $commands[] = buildDsaddLine(
            $dn,
            $formData['firstName'],
            $cnValue,
            $formData['password'],
            $formData['mustChangePwd']
        );
    }

    return $commands;
}

// Reads and cleans up the Hak form fields from $_POST
function getFormDataFromPost()
{
    return [
        'courseCode'    => trim($_POST['courseCode'] ?? ''),
        'courseTitle'   => trim($_POST['courseTitle'] ?? ''),
        'program'       => trim($_POST['program'] ?? ''),
        'section'       => trim($_POST['section'] ?? ''),
        'yearLevel'     => (int) ($_POST['yearLevel'] ?? 0),
        'accountCount'  => (int) ($_POST['accountCount'] ?? 0),
        'abbrevOverride' => trim($_POST['abbrevOverride'] ?? ''),
        'domain'        => trim($_POST['domain'] ?? '') ?: 'asukalibo.local',
        'motherOU'      => trim($_POST['motherOU'] ?? '') ?: 'students',
        'firstName'     => trim($_POST['firstName'] ?? '') ?: 'Lab',
        'password'      => trim($_POST['password'] ?? '') ?: 'p@ssw0rd',
        'mustChangePwd' => trim($_POST['mustChangePwd'] ?? '') ?: 'yes',
    ];
}

// ============================================================
// MEOW: existing-course account generator
// ============================================================

// Reads existingCourses.txt (COURSE CODE,ABBREVIATION,FULL TITLE) into a
// map keyed by uppercase course code.
function loadExistingCourses()
{
    $file    = __DIR__ . DIRECTORY_SEPARATOR . 'existingCourses.txt';
    $courses = [];

    if (!is_file($file)) {
        return $courses;
    }

    $handle = fopen($file, 'r');
    if ($handle === false) {
        return $courses;
    }

    $firstRow = true;
    while (($line = fgetcsv($handle)) !== false) {
        if ($firstRow) { $firstRow = false; continue; } // skip header
        if (count($line) < 3) continue;
        $code = strtoupper(trim($line[0]));
        if ($code === '') continue;
        $courses[$code] = [
            'code'   => $code,
            'abbrev' => strtolower(trim($line[1])),
            'title'  => trim($line[2]),
        ];
    }

    fclose($handle);
    return $courses;
}

// Reads and cleans up the Meow form fields from $_POST
function getMeowFormDataFromPost()
{
    return [
        'domain'       => trim($_POST['meowDomain'] ?? '') ?: 'asukalibo.local',
        'baseOU'       => trim($_POST['meowBaseOU'] ?? '') ?: 'students',
        'courseCode'   => strtoupper(trim($_POST['meowCourseCode'] ?? '')),
        'courseTitle'  => trim($_POST['meowCourseTitle'] ?? ''),
        'program'      => trim($_POST['meowProgram'] ?? ''),
        'section'      => trim($_POST['meowSection'] ?? ''),
        'yearLevel'    => (int) ($_POST['meowYear'] ?? 0),
        'accountCount' => (int) ($_POST['meowCount'] ?? 0),
    ];
}

// Generates dsadd lines for an existing course. The abbreviation comes from the
// course file (no manual work); first name/password are fixed (Lab/p@ssw0rd/yes).
function generateMeowCommands($formData)
{
    $courses = loadExistingCourses();
    $code    = $formData['courseCode'];

    $abbrev = isset($courses[$code])
        ? $courses[$code]['abbrev']
        : abbreviateCourseTitle($formData['courseTitle']);

    $programL = strtolower(trim($formData['program']));
    $sectionL = strtolower(trim($formData['section']));
    $courseL  = strtolower(preg_replace('/\s+/', '', $code));

    $ouName  = "{$courseL}-{$programL}{$formData['yearLevel']}{$sectionL}";
    $ouParts = [$ouName, $formData['baseOU']];
    $dcParts = splitDomainIntoDcParts($formData['domain']);

    $commands = [];

    for ($i = 1; $i <= $formData['accountCount']; $i++) {
        $cnValue = "{$programL}{$sectionL}{$abbrev}" . ($formData['yearLevel'] * 100 + $i);

        $dn = buildDistinguishedName($cnValue, $ouParts, $dcParts);

        $commands[] = buildDsaddLine($dn, 'Lab', $cnValue, 'p@ssw0rd', 'yes');
    }

    return $commands;
}

// ============================================================
// DOG: multi-section paste logic
// ============================================================

// Reads one existing dsadd command line and pulls out the pieces we need.
// Returns null if the line doesn't look like a dsadd command we understand.
// Supports any number of ou= levels (e.g. one, two, three, ...).
function parseDsaddCommand($line)
{
    $pattern = '/cn=([^,]+),((?:ou=[^,"]+,?)+)((?:dc=[^,"]+,?)+)"\s*-fn\s+(\S+)\s+-ln\s+(\S+)\s+-pwd\s+(\S+)\s+-mustchpwd\s+(\S+)/i';

    if (!preg_match($pattern, $line, $matches)) {
        return null;
    }

    preg_match_all('/ou=([^,"]+)/i', $matches[2], $ouMatches);
    preg_match_all('/dc=([^,"]+)/i', $matches[3], $dcMatches);

    return [
        'cn' => trim($matches[1]),
        'ouParts' => array_map('trim', $ouMatches[1]),
        'dcParts' => array_map('trim', $dcMatches[1]),
        'firstName' => trim($matches[4]),
        'lastName' => trim($matches[5]),
        'password' => trim($matches[6]),
        'mustChangePwd' => trim($matches[7]),
    ];
}

// Same idea as generateAllCommands, but starting from an already-parsed command.
// Returns both the dsadd user lines AND the plain DN of each user created,
// since the DN list is needed later to build the group membership line.
function generateCommandsFromParsed($parsed, $count)
{
    $commands = [];
    $memberDns = [];

    for ($i = 0; $i < $count; $i++) {
        $cnValue = incrementTrailingNumber($parsed['cn'], $i);
        $lastNameValue = incrementTrailingNumber($parsed['lastName'], $i);

        $dn = buildDistinguishedName(
            $cnValue,
            $parsed['ouParts'],
            $parsed['dcParts']
        );

        $commands[] = buildDsaddLine(
            $dn,
            $parsed['firstName'],
            $lastNameValue,
            $parsed['password'],
            $parsed['mustChangePwd']
        );

        $memberDns[] = $dn;
    }

    return ['commands' => $commands, 'memberDns' => $memberDns];
}

// Takes the big textarea (one "command | count" per line) and turns it into
// a list of files, one per section. Also collects any lines it couldn't read.
// If $createGroups is true, each section also gets a security group (named
// after the section) with all its accounts added as members, and one extra
// file is added containing a master group that holds every section's group.
// If $createRunAll is true, a Run_all.bat is added that creates all OUs first,
// then calls every section bat in order (and groups.bat when applicable).
function parseMultiLineInput($rawText, $createGroups = false, $masterGroupName = 'Students', $createRunAll = false, $createMapping = false, $fileServer = '', $rootFolder = '', $netbios = '', $homeDrive = 'H')
{
    $lines = explode("\n", trim($rawText));
    $files = [];  // sectionName => array of generated command lines
    $errors = [];
    $warnings = [];

    $allSectionGroupDns = []; // collected as we go, used for the master group file
    $lastDcParts = [];
    $lastTopLevelOU = 'students'; // fallback, gets overwritten from real data below

    $runAllSections = []; // ['filename' => sanitized, 'ouName' => original case]
    $runAllMotherOU = '';
    $runAllDcParts  = [];
    $meta           = []; // sectionName => ['accountCount' => N] — the | N value per section

    // Mapping data: [ ['ouName' => 'EMC1A-CC103', 'users' => [['cn'=>'...','dn'=>'...'],...]], ... ]
    $mappingSections = [];

    // Every generated logon (CN) name, in input order — shown in the "All Logon Names" panel.
    $allLogonNames = [];

    // Property tracking for anomaly/pattern detection
    $passwords = [];
    $domains = [];
    $motherOUs = [];
    $mustChangePwds = [];

    foreach ($lines as $lineNumber => $rawLine) {
        $rawLine = trim($rawLine);
        $lineNumLabel = $lineNumber + 1;

        if ($rawLine === '') {
            continue; // skip blank lines
        }

        // Lines starting with // are comments/labels (like "//emc accounts") - skip them.
        if (strpos($rawLine, '//') === 0) {
            continue;
        }

        $parts = explode('|', $rawLine);

        if (count($parts) !== 2) {
            $errors[] = 'Line ' . $lineNumLabel . ": missing '| count' at the end.";
            continue;
        }

        $commandText = trim($parts[0]);
        $count = (int) trim($parts[1]);

        if ($count < 1) {
            $errors[] = 'Line ' . $lineNumLabel . ': count must be at least 1.';
            continue;
        }

        $parsed = parseDsaddCommand($commandText);

        if ($parsed === null) {
            $typoMsg = detectCommandTypo($commandText, $lineNumLabel);
            if ($typoMsg !== null) {
                $errors[] = $typoMsg;
            } else {
                $errors[] = 'Line ' . $lineNumLabel . ": couldn't understand this dsadd command.";
            }
            continue;
        }

        $sectionName = sanitizeFileName($parsed['ouParts'][0]);
        $generated = generateCommandsFromParsed($parsed, $count);
        $commands = $generated['commands'];

        // Collect properties for pattern anomaly checks
        $passwords[$lineNumLabel] = $parsed['password'];
        $domains[$lineNumLabel] = implode('.', $parsed['dcParts']);
        $motherOUs[$lineNumLabel] = end($parsed['ouParts']);
        $mustChangePwds[$lineNumLabel] = strtolower($parsed['mustChangePwd']);

        if ($createGroups) {
            $groupCn = strtolower($sectionName);
            $groupDn = buildDistinguishedName($groupCn, $parsed['ouParts'], $parsed['dcParts']);

            $commands[] = buildDsaddGroupLine($groupDn);
            // Chunked: each dsmod call holds ≤56 members to stay under CMD's 8,191-char limit.
            foreach (buildDsmodAddMembersLines($groupDn, $generated['memberDns']) as $dsmodLine) {
                $commands[] = $dsmodLine;
            }

            $allSectionGroupDns[] = $groupDn;
            $lastDcParts = $parsed['dcParts'];
            $lastTopLevelOU = end($parsed['ouParts']); // the outermost OU, e.g. "students"
        }

        $files[$sectionName] = $commands;
        $meta[$sectionName]  = ['accountCount' => $count]; // store the | N value

        // Track info needed to build Run_all.bat — store the original-case OU name
        // so the dsadd ou lines in Run_all.bat respect whatever the user typed.
        if ($createRunAll) {
            $runAllSections[] = [
                'filename' => $sectionName,          // sanitized, used in call "X.bat"
                'ouName'   => $parsed['ouParts'][0], // original case, used in dsadd ou
            ];
            $runAllMotherOU = end($parsed['ouParts']); // e.g. "students"
            $runAllDcParts  = $parsed['dcParts'];
        }

        // Collect mapping data per section — we know every CN+DN already, no dsquery needed.
        if ($createMapping) {
            $sectionUsers = [];
            foreach ($generated['memberDns'] as $idx => $memberDn) {
                // Rebuild CN from memberDns: CN is always the first part of the DN
                preg_match('/^cn=([^,]+)/i', $memberDn, $cnMatch);
                $sectionUsers[] = [
                    'cn' => $cnMatch[1] ?? '',
                    'dn' => $memberDn,
                ];
            }
            $mappingSections[] = [
                'ouName' => $parsed['ouParts'][0], // original case, e.g. EMC1A-CC103
                'users'  => $sectionUsers,
            ];
        }

        // Collect every generated logon name (works even when groups/mapping aren't requested).
        foreach ($generated['memberDns'] as $memberDn) {
            preg_match('/^cn=([^,]+)/i', $memberDn, $cnMatch);
            $logonName = $cnMatch[1] ?? '';
            if ($logonName !== '') {
                $allLogonNames[] = $logonName;
            }
        }
    }

    // Helper closure to find values that deviate from the most common setting
    $findAnomalies = function ($items, $itemName) use (&$warnings) {
        if (empty($items)) return;
        $counts = array_count_values($items);
        arsort($counts);
        $commonValue = key($counts);
        if (count($counts) > 1) {
            foreach ($items as $lineNum => $value) {
                if ($value !== $commonValue) {
                    $warnings[] = "Line {$lineNum} has a different {$itemName} (\"" . htmlspecialchars($value) . "\") compared to the most common one (\"" . htmlspecialchars($commonValue) . "\").";
                }
            }
        }
    };

    $findAnomalies($passwords, 'password');
    $findAnomalies($domains, 'domain suffix');
    $findAnomalies($motherOUs, 'mother OU');
    $findAnomalies($mustChangePwds, 'must change pwd flag');

    // Build the one extra "master group" file, only if groups were requested
    // and at least one section was generated successfully.
    if ($createGroups && !empty($allSectionGroupDns)) {
        $masterGroupDn = buildDistinguishedName($masterGroupName, [$lastTopLevelOU], $lastDcParts);

        $masterFileLines = [];
        $masterFileLines[] = '@echo off';
        $masterFileLines[] = '';
        $masterFileLines[] = buildDsaddGroupLine($masterGroupDn);
        $masterFileLines[] = '';
        // Chunked into ≤56 section groups per dsmod line — prevents silent truncation
        // when the school grows and total section count exceeds the CMD 8,191-char limit.
        foreach (buildDsmodAddMembersLines($masterGroupDn, $allSectionGroupDns) as $dsmodLine) {
            $masterFileLines[] = $dsmodLine;
        }
        $masterFileLines[] = '';
        $masterFileLines[] = 'pause';

        $files['groups'] = $masterFileLines; // saved as groups.bat
    }

    // Build Run_all.bat if requested and at least one section was processed.
    if ($createRunAll && !empty($runAllSections)) {
        $files['Run_all'] = buildRunAllBat($runAllSections, $runAllMotherOU, $runAllDcParts, $createGroups);
    }

    // Build mapping.bat if requested and we have section data + all required fields.
    if ($createMapping && !empty($mappingSections) && $fileServer !== '' && $rootFolder !== '' && $netbios !== '') {
        $files['mapping'] = buildMappingBat($mappingSections, $fileServer, $rootFolder, $netbios, $masterGroupName, $homeDrive);
    }

    return ['files' => $files, 'errors' => $errors, 'meta' => $meta, 'warnings' => $warnings, 'logonNames' => array_values(array_unique($allLogonNames))];
}

// ============================================================
// CAT: teacher account logic
// ============================================================

// Parses one teacher line: logon | firstname | lastname | section1 section2 ...
// Sections are optional — a teacher with no sections still gets an account in TeacherOU.bat.
// Returns null (blank/skip), 'skip' (comment), ['error'=>...], or a parsed array.
function parseTeacherLine($line, $lineNumber)
{
    $line = trim($line);
    if ($line === '') return null;
    if (strpos($line, '//') === 0) return 'skip';

    $parts = explode('|', $line);
    if (count($parts) < 3) {
        return ['error' => "Line {$lineNumber}: Expected format: logon | firstname | lastname | section1 section2 ..."];
    }

    $logon      = trim($parts[0]);
    $firstName  = trim($parts[1]);
    $lastName   = trim($parts[2]);
    $sectionsRaw = isset($parts[3]) ? trim($parts[3]) : '';

    if ($logon === '' || $firstName === '' || $lastName === '') {
        return ['error' => "Line {$lineNumber}: Missing required fields (logon, first name, last name)."];
    }

    $sections = ($sectionsRaw !== '') ? preg_split('/\s+/', $sectionsRaw) : [];
    $sections = array_values(array_filter($sections));

    return [
        'logon'     => $logon,
        'firstName' => $firstName,
        'lastName'  => $lastName,
        'sections'  => $sections,
    ];
}

// ============================================================
// CAT: new builders — match sample/ folder layout exactly
// ============================================================

// Helper: quote a value with spaces, leave plain if it's one word
function quoteIfSpaced($value)
{
    return (strpos($value, ' ') !== false) ? "\"" . $value . "\"" : $value;
}

// Builds TeacherOU.bat — accounts only, no home drive, no icacls.
// Matches sample/teacher/TeacherOU.bat exactly.
function buildTeacherOuBat($teachers, $config)
{
    $dcParts = splitDomainIntoDcParts($config['domain']);
    $dcStr   = implode(',', array_map(function ($dc) { return "dc={$dc}"; }, $dcParts));

    $lines   = [];
    $lines[] = '@echo off';
    $lines[] = "dsadd ou \"ou={$config['teacherOU']},{$dcStr}\"";

    foreach ($teachers as $t) {
        $dn    = "cn={$t['logon']},ou={$config['teacherOU']},{$dcStr}";
        $fnVal = quoteIfSpaced($t['firstName']);
        $lnVal = quoteIfSpaced($t['lastName']);
        $lines[] = '';
        $lines[] = "dsadd user \"{$dn}\" -fn {$fnVal} -ln {$lnVal} -pwd {$config['password']} -mustchpwd {$config['mustChangePwd']}";
    }

    $lines[] = '';
    $lines[] = 'pause';

    return $lines;
}

// Builds group/groups.bat — one master "Teachers" security group holding every
// teacher account as a member. Chunked via buildDsmodAddMembersLines so each
// dsmod line stays well under CMD's 8,191-character limit.
function buildTeacherGroupsBat($teachers, $config)
{
    $dcParts = splitDomainIntoDcParts($config['domain']);
    $dcStr   = implode(',', array_map(function ($dc) { return "dc={$dc}"; }, $dcParts));

    $groupDn = "cn=Teachers,ou={$config['teacherOU']},{$dcStr}";

    $memberDns = [];
    foreach ($teachers as $t) {
        $memberDns[] = "cn={$t['logon']},ou={$config['teacherOU']},{$dcStr}";
    }

    $lines   = [];
    $lines[] = '@echo off';
    $lines[] = '';
    $lines[] = buildDsaddGroupLine($groupDn);
    $lines[] = '';
    foreach (buildDsmodAddMembersLines($groupDn, $memberDns) as $dsmodLine) {
        $lines[] = $dsmodLine;
    }
    $lines[] = '';
    $lines[] = 'pause';

    return $lines;
}

// Builds {logon}NFTS.bat — Modify permission on each assigned section.
// Matches sample/allNFTS/JuanNFTS.bat exactly.
function buildTeacherNftsBat($teacher, $config)
{
    $lines   = [];
    $lines[] = '@echo off';
    $lines[] = "set TEACHER={$teacher['logon']}";
    $lines[] = 'for %%F in (';
    foreach ($teacher['sections'] as $section) {
        $lines[] = "    \"\\\\{$config['fileServer']}\\{$config['rootFolder']}\\{$section}\"";
    }
    $lines[] = ') do (';
    $lines[] = "    icacls %%F /grant \"{$config['netbios']}\\%TEACHER%:(OI)(CI)M\" /T";
    $lines[] = '    echo [OK] %TEACHER% added to %%F';
    $lines[] = ')';
    $lines[] = 'echo Done!';

    return $lines;
}

// Builds {logon}MultiDrive.bat — net use F: … /persistent:yes, auto-incrementing.
// Matches sample/allDrives/JuanMultiDrive.bat exactly.
function buildTeacherMultiDriveBat($teacher, $config)
{
    $lines   = [];
    $lines[] = '@echo off';

    $startOrd = ord('F');
    foreach ($teacher['sections'] as $idx => $section) {
        $letterOrd = $startOrd + $idx;
        $letter    = ($letterOrd <= ord('Z')) ? chr($letterOrd) : '?';
        $lines[]   = "net use {$letter}: \"\\\\{$config['fileServer']}\\{$config['rootFolder']}\\{$section}\" /persistent:yes";
    }

    $lines[] = 'echo All drives mapped';

    return $lines;
}

// The course+section list comes ONLY from the current Dog batch
// (session multiMeta keys) - never from stale .bat files on disk.
function dogBatchSections()
{
    $skipDogNames = ['groups', 'Run_all', 'mapping'];
    $sections     = [];

    if (!empty($_SESSION['multiMeta'])) {
        foreach ($_SESSION['multiMeta'] as $sn => $cmds) {
            if (!in_array($sn, $skipDogNames)) {
                $sections[] = $sn;
            }
        }
    }

    $sections = array_values(array_unique($sections));
    sort($sections, SORT_STRING);

    return $sections;
}

// ============================================================
// Main logic - figure out what the user is asking us to do
// ============================================================

$formSubmitted = ($_SERVER['REQUEST_METHOD'] === 'POST');
$action = $_POST['action'] ?? '';

// ---- Hak: single form ----
$formData = null;
$generatedCommands = [];

if ($formSubmitted && ($action === 'preview' || $action === 'download')) {
    $formData = getFormDataFromPost();

    if ($formData['accountCount'] > 0 && $formData['yearLevel'] >= 1 && $formData['yearLevel'] <= 4) {
        $generatedCommands = generateAllCommands($formData);
    }
}

// Hak: download the single .bat file
if ($formSubmitted && $action === 'download' && !empty($generatedCommands)) {
    $fileContent = implode("\r\n", $generatedCommands) . "\r\n";
    $safeFileName = sanitizeFileName($formData['courseCode'] ?: 'accounts');

    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $safeFileName . '.bat"');
    header('Content-Length: ' . strlen($fileContent));
    echo $fileContent;
    exit;
}

// ---- Meow: existing-course account generator ----
$meowFormData  = null;
$meowGenerated = [];

if ($formSubmitted && $action === 'generateMeow') {
    $meowFormData = getMeowFormDataFromPost();

    if ($meowFormData['accountCount'] > 0 && $meowFormData['yearLevel'] >= 1 && $meowFormData['yearLevel'] <= 4 && $meowFormData['courseCode'] !== '') {
        $meowGenerated = generateMeowCommands($meowFormData);
    }
}

// ---- Dog: multi-section paste ----
$multiGenerated = null; // ['files' => [...], 'errors' => [...]]

if ($formSubmitted && $action === 'generateMulti') {
    $rawMultiInput   = $_POST['multiInput'] ?? '';
    $createGroups    = isset($_POST['createGroups']);
    $masterGroupName = trim($_POST['masterGroupName'] ?? '') ?: 'Students';
    $createRunAll    = isset($_POST['createRunAll']);
    $createMapping   = isset($_POST['createMapping']);
    $fileServerName  = trim($_POST['fileServerName'] ?? '');
    $rootFolderName  = trim($_POST['rootFolderName'] ?? '');
    $netbiosName     = trim($_POST['netbiosName'] ?? '');
    $homeDriveLetter = strtoupper(trim($_POST['homeDriveLetter'] ?? 'H'));
    // Sanitize: must be a single A-Z letter
    if (!preg_match('/^[A-Z]$/', $homeDriveLetter)) {
        $homeDriveLetter = 'H';
    }

    $multiGenerated = parseMultiLineInput(
        $rawMultiInput,
        $createGroups,
        $masterGroupName,
        $createRunAll,
        $createMapping,
        $fileServerName,
        $rootFolderName,
        $netbiosName,
        $homeDriveLetter
    );

    // Save to the session so the download buttons (separate requests) can find the files again
    $_SESSION['multiFiles']        = $multiGenerated['files'];
    $_SESSION['multiMeta']         = $multiGenerated['meta'];
    $_SESSION['multiGenerated']    = $multiGenerated;
}

// Restore Dog results on any page load (not just right after generating),
// so the batch stays visible until the user clears it or closes the tab.
if (!$formSubmitted && isset($_SESSION['multiGenerated'])) {
    $multiGenerated = $_SESSION['multiGenerated'];
}

// Dog: download ONE of the generated files
if (isset($_GET['downloadFile'])) {
    $sectionName = $_GET['downloadFile'];

    if (isset($_SESSION['multiFiles'][$sectionName])) {
        $content = implode("\r\n", $_SESSION['multiFiles'][$sectionName]) . "\r\n";

        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . $sectionName . '.bat"');
        header('Content-Length: ' . strlen($content));
        echo $content;
        exit;
    }
}

// Dog: download ALL generated files as one .zip
if (isset($_GET['downloadZip']) && !empty($_SESSION['multiFiles'])) {
    $zip = new ZipArchive();
    $tempZipPath = tempnam(sys_get_temp_dir(), 'batch') . '.zip';

    if ($zip->open($tempZipPath, ZipArchive::CREATE) === true) {
        // Add all files into organized subfolders
        foreach ($_SESSION['multiFiles'] as $sectionName => $commands) {
            $content = implode("\r\n", $commands) . "\r\n";

            if ($sectionName === 'groups') {
                $zip->addFromString('group/groups.bat', $content);
            } elseif ($sectionName === 'mapping') {
                $zip->addFromString('mapping/mapping.bat', $content);
            } else {
                // All section .bat files and Run_all.bat go into all_sections/
                $zip->addFromString('all_sections/' . $sectionName . '.bat', $content);
            }
        }

        $zip->close();

        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="all_sections.zip"');
        header('Content-Length: ' . filesize($tempZipPath));
        readfile($tempZipPath);
        unlink($tempZipPath);
        exit;
    }
}

// ---- Cat: teacher accounts ----
$teacherGenerated  = null;
$teacherErrors     = [];
$teacherWarnings   = [];

// Section Library: replace with the current Dog batch's courses & sections
if (isset($_GET['reloadSections'])) {
    $_SESSION['sectionLibrary'] = implode("\n", dogBatchSections());
    header('Location: vv?tab=cat');
    exit;
}

// Dog: permanently clear the current batch from the session
if (isset($_GET['clearDog'])) {
    unset($_SESSION['multiGenerated'], $_SESSION['multiFiles'], $_SESSION['multiMeta']);
    header('Location: vv?tab=dog');
    exit;
}

if ($formSubmitted && $action === 'generateTeachers') {
    // Save Section Library to session so it persists across reloads
    $rawSectionLibrary = $_POST['sectionLibrary'] ?? '';
    $_SESSION['sectionLibrary'] = $rawSectionLibrary;

    $teacherInput       = trim($_POST['teacherInput'] ?? '');
    $teacherDomain      = trim($_POST['teacherDomain'] ?? '');
    $teacherOU          = trim($_POST['teacherOU'] ?? '') ?: 'teachers';
    $teacherFileServer  = trim($_POST['teacherFileServer'] ?? '');
    $teacherRootFolder  = trim($_POST['teacherRootFolder'] ?? '');
    $teacherNetbios     = trim($_POST['teacherNetbios'] ?? '');
    $teacherPassword    = trim($_POST['teacherPassword'] ?? '') ?: 'p@ssw0rd';
    $teacherMustChangePwd = trim($_POST['teacherMustChangePwd'] ?? 'yes');

    // Parse teacher input (sections now optional)
    $rawLines = explode("\n", $teacherInput);
    $teachers = [];
    foreach ($rawLines as $i => $rawLine) {
        $r = parseTeacherLine($rawLine, $i + 1);
        if ($r === null)  continue;
        if ($r === 'skip') continue;
        if (isset($r['error'])) { $teacherErrors[] = $r['error']; continue; }
        $teachers[] = $r;
    }

    if (empty($teachers)) $teacherErrors[] = 'No valid teacher entries found.';
    if ($teacherDomain === '') $teacherErrors[] = 'Domain name is required.';

    // Warn (not fail) if server fields missing — NFTS/MultiDrive will be skipped
    $hasServerFields = ($teacherFileServer !== '' && $teacherRootFolder !== '' && $teacherNetbios !== '');
    if (!$hasServerFields) {
        $teachersWithSections = array_filter($teachers, function($t){ return !empty($t['sections']); });
        if (!empty($teachersWithSections)) {
            $teacherWarnings[] = 'File Server, Root Folder, or NetBIOS name is missing — NFTS and MultiDrive files will not be generated for teachers with assigned sections.';
        }
    }

    if (empty($teacherErrors)) {
        $catConfig = [
            'domain'        => $teacherDomain,
            'teacherOU'     => $teacherOU,
            'fileServer'    => $teacherFileServer,
            'rootFolder'    => $teacherRootFolder,
            'netbios'       => $teacherNetbios,
            'password'      => $teacherPassword,
            'mustChangePwd' => $teacherMustChangePwd,
        ];

        // Always build TeacherOU.bat
        $_SESSION['teacherOuLines'] = buildTeacherOuBat($teachers, $catConfig);

        // Always build group/groups.bat (master Teachers security group)
        $_SESSION['teacherGroupsLines'] = buildTeacherGroupsBat($teachers, $catConfig);

        // Per-teacher NFTS + MultiDrive — only when server fields are set AND teacher has sections
        $_SESSION['teacherNftsFiles']        = [];
        $_SESSION['teacherMultiDriveFiles']  = [];

        if ($hasServerFields) {
            foreach ($teachers as $t) {
                if (!empty($t['sections'])) {
                    $_SESSION['teacherNftsFiles'][$t['logon']]       = buildTeacherNftsBat($t, $catConfig);
                    $_SESSION['teacherMultiDriveFiles'][$t['logon']] = buildTeacherMultiDriveBat($t, $catConfig);
                }
            }
        }

        $teacherGenerated = true;
    }
}

// Cat: download TeacherOU.bat
if (isset($_GET['downloadTeacherOu'])) {
    if (!empty($_SESSION['teacherOuLines'])) {
        $content = implode("\r\n", $_SESSION['teacherOuLines']) . "\r\n";
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="TeacherOU.bat"');
        header('Content-Length: ' . strlen($content));
        echo $content;
        exit;
    }
}

// Cat: download group/groups.bat
if (isset($_GET['downloadTeacherGroups'])) {
    if (!empty($_SESSION['teacherGroupsLines'])) {
        $content = implode("\r\n", $_SESSION['teacherGroupsLines']) . "\r\n";
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="groups.bat"');
        header('Content-Length: ' . strlen($content));
        echo $content;
        exit;
    }
}

// Cat: download full teacher ZIP (teacher/ + allNFTS/ + allDrives/)
if (isset($_GET['downloadTeacherZip']) && !empty($_SESSION['teacherOuLines'])) {
    $zip = new ZipArchive();
    $tempZipPath = tempnam(sys_get_temp_dir(), 'teacher') . '.zip';

    if ($zip->open($tempZipPath, ZipArchive::CREATE) === true) {
        // teacher/TeacherOU.bat
        $ouContent = implode("\r\n", $_SESSION['teacherOuLines']) . "\r\n";
        $zip->addFromString('teacher/TeacherOU.bat', $ouContent);

        // group/groups.bat
        if (!empty($_SESSION['teacherGroupsLines'])) {
            $groupsContent = implode("\r\n", $_SESSION['teacherGroupsLines']) . "\r\n";
            $zip->addFromString('group/groups.bat', $groupsContent);
        }

        // allNFTS/{logon}NFTS.bat
        if (!empty($_SESSION['teacherNftsFiles'])) {
            foreach ($_SESSION['teacherNftsFiles'] as $logon => $lines) {
                $content = implode("\r\n", $lines) . "\r\n";
                $zip->addFromString("allNFTS/{$logon}NFTS.bat", $content);
            }
        }

        // allNFTS/Run_all.bat — calls every {logon}NFTS.bat in one go
        if (!empty($_SESSION['teacherNftsFiles'])) {
            $runAllLines   = [];
            $runAllLines[] = '@echo off';
            foreach ($_SESSION['teacherNftsFiles'] as $logon => $lines) {
                $runAllLines[] = "call \"{$logon}NFTS.bat\"";
                $runAllLines[] = "echo {$logon}NFTS.bat is done";
            }
            $runAllLines[] = '';
            $runAllLines[] = 'echo ===== ALL DONE =====';
            $runAllLines[] = 'pause';
            $zip->addFromString('allNFTS/Run_all.bat', implode("\r\n", $runAllLines) . "\r\n");
        }

        // allDrives/{logon}MultiDrive.bat
        if (!empty($_SESSION['teacherMultiDriveFiles'])) {
            foreach ($_SESSION['teacherMultiDriveFiles'] as $logon => $lines) {
                $content = implode("\r\n", $lines) . "\r\n";
                $zip->addFromString("allDrives/{$logon}MultiDrive.bat", $content);
            }
        }

        $zip->close();

        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="teacher_scripts.zip"');
        header('Content-Length: ' . filesize($tempZipPath));
        readfile($tempZipPath);
        unlink($tempZipPath);
        exit;
    }
}

// Which tab should be open when the page loads?
$activeTab = 'hak';
if ($formSubmitted && $action === 'generateMulti') $activeTab = 'dog';
if ($teacherGenerated !== null) $activeTab = 'cat';
if (!empty($meowGenerated)) $activeTab = 'meow';

// A ?tab= URL param (clear/reload links) always wins over the server's choice
if (isset($_GET['tab']) && in_array($_GET['tab'], ['hak', 'dog', 'cat', 'meow'])) {
    $activeTab = $_GET['tab'];
}

// Expose the course catalog for the Meow tab's searchable dropdown
$existingCoursesJson = json_encode(array_values(loadExistingCourses()));

// Expose Section Library value for the Cat tab textarea
$sectionLibraryValue = $_SESSION['sectionLibrary'] ?? '';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hncsnet CheatSheet</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="style.css?v=<?= filemtime('style.css') ?>">
</head>

<body>

    <div class="page-wrapper">

        <h1>Hncsnet CheatSheet</h1>

        <div class="tab-buttons">
            <button type="button" class="tab-btn" data-tab="hak" id="tabBtnHak">Hak</button>
            <button type="button" class="tab-btn" data-tab="dog" id="tabBtnDog">Dog</button>
            <button type="button" class="tab-btn" data-tab="cat" id="tabBtnCat">Cat</button>
            <button type="button" class="tab-btn" data-tab="meow" id="tabBtnMeow">Meow</button>
        </div>

        <input type="hidden" id="activeTabFromServer" value="<?= $activeTab ?>">

        <!-- ==================== HAK TAB ==================== -->
        <div class="tab-panel" id="tabPanelHak">

            <p class="subtitle">Account Name Generator — enter course details to generate N student accounts.</p>

            <form method="POST" action="vv" id="bulkForm">

                <label for="courseCode">Course Code</label>
                <input type="text" id="courseCode" name="courseCode" placeholder="CC104"
                    value="<?= htmlspecialchars($formData['courseCode'] ?? '') ?>" required>

                <label for="courseTitle">Descriptive Title</label>
                <input type="text" id="courseTitle" name="courseTitle" placeholder="Data Structures and Algorithms"
                    value="<?= htmlspecialchars($formData['courseTitle'] ?? '') ?>" required>

                <label for="program">Program / Major</label>
                <input type="text" id="program" name="program" placeholder="HN"
                    value="<?= htmlspecialchars($formData['program'] ?? '') ?>" required>

                <label for="section">Section</label>
                <input type="text" id="section" name="section" placeholder="A"
                    value="<?= htmlspecialchars($formData['section'] ?? '') ?>" required>

                <label for="yearLevel">Year Level</label>
                <input type="number" id="yearLevel" name="yearLevel" min="1" max="4" placeholder="2"
                    value="<?= htmlspecialchars($formData['yearLevel'] ?? '') ?>" required>

                <label for="accountCount">Number of Accounts</label>
                <input type="number" id="accountCount" name="accountCount" min="1" placeholder="40"
                    value="<?= htmlspecialchars($formData['accountCount'] ?? '') ?>" required>

                <details class="collapse-section">
                    <summary class="collapse-header">Advanced settings</summary>
                    <div class="collapse-content">

                        <label for="abbrevOverride">Abbreviation override <span class="field-optional">(optional — overrides the auto abbreviation)</span></label>
                        <input type="text" id="abbrevOverride" name="abbrevOverride" placeholder="dsa"
                            value="<?= htmlspecialchars($formData['abbrevOverride'] ?? '') ?>">

                        <label for="domain">Domain name</label>
                        <input type="text" id="domain" name="domain" placeholder="asukalibo.local"
                            value="<?= htmlspecialchars($formData['domain'] ?? 'asukalibo.local') ?>">

                        <label for="motherOU">Mother OU</label>
                        <input type="text" id="motherOU" name="motherOU" placeholder="students"
                            value="<?= htmlspecialchars($formData['motherOU'] ?? 'students') ?>">

                        <label for="firstName">First name</label>
                        <input type="text" id="firstName" name="firstName" placeholder="Lab"
                            value="<?= htmlspecialchars($formData['firstName'] ?? 'Lab') ?>">

                        <label for="password">Password</label>
                        <input type="text" id="password" name="password" placeholder="p@ssw0rd"
                            value="<?= htmlspecialchars($formData['password'] ?? 'p@ssw0rd') ?>">

                        <label for="mustChangePwd">Must change pwd?</label>
                        <select id="mustChangePwd" name="mustChangePwd">
                            <option value="yes" <?= (($formData['mustChangePwd'] ?? 'yes') === 'yes') ? 'selected' : '' ?>>Yes</option>
                            <option value="no" <?= (($formData['mustChangePwd'] ?? '') === 'no') ? 'selected' : '' ?>>No</option>
                        </select>

                    </div>
                </details>

                <div class="button-row">
                    <button type="submit" name="action" value="preview" id="createBtn">Generate</button>

                    <?php if (!empty($generatedCommands)): ?>
                        <button type="submit" name="action" value="download" id="downloadBtn">Download .bat</button>
                    <?php endif; ?>
                </div>

            </form>

            <?php if ($formData !== null): ?>
                <a href="vv" class="clear-link">Start New Batch (clear form)</a>
            <?php endif; ?>

            <?php if (!empty($generatedCommands)): ?>
                <div class="preview-section">
                    <h2>Preview (
                        <?= count($generatedCommands) ?> accounts)
                    </h2>
                    <textarea readonly rows="15"><?= htmlspecialchars(implode("\n", $generatedCommands)) ?></textarea>
                </div>
            <?php elseif ($formData !== null): ?>
                <p class="error-message">Please check your inputs — the number of accounts must be at least 1 and the year level between 1 and 4.</p>
            <?php endif; ?>

        </div>

        <!-- ==================== DOG TAB ==================== -->
        <div class="tab-panel" id="tabPanelDog">

            <p class="subtitle">One dsadd command + count per line. Use <code>//</code> for comments.</p>

            <form method="POST" action="vv" id="multiForm">
                <label for="multiInput">Sections</label>

                <div class="import-export-row">
                    <button type="button" id="exportListBtn">Export My List (.txt)</button>
                    <button type="button" id="importListBtn">Import My List</button>
                    <input type="file" id="importFileInput" accept=".txt" style="display:none">
                </div>

                <textarea id="multiInput" name="multiInput" rows="10"
                    placeholder='// emc accounts
dsadd user "cn=mcapr901,ou=emc1a-cc103,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln mcapr901 -pwd p@ssw0rd -mustchpwd yes | 40'><?= htmlspecialchars($_POST['multiInput'] ?? '') ?></textarea>

                <div class="group-options-row">
                    <label class="checkbox-label">
                        <input type="checkbox" id="createGroups" name="createGroups" value="1"
                            <?= isset($_POST['createGroups']) ? 'checked' : '' ?>>
                        Create security groups + master group
                    </label>

                    <label for="masterGroupName">Master group name</label>
                    <input type="text" id="masterGroupName" name="masterGroupName" placeholder="Students"
                        value="<?= htmlspecialchars($_POST['masterGroupName'] ?? 'Students') ?>">

                    <label class="checkbox-label">
                        <input type="checkbox" id="createRunAll" name="createRunAll" value="1"
                            <?= isset($_POST['createRunAll']) ? 'checked' : '' ?>>
                        Generate Run_all.bat
                    </label>

                    <label class="checkbox-label">
                        <input type="checkbox" id="createMapping" name="createMapping" value="1"
                            <?= isset($_POST['createMapping']) ? 'checked' : '' ?>>
                        Generate folder mapping (mapping.bat)
                    </label>
                </div>

                <div id="mappingFields" style="<?= isset($_POST['createMapping']) ? '' : 'display:none' ?>">
                    <label for="fileServerName">File Server Name</label>
                    <input type="text" id="fileServerName" name="fileServerName"
                        placeholder="FileServer"
                        value="<?= htmlspecialchars($_POST['fileServerName'] ?? '') ?>">

                    <label for="rootFolderName">Root Folder Name</label>
                    <input type="text" id="rootFolderName" name="rootFolderName"
                        placeholder="25262ndSem"
                        value="<?= htmlspecialchars($_POST['rootFolderName'] ?? '') ?>">

                    <label for="netbiosName">Domain NetBIOS Name</label>
                    <input type="text" id="netbiosName" name="netbiosName"
                        placeholder="ASUKALIBO"
                        value="<?= htmlspecialchars($_POST['netbiosName'] ?? '') ?>">

                    <label for="homeDriveLetter">Home Drive Letter</label>
                    <select id="homeDriveLetter" name="homeDriveLetter">
                        <?php
                        $selectedDrive = strtoupper($_POST['homeDriveLetter'] ?? 'H');
                        foreach (range('A', 'Z') as $letter): ?>
                            <option value="<?= $letter ?>" <?= $letter === $selectedDrive ? 'selected' : '' ?>><?= $letter ?>:</option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div class="button-row">
                    <button type="submit" name="action" value="generateMulti" id="generateAllBtn">Generate All</button>
                </div>
            </form>

            <?php if ($multiGenerated !== null): ?>
                <a href="vv?clearDog=1" class="clear-link">Start New Batch (clear)</a>
            <?php endif; ?>

            <?php if ($multiGenerated !== null): ?>

                <?php if (!empty($multiGenerated['errors'])): ?>
                    <div class="error-message">
                        <p>Some lines had problems:</p>
                        <ul>
                            <?php foreach ($multiGenerated['errors'] as $error): ?>
                                <li>
                                    <?= htmlspecialchars($error) ?>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>

                <?php if (!empty($multiGenerated['warnings'])): ?>
                    <div class="warning-message">
                        <p>Verification Warnings:</p>
                        <ul>
                            <?php foreach ($multiGenerated['warnings'] as $warning): ?>
                                <li>
                                    <?= htmlspecialchars($warning) ?>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>

                <?php if (!empty($multiGenerated['files'])):
                // Special files that are NOT section bat files
                $skipFiles = ['groups', 'Run_all', 'mapping'];
                $meta       = $multiGenerated['meta'] ?? [];

                // Build per-program summary (exclude special files)
                $programs = [];
                foreach ($multiGenerated['files'] as $secName => $cmds) {
                    if (in_array($secName, $skipFiles)) continue;
                    $prog = detectProgram($secName);
                    if (!isset($programs[$prog])) {
                        $programs[$prog] = ['bats' => 0, 'accounts' => 0];
                    }
                    $programs[$prog]['bats']++;
                    $programs[$prog]['accounts'] += $meta[$secName]['accountCount'] ?? 0;
                }
                $totalBats     = array_sum(array_column($programs, 'bats'));
                $totalAccounts = array_sum(array_column($programs, 'accounts'));
                ?>
                <div class="preview-section">

                    <details class="collapse-section">
                        <summary class="collapse-header">📊 Summary</summary>
                        <div class="collapse-content">
                            <table class="results-table summary-table">
                                <thead>
                                    <tr>
                                        <th>Program</th>
                                        <th style="text-align:right">Bat Files</th>
                                        <th style="text-align:right">Accounts</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <?php foreach ($programs as $prog => $data): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($prog) ?></td>
                                        <td style="text-align:right"><?= $data['bats'] ?></td>
                                        <td style="text-align:right"><?= number_format($data['accounts']) ?></td>
                                    </tr>
                                <?php endforeach; ?>
                                </tbody>
                                <tfoot>
                                    <tr class="summary-total-row">
                                        <td>TOTAL</td>
                                        <td style="text-align:right"><?= $totalBats ?></td>
                                        <td style="text-align:right"><?= number_format($totalAccounts) ?></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </details>

                    <details class="collapse-section">
                        <summary class="collapse-header">Files (<?= count($multiGenerated['files']) ?>)</summary>
                        <div class="collapse-content">
                            <table class="results-table">
                                <?php foreach ($multiGenerated['files'] as $secName => $cmds): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($secName) ?>.bat</td>
                                        <td>
                                            <?php if (!in_array($secName, $skipFiles)): ?>
                                                <?= number_format($meta[$secName]['accountCount'] ?? 0) ?> accounts
                                            <?php else: ?>
                                                &mdash;
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <a href="vv?downloadFile=<?= urlencode($secName) ?>">Download</a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </table>

                            <div class="button-row">
                            <a href="vv?downloadZip=1" class="zip-download-btn">Download All as ZIP</a>
                        </div>
                    </details>

                    <details class="collapse-section">
                        <summary class="collapse-header">📚 All Courses &amp; Sections</summary>
                        <div class="collapse-content">
                            <?php
                            $allCourseSections = [];
                            foreach ($multiGenerated['meta'] as $secName => $secMeta) {
                                if (in_array($secName, $skipFiles)) continue;
                                $allCourseSections[] = $secName;
                            }
                            ?>
                            <textarea id="courseSectionsDog" readonly rows="10" style="width:100%; box-sizing:border-box; font-family:Consolas,monospace; font-size:13px; padding:10px; border:1px solid #ccc; border-radius:4px; background:#fafafa; margin-bottom:10px;"><?= htmlspecialchars(implode("\n", $allCourseSections)) ?></textarea>
                            <div class="import-export-row">
                                <button type="button" class="copy-btn" onclick="copyToClipboard('courseSectionsDog')">Copy to Clipboard</button>
                                <button type="button" class="export-btn" onclick="exportLogonNames('courseSectionsDog', 'courses_sections.txt')">Export .txt</button>
                            </div>
                        </div>
                    </details>

                    <details class="collapse-section">
                        <summary class="collapse-header">👤 All Logon Names</summary>
                        <div class="collapse-content">
                            <textarea id="logonNamesDog" readonly rows="10" style="width:100%; box-sizing:border-box; font-family:Consolas,monospace; font-size:13px; padding:10px; border:1px solid #ccc; border-radius:4px; background:#fafafa; margin-bottom:10px;"><?= htmlspecialchars(implode("\n", $multiGenerated['logonNames'] ?? [])) ?></textarea>
                            <div class="import-export-row">
                                <button type="button" class="copy-btn" onclick="copyToClipboard('logonNamesDog')">Copy to Clipboard</button>
                                <button type="button" class="export-btn" onclick="exportLogonNames('logonNamesDog', 'logon_names.txt')">Export .txt</button>
                            </div>
                        </div>
                    </details>

                </div>
                <?php endif; ?>

            <?php endif; ?>

        </div>

        <!-- ==================== CAT TAB ==================== -->
        <div class="tab-panel" id="tabPanelCat">

            <p class="subtitle">Create teacher accounts and assign section permissions.</p>

            <form method="POST" action="vv" id="teacherForm">

                <!-- ── Section Library ── -->
                <label for="sectionLibrary">Section Library</label>
                <p class="field-hint">One section name per line (e.g. <code>hn1a-cc101</code>). Use <em>Import Dog sections</em> to auto-load the current Dog batch, or paste manually. Edit freely — changes update the matrix grid below.</p>
                <div class="import-export-row">
                    <button type="button" id="exportSectionLibBtn">Export .txt</button>
                    <button type="button" id="importSectionLibBtn">Import .txt</button>
                    <a href="vv?reloadSections=1" class="reload-link">↻ Import Dog sections</a>
                    <input type="file" id="importSectionLibFile" accept=".txt" style="display:none">
                </div>
                <textarea id="sectionLibrary" name="sectionLibrary" rows="5"
                    placeholder="hn1a-cc101&#10;hn1a-cc102&#10;hn2a-ct3&#10;ist3a-net102"><?= htmlspecialchars($sectionLibraryValue) ?></textarea>

                <!-- ── Quick-add teacher ── -->
                <div class="cat-quick-add">
                    <label for="qaLogon" style="margin-top:0;">Add Teacher</label>
                    <div class="cat-quick-add-row">
                        <input type="text" id="qaLogon" placeholder="Logon / CN (e.g. juan)" maxlength="64">
                        <input type="text" id="qaFirst" placeholder="First name" maxlength="64">
                        <input type="text" id="qaLast" placeholder="Last name" maxlength="64">
                        <button type="button" id="qaAddBtn" class="btn btn-primary">Add Teacher</button>
                    </div>
                    <p class="field-hint" style="margin:6px 0 0;">Type the teacher's details, click <b>Add Teacher</b>, then tick their subjects in the grid below.</p>
                </div>

                <!-- ── Matrix grid (rendered by JS) ── -->
                <div id="catFilterBar"></div>
                <div id="catMatrixWrap"></div>

                <!-- ── Teacher data (collapsed source) ── -->
                <details class="collapse-section" style="margin-top:10px;">
                    <summary class="collapse-header">Teacher data (auto-generated — edit here if you want)</summary>
                    <div class="collapse-content">
                        <div class="import-export-row">
                            <button type="button" id="exportTeacherListBtn">Export My List (.txt)</button>
                            <button type="button" id="importTeacherListBtn">Import My List</button>
                            <input type="file" id="importTeacherFileInput" accept=".txt" style="display:none">
                        </div>
                        <textarea id="teacherInput" name="teacherInput" rows="6"
                            placeholder="juan | Juan | Dela_Cruz | hn1a-cc101 hn1a-cc102&#10;kathleen | Kathleen joy | Trinidad | hn2a-ct3"><?= htmlspecialchars($_POST['teacherInput'] ?? '') ?></textarea>
                    </div>
                </details>

                <div id="teacherTableView"></div>

                <!-- ── Config fields ── -->
                <label for="teacherOU">Teacher OU</label>
                <input type="text" id="teacherOU" name="teacherOU" placeholder="teachers"
                    value="<?= htmlspecialchars(trim($_POST['teacherOU'] ?? '') ?: 'teachers') ?>">

                <label for="teacherDomain">Domain name</label>
                <input type="text" id="teacherDomain" name="teacherDomain" placeholder="asukalibo.local"
                    value="<?= htmlspecialchars($_POST['teacherDomain'] ?? '') ?>" required>

                <label for="teacherFileServer">File Server Name <span class="field-optional">(optional — needed for NFTS &amp; MultiDrive)</span></label>
                <input type="text" id="teacherFileServer" name="teacherFileServer" placeholder="DC1"
                    value="<?= htmlspecialchars($_POST['teacherFileServer'] ?? '') ?>">

                <label for="teacherRootFolder">Root Folder Name <span class="field-optional">(optional — needed for NFTS &amp; MultiDrive)</span></label>
                <input type="text" id="teacherRootFolder" name="teacherRootFolder" placeholder="26271stSem"
                    value="<?= htmlspecialchars($_POST['teacherRootFolder'] ?? '') ?>">

                <label for="teacherNetbios">Domain NetBIOS Name <span class="field-optional">(optional — needed for NFTS &amp; MultiDrive)</span></label>
                <input type="text" id="teacherNetbios" name="teacherNetbios" placeholder="asukalibo"
                    value="<?= htmlspecialchars($_POST['teacherNetbios'] ?? '') ?>">

                <label for="teacherPassword">Password</label>
                <input type="text" id="teacherPassword" name="teacherPassword" placeholder="p@ssw0rd"
                    value="<?= htmlspecialchars(trim($_POST['teacherPassword'] ?? '') ?: 'p@ssw0rd') ?>">

                <label for="teacherMustChangePwd">Must change pwd?</label>
                <select id="teacherMustChangePwd" name="teacherMustChangePwd">
                    <option value="yes" <?= (($_POST['teacherMustChangePwd'] ?? 'yes') === 'yes') ? 'selected' : '' ?>>Yes</option>
                    <option value="no"  <?= (($_POST['teacherMustChangePwd'] ?? 'yes') === 'no')  ? 'selected' : '' ?>>No</option>
                </select>

                <div class="button-row" style="margin-top:20px;">
                    <button type="submit" name="action" value="generateTeachers" id="generateTeachersBtn">Generate Scripts</button>
                    <?php if ($teacherGenerated): ?>
                        <a href="vv?downloadTeacherOu=1" class="zip-download-btn">⬇ TeacherOU.bat</a>
                        <a href="vv?downloadTeacherGroups=1" class="zip-download-btn">⬇ groups.bat</a>
                        <a href="vv?downloadTeacherZip=1" class="zip-download-btn">⬇ Download ZIP</a>
                    <?php endif; ?>
                </div>
            </form>

            <?php if ($teacherGenerated): ?>
                <a href="vv?tab=cat" class="clear-link">Start New Batch (clear)</a>
            <?php endif; ?>

            <?php if (!empty($teacherWarnings)): ?>
                <div class="warning-message">
                    <p>Warnings:</p>
                    <ul>
                        <?php foreach ($teacherWarnings as $warn): ?>
                            <li><?= htmlspecialchars($warn) ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>

            <?php if (!empty($teacherErrors)): ?>
                <div class="error-message">
                    <p>Errors:</p>
                    <ul>
                        <?php foreach ($teacherErrors as $err): ?>
                            <li><?= htmlspecialchars($err) ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>

            <?php if ($teacherGenerated && !empty($_SESSION['teacherOuLines'])): ?>
                <div class="preview-section">
                    <details class="collapse-section">
                        <summary class="collapse-header">📄 Preview TeacherOU.bat</summary>
                        <div class="collapse-content">
                            <textarea readonly rows="12"><?= htmlspecialchars(implode("\n", $_SESSION['teacherOuLines'])) ?></textarea>
                        </div>
                    </details>

                    <?php if (!empty($_SESSION['teacherNftsFiles']) || !empty($_SESSION['teacherMultiDriveFiles'])): ?>
                    <details class="collapse-section">
                        <summary class="collapse-header">📂 Generated Files (NFTS &amp; MultiDrive)</summary>
                        <div class="collapse-content">
                            <table class="results-table">
                                <thead><tr><th>File</th><th>Sections</th></tr></thead>
                                <tbody>
                                <tr>
                                    <td><a href="vv?downloadTeacherGroups=1">group/groups.bat</a></td>
                                    <td>master Teachers group</td>
                                </tr>
                                <?php foreach ($_SESSION['teacherNftsFiles'] as $tLogon => $tLines): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($tLogon) ?>NFTS.bat</td>
                                        <td><?= count(array_filter($tLines, function($l){ return strpos($l, '"\\\\') !== false; })) ?> sections</td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php foreach ($_SESSION['teacherMultiDriveFiles'] as $tLogon => $tLines): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($tLogon) ?>MultiDrive.bat</td>
                                        <td><?= count(array_filter($tLines, function($l){ return strpos($l, 'net use') !== false; })) ?> drives mapped</td>
                                    </tr>
                                <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    </details>
                    <?php endif; ?>
                </div>
            <?php endif; ?>

        </div>



        <!-- ==================== MEOW TAB ==================== -->
        <div class="tab-panel" id="tabPanelMeow">

            <p class="subtitle">Account Generator — existing courses. Pick a course from the catalog, set the account details, and generate.</p>

            <form method="POST" action="vv" id="meowForm">

                <h3 class="meow-section-header">Domain Configuration</h3>

                <label for="meowDomain">Domain Name</label>
                <input type="text" id="meowDomain" name="meowDomain" placeholder="asukalibo.local"
                    value="<?= htmlspecialchars($meowFormData['domain'] ?? 'asukalibo.local') ?>">

                <label for="meowBaseOU">Base OU Path</label>
                <input type="text" id="meowBaseOU" name="meowBaseOU" placeholder="students"
                    value="<?= htmlspecialchars($meowFormData['baseOU'] ?? 'students') ?>">

                <h3 class="meow-section-header">Course Selection</h3>

                <label for="meowCourseSearch">Course Code <span class="field-optional">(search / select)</span></label>
                <div class="meow-course-picker">
                    <input type="text" id="meowCourseSearch" placeholder="🔍 type course code, abbreviation, or title…" autocomplete="off">
                    <input type="hidden" id="meowCourseCode" name="meowCourseCode" value="<?= htmlspecialchars($meowFormData['courseCode'] ?? '') ?>">
                    <div id="meowCourseList" class="meow-course-list"></div>
                </div>

                <label for="meowCourseTitle">Descriptive Title <span class="field-optional">(auto-filled, editable)</span></label>
                <input type="text" id="meowCourseTitle" name="meowCourseTitle" placeholder="Data Structures and Algorithms"
                    value="<?= htmlspecialchars($meowFormData['courseTitle'] ?? '') ?>">

                <h3 class="meow-section-header">Account Details</h3>

                <label for="meowProgram">Program / Major</label>
                <select id="meowProgram" name="meowProgram" required>
                    <option value="">— select —</option>
                    <option value="HN" <?= ($meowFormData['program'] ?? '') === 'HN' ? 'selected' : '' ?>>Bachelor of Science in Information Technology (HN)</option>
                    <option value="EMC" <?= ($meowFormData['program'] ?? '') === 'EMC' ? 'selected' : '' ?>>Bachelor of Science in Entertainment and Multimedia Computing</option>
                    <option value="IST" <?= ($meowFormData['program'] ?? '') === 'IST' ? 'selected' : '' ?>>Bachelor of Science in Information Technology (IST)</option>
                    <option value="SE" <?= ($meowFormData['program'] ?? '') === 'SE' ? 'selected' : '' ?>>Bachelor of Science in Information Technology (Software Engineering)</option>
                    <option value="BPO" <?= ($meowFormData['program'] ?? '') === 'BPO' ? 'selected' : '' ?>>Bachelor of Science in Information Technology (BPO)</option>
                    <option value="IS" <?= ($meowFormData['program'] ?? '') === 'IS' ? 'selected' : '' ?>>Bachelor of Science in Information Systems</option>
                    <option value="CE" <?= ($meowFormData['program'] ?? '') === 'CE' ? 'selected' : '' ?>>Bachelor of Science in Civil Engineering</option>
                    <option value="BTVTED" <?= ($meowFormData['program'] ?? '') === 'BTVTED' ? 'selected' : '' ?>>Bachelor of Technical-Vocational Teacher Education</option>
                </select>

                <label for="meowSection">Section</label>
                <select id="meowSection" name="meowSection" required>
                    <option value="">— select —</option>
                    <?php foreach (['A', 'B', 'C', 'D', 'E', 'F'] as $sec): ?>
                        <option value="<?= $sec ?>" <?= ($meowFormData['section'] ?? '') === $sec ? 'selected' : '' ?>>Section <?= $sec ?></option>
                    <?php endforeach; ?>
                </select>

                <label for="meowYear">Year Level</label>
                <select id="meowYear" name="meowYear" required>
                    <option value="">— select —</option>
                    <?php foreach ([1, 2, 3, 4] as $yr): ?>
                        <option value="<?= $yr ?>" <?= ($meowFormData['yearLevel'] ?? '') === $yr ? 'selected' : '' ?>>Year <?= $yr ?></option>
                    <?php endforeach; ?>
                </select>

                <label for="meowCount">Number of Accounts</label>
                <input type="number" id="meowCount" name="meowCount" min="1" placeholder="3"
                    value="<?= htmlspecialchars($meowFormData['accountCount'] ?? '') ?>" required>

                <div class="button-row">
                    <button type="submit" name="action" value="generateMeow" id="meowGenerateBtn">Generate</button>
                    <button type="button" id="meowCopyBtn">Copy</button>
                    <button type="button" id="meowClearBtn">Clear</button>
                </div>

            </form>

            <?php if ($meowFormData !== null && empty($meowGenerated)): ?>
                <p class="error-message">Please check your inputs — select a course, a program, a section, a year level (1–4), and at least 1 account.</p>
            <?php endif; ?>

            <?php if (!empty($meowGenerated)): ?>
                <div class="preview-section">
                    <h2>Preview (<?= count($meowGenerated) ?> accounts)</h2>
                    <textarea readonly rows="15" id="meowPreview"><?= htmlspecialchars(implode("\n", $meowGenerated)) ?></textarea>
                </div>
            <?php endif; ?>

        </div>

    </div>

    <script>
        window.EXISTING_COURSES = <?= $existingCoursesJson ?>;
    </script>

    <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="script.js?v=<?= filemtime('script.js') ?>"></script>
</body>

</html>