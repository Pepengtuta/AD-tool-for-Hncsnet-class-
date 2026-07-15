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

// Builds a dsmod line that adds a list of member DNs to a group, all in one line
function buildDsmodAddMembersLine($groupDn, $memberDns)
{
    $quotedMembers = array_map(function ($dn) {
        return "\"{$dn}\"";
    }, $memberDns);

    return "dsmod group \"{$groupDn}\" -addmbr " . implode(' ', $quotedMembers);
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
// $fileServer  => e.g. "FileServer"
// $rootFolder  => e.g. "25262ndSem"
// $netbios     => e.g. "ASUKALIBO"
//
// The generated script is fully explicit (hardcoded sections/users, no .txt loop).
// It uses DOMAIN\username in icacls (fixes the replication-lag / unqualified-name problem)
// and points dsmod -hmdir at the section folder (matching original scripts).
function buildMappingBat($sectionData, $fileServer, $rootFolder, $netbios, $masterGroup, $homeDrive = 'H')
{
    $lines = [];
    $lines[] = '@echo off';
    $lines[] = 'setlocal enabledelayedexpansion';
    $lines[] = '';
    $lines[] = 'REM ===== CONFIG =====';
    $lines[] = "set SHAREPATH=\\\\{$fileServer}\\{$rootFolder}";
    $lines[] = "set DOMAIN={$netbios}";
    $lines[] = "set HOMEDRIVE={$homeDrive}:";
    $lines[] = '';

    foreach ($sectionData as $sec) {
        $ouName = $sec['ouName']; // original case, e.g. EMC1A-CC103
        $users  = $sec['users'];

        $lines[] = "REM ===== SECTION: {$ouName} =====";
        $lines[] = '';

        // Create section folder
        $lines[] = "REM --- Create section folder ---";
        $lines[] = "if not exist \"%SHAREPATH%\\{$ouName}\" mkdir \"%SHAREPATH%\\{$ouName}\"";
        $lines[] = '';

        // Section-level NTFS permissions
        $lines[] = "REM --- Section-level permissions ---";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\" /inheritance:r >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\" /grant \"{$masterGroup}:(OI)(CI)(RX)\" >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\" /grant \"Administrators:(OI)(CI)F\" >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\" /grant \"SYSTEM:(OI)(CI)F\" >nul";
        $lines[] = '';

        // Common folder
        $lines[] = "REM --- Create Common folder and set permissions ---";
        $lines[] = "if not exist \"%SHAREPATH%\\{$ouName}\\Common\" mkdir \"%SHAREPATH%\\{$ouName}\\Common\"";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\Common\" /inheritance:r >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\Common\" /grant \"{$masterGroup}:(OI)(CI)(RX)\" >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\Common\" /grant \"Administrators:(OI)(CI)F\" >nul";
        $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\Common\" /grant \"SYSTEM:(OI)(CI)F\" >nul";
        $lines[] = '';

        // Per-user folder, permissions, and home drive
        foreach ($users as $user) {
            $cn = $user['cn'];  // e.g. mcapr901
            $dn = $user['dn'];  // full DN string

            $lines[] = "REM --- User: {$cn} ---";
            $lines[] = "if not exist \"%SHAREPATH%\\{$ouName}\\{$cn}\" mkdir \"%SHAREPATH%\\{$ouName}\\{$cn}\"";
            $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\{$cn}\" /inheritance:r >nul";
            // Fully-qualified DOMAIN\username — avoids replication lag / name resolution issues
            $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\{$cn}\" /grant \"%DOMAIN%\\{$cn}:(OI)(CI)F\" >nul";
            $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\{$cn}\" /grant \"Administrators:(OI)(CI)F\" >nul";
            $lines[] = "icacls \"%SHAREPATH%\\{$ouName}\\{$cn}\" /grant \"SYSTEM:(OI)(CI)F\" >nul";
            // Home drive points to the section folder (matching original scripts)
            $lines[] = "dsmod user \"{$dn}\" -hmdir \"%SHAREPATH%\\{$ouName}\" -hmdrv %HOMEDRIVE%";
            $lines[] = "echo DONE: {$cn}";
            $lines[] = 'echo ------------------------------';
            $lines[] = '';
        }
    }

    $lines[] = 'echo ===== ALL DONE =====';
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

// Generates all the command lines as an array, one per account
function generateAllCommands($formData)
{
    $dcParts = splitDomainIntoDcParts($formData['domain']);
    $commands = [];

    for ($i = 0; $i < $formData['bulkCount']; $i++) {
        $cnValue = incrementTrailingNumber($formData['cn'], $i);
        $lastNameValue = incrementTrailingNumber($formData['lastName'], $i);

        $dn = buildDistinguishedName(
            $cnValue,
            [$formData['childOU'], $formData['motherOU']],
            $dcParts
        );

        $commands[] = buildDsaddLine(
            $dn,
            $formData['firstName'],
            $lastNameValue,
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
        'domain' => trim($_POST['domain'] ?? ''),
        'motherOU' => trim($_POST['motherOU'] ?? ''),
        'childOU' => trim($_POST['childOU'] ?? ''),
        'cn' => trim($_POST['cn'] ?? ''),
        'firstName' => trim($_POST['firstName'] ?? ''),
        'lastName' => trim($_POST['lastName'] ?? ''),
        'password' => trim($_POST['password'] ?? ''),
        'mustChangePwd' => trim($_POST['mustChangePwd'] ?? 'yes'),
        'bulkCount' => (int) ($_POST['bulkCount'] ?? 0),
    ];
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
            $commands[] = buildDsmodAddMembersLine($groupDn, $generated['memberDns']);

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
        $masterFileLines[] = buildDsaddGroupLine($masterGroupDn);
        $masterFileLines[] = buildDsmodAddMembersLine($masterGroupDn, $allSectionGroupDns);

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

    return ['files' => $files, 'errors' => $errors, 'meta' => $meta, 'warnings' => $warnings];
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

    if ($formData['bulkCount'] > 0) {
        $generatedCommands = generateAllCommands($formData);
    }
}

// Hak: download the single .bat file
if ($formSubmitted && $action === 'download' && !empty($generatedCommands)) {
    $fileContent = implode("\r\n", $generatedCommands) . "\r\n";
    $safeFileName = sanitizeFileName($formData['childOU']);

    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $safeFileName . '.bat"');
    header('Content-Length: ' . strlen($fileContent));
    echo $fileContent;
    exit;
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
    $_SESSION['multiFiles'] = $multiGenerated['files'];
    $_SESSION['multiMeta']  = $multiGenerated['meta'];
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

// Which tab should be open when the page loads?
$activeTab = ($multiGenerated !== null) ? 'dog' : 'hak';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hncsnet CheatSheet</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

    <div class="page-wrapper">

        <h1>Hncsnet CheatSheet</h1>

        <div class="tab-buttons">
            <button type="button" class="tab-btn" data-tab="hak" id="tabBtnHak">Hak</button>
            <button type="button" class="tab-btn" data-tab="dog" id="tabBtnDog">Dog</button>
        </div>

        <input type="hidden" id="activeTabFromServer" value="<?= $activeTab ?>">

        <!-- ==================== HAK TAB ==================== -->
        <div class="tab-panel" id="tabPanelHak">

            <p class="subtitle">One example account → generates the rest.</p>

            <form method="POST" action="vv" id="bulkForm">

                <label for="domain">Domain name</label>
                <input type="text" id="domain" name="domain" placeholder="asukalibo.local"
                    value="<?= htmlspecialchars($formData['domain'] ?? '') ?>" required>

                <label for="motherOU">Mother OU</label>
                <input type="text" id="motherOU" name="motherOU" placeholder="students"
                    value="<?= htmlspecialchars($formData['motherOU'] ?? '') ?>" required>

                <label for="childOU">Child OU</label>
                <input type="text" id="childOU" name="childOU" placeholder="EMC1A-CC103"
                    value="<?= htmlspecialchars($formData['childOU'] ?? '') ?>" required>

                <label for="cn">CN</label>
                <input type="text" id="cn" name="cn" placeholder="mcapr901"
                    value="<?= htmlspecialchars($formData['cn'] ?? '') ?>" required>

                <label for="firstName">First name</label>
                <input type="text" id="firstName" name="firstName" placeholder="Lab9"
                    value="<?= htmlspecialchars($formData['firstName'] ?? '') ?>" required>

                <label for="lastName">Last name (example)</label>
                <input type="text" id="lastName" name="lastName" placeholder="mcapr901"
                    value="<?= htmlspecialchars($formData['lastName'] ?? '') ?>" required>

                <label for="password">Password</label>
                <input type="text" id="password" name="password" placeholder="p@ssw0rd"
                    value="<?= htmlspecialchars($formData['password'] ?? '') ?>" required>

                <label for="mustChangePwd">Must change pwd?</label>
                <select id="mustChangePwd" name="mustChangePwd">
                    <option value="yes" <?= (($formData['mustChangePwd'] ?? '') === 'yes') ? 'selected' : '' ?>>Yes
                    </option>
                    <option value="no" <?= (($formData['mustChangePwd'] ?? '') === 'no') ? 'selected' : '' ?>>No</option>
                </select>

                <label for="bulkCount">Count</label>
                <input type="number" id="bulkCount" name="bulkCount" min="1" placeholder="40"
                    value="<?= htmlspecialchars($formData['bulkCount'] ?? '') ?>" required>

                <div class="button-row">
                    <button type="submit" name="action" value="preview" id="createBtn">Create</button>

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
                <p class="error-message">Please check your inputs — the number of accounts must be at least 1.</p>
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
                <a href="vv?tab=dog" class="clear-link">Start New Batch (clear)</a>
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
                        <summary class="collapse-header">🔑 All Logon Names</summary>
                        <div class="collapse-content">
                            <?php
                            $allLogonNames = [];
                            foreach ($multiGenerated['files'] as $secName => $cmds) {
                                if (in_array($secName, $skipFiles)) continue;
                                $allLogonNames = array_merge($allLogonNames, extractLogonNames($cmds));
                            }
                            ?>
                            <textarea id="logonNamesDog" readonly rows="10" style="width:100%; box-sizing:border-box; font-family:Consolas,monospace; font-size:13px; padding:10px; border:1px solid #ccc; border-radius:4px; background:#fafafa; margin-bottom:10px;"><?= htmlspecialchars(implode("\n", $allLogonNames)) ?></textarea>
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

    </div>

    <script src="script.js"></script>
</body>

</html>