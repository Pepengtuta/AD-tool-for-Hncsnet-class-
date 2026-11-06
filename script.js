// script.js
// Small helper checks before the form is submitted.
// This is just a first line of defense - PHP still validates on its own.

document.addEventListener('DOMContentLoaded', function () {
    var form = document.getElementById('bulkForm');

    if (!form) {
        return; // safety check, in case the form isn't on the page
    }

    form.addEventListener('submit', function (event) {
        var courseCode = document.getElementById('courseCode');
        var program = document.getElementById('program');
        var section = document.getElementById('section');
        var yearLevelField = document.getElementById('yearLevel');
        var accountCountField = document.getElementById('accountCount');

        if (courseCode && courseCode.value.trim() === '') {
            alert('Please enter the course code (e.g. CC104).');
            event.preventDefault();
            courseCode.focus();
            return;
        }
        if (program && program.value.trim() === '') {
            alert('Please enter the program / major (e.g. HN).');
            event.preventDefault();
            program.focus();
            return;
        }
        if (section && section.value.trim() === '') {
            alert('Please enter the section (e.g. A).');
            event.preventDefault();
            section.focus();
            return;
        }

        var yearLevel = parseInt(yearLevelField.value, 10);
        if (isNaN(yearLevel) || yearLevel < 1 || yearLevel > 4) {
            alert('Please enter a year level between 1 and 4.');
            event.preventDefault();
            yearLevelField.focus();
            return;
        }

        var accountCountValue = parseInt(accountCountField.value, 10);

        if (isNaN(accountCountValue) || accountCountValue < 1) {
            alert('Please enter how many accounts you want to generate (1 or more).');
            event.preventDefault();
            accountCountField.focus();
            return;
        }

        // Simple warning for large batches, just so nothing runs by accident.
        if (accountCountValue > 100) {
            var confirmLargeBatch = confirm(
                'You are about to generate ' + accountCountValue + ' accounts. Continue?'
            );

            if (!confirmLargeBatch) {
                event.preventDefault();
            }
        }
    });
});

// ---- Tab switching between Hak, Dog, and Cat ----
document.addEventListener('DOMContentLoaded', function () {
    var tabButtons = document.querySelectorAll('.tab-btn');
    var panels = {
        hak: document.getElementById('tabPanelHak'),
        dog: document.getElementById('tabPanelDog'),
        cat: document.getElementById('tabPanelCat'),
        meow: document.getElementById('tabPanelMeow')
    };
    var buttons = {
        hak: document.getElementById('tabBtnHak'),
        dog: document.getElementById('tabBtnDog'),
        cat: document.getElementById('tabBtnCat'),
        meow: document.getElementById('tabBtnMeow')
    };

    function showTab(tabName) {
        Object.keys(panels).forEach(function (key) {
            if (panels[key]) panels[key].classList.toggle('active', key === tabName);
            if (buttons[key]) buttons[key].classList.toggle('active', key === tabName);
        });
    }

    tabButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            showTab(button.getAttribute('data-tab'));
        });
    });

    // Decide which tab to open:
    // 1) If the URL says ?tab=dog or ?tab=cat (from the "clear" links), honor that first.
    // 2) Otherwise, open whichever tab the server just used.
    var urlParams = new URLSearchParams(window.location.search);
    var tabFromUrl = urlParams.get('tab');
    var serverActiveTab = document.getElementById('activeTabFromServer').value;

    var validTabs = ['hak', 'dog', 'cat', 'meow'];
    var tabToShow = 'hak';
    if (tabFromUrl && validTabs.indexOf(tabFromUrl) !== -1) {
        tabToShow = tabFromUrl;
    } else if (serverActiveTab && validTabs.indexOf(serverActiveTab) !== -1) {
        tabToShow = serverActiveTab;
    }
    showTab(tabToShow);
});

// ---- Copy logon names to clipboard ----
function copyToClipboard(textareaId) {
    var textarea = document.getElementById(textareaId);
    if (!textarea) {
        alert('Could not find the logon names textarea.');
        return;
    }

    var textContent = textarea.value;

    if (textContent.trim() === '') {
        alert('There is nothing to copy.');
        return;
    }

    // Copy to clipboard
    navigator.clipboard.writeText(textContent).then(function () {
        alert('Logon names copied to clipboard!');
    }).catch(function (err) {
        alert('Failed to copy to clipboard: ' + err);
    });
}

// ---- Export logon names as a .txt file ----
function exportLogonNames(textareaId, fileName) {
    var textarea = document.getElementById(textareaId);
    if (!textarea) {
        alert('Could not find the logon names textarea.');
        return;
    }

    var textContent = textarea.value;

    if (textContent.trim() === '') {
        alert('There is nothing to export.');
        return;
    }

    var fileBlob = new Blob([textContent], { type: 'text/plain' });
    var downloadUrl = URL.createObjectURL(fileBlob);

    var tempLink = document.createElement('a');
    tempLink.href = downloadUrl;
    tempLink.download = fileName + '.txt';
    document.body.appendChild(tempLink);
    tempLink.click();
    document.body.removeChild(tempLink);

    URL.revokeObjectURL(downloadUrl);
}

// ---- Helper: generic .txt export from a textarea ----
function exportTextareaAsTxt(textarea, filename) {
    var text = textarea.value;
    if (text.trim() === '') {
        alert('Nothing to export — add some content first.');
        return;
    }
    var blob = new Blob([text], { type: 'text/plain' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// ---- Export / Import the Dog section list as a .txt file ----
document.addEventListener('DOMContentLoaded', function () {
    var multiInput = document.getElementById('multiInput');
    var exportBtn = document.getElementById('exportListBtn');
    var importBtn = document.getElementById('importListBtn');
    var importFileInput = document.getElementById('importFileInput');

    if (!multiInput || !exportBtn || !importBtn || !importFileInput) {
        return; // safety check, in case these aren't on the page
    }

    // Export: take whatever is in the textarea and let the user save it as a .txt file
    exportBtn.addEventListener('click', function () {
        exportTextareaAsTxt(multiInput, 'my_sections_list.txt');
    });

    // Import: clicking the visible button just opens the hidden file picker
    importBtn.addEventListener('click', function () {
        importFileInput.click();
    });

    // Once a file is picked, read it and drop its contents into the textarea
    importFileInput.addEventListener('change', function () {
        var chosenFile = importFileInput.files[0];

        if (!chosenFile) {
            return;
        }

        var reader = new FileReader();
        reader.onload = function (event) {
            multiInput.value = event.target.result;
        };
        reader.readAsText(chosenFile);
    });
});

// ---- Toggle mapping fields when the mapping checkbox is checked ----
document.addEventListener('DOMContentLoaded', function () {
    var createMappingChk = document.getElementById('createMapping');
    var mappingFields    = document.getElementById('mappingFields');

    if (!createMappingChk || !mappingFields) {
        return; // not on the page (e.g. Hak tab only)
    }

    createMappingChk.addEventListener('change', function () {
        mappingFields.style.display = this.checked ? '' : 'none';
    });
});

// ============================================================
// CAT TAB — Section Library + Matrix Grid + Teacher Table
// ============================================================

document.addEventListener('DOMContentLoaded', function () {
    // ---- Element refs ----
    var sectionLibEl = document.getElementById('sectionLibrary');
    var teacherInputEl = document.getElementById('teacherInput');
    var matrixWrapEl = document.getElementById('catMatrixWrap');
    var filterBarEl = document.getElementById('catFilterBar');
    var tableViewEl = document.getElementById('teacherTableView');

    if (!sectionLibEl || !teacherInputEl || !matrixWrapEl) return;

    // ---- Section Library: export/import ----
    var exportSLBtn = document.getElementById('exportSectionLibBtn');
    var importSLBtn = document.getElementById('importSectionLibBtn');
    var importSLFile = document.getElementById('importSectionLibFile');

    if (exportSLBtn) {
        exportSLBtn.addEventListener('click', function () {
            exportTextareaAsTxt(sectionLibEl, 'section_library.txt');
        });
    }
    if (importSLBtn && importSLFile) {
        importSLBtn.addEventListener('click', function () { importSLFile.click(); });
        importSLFile.addEventListener('change', function () {
            var f = importSLFile.files[0];
            if (!f) return;
            var reader = new FileReader();
            reader.onload = function (e) {
                sectionLibEl.value = e.target.result;
                rebuildAll();
            };
            reader.readAsText(f);
        });
    }

    // ---- Cat Tab: Export / Import teacher list ----
    var exportTeacherBtn  = document.getElementById('exportTeacherListBtn');
    var importTeacherBtn  = document.getElementById('importTeacherListBtn');
    var importTeacherFile = document.getElementById('importTeacherFileInput');

    if (exportTeacherBtn) {
        exportTeacherBtn.addEventListener('click', function () {
            exportTextareaAsTxt(teacherInputEl, 'my_teachers_list.txt');
        });
    }
    if (importTeacherBtn && importTeacherFile) {
        importTeacherBtn.addEventListener('click', function () { importTeacherFile.click(); });
        importTeacherFile.addEventListener('change', function () {
            var f = importTeacherFile.files[0];
            if (!f) return;
            var reader = new FileReader();
            reader.onload = function (e) {
                teacherInputEl.value = e.target.result;
                rebuildAll();
            };
            reader.readAsText(f);
        });
    }

    // ---- Parsing helpers ----
    function escapeHtml(str) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(String(str)));
        return d.innerHTML;
    }

    function getSections() {
        return sectionLibEl.value.split('\n')
            .map(function (l) { return l.trim(); })
            .filter(function (l) { return l !== '' && l.indexOf('//') !== 0; });
    }

    function parseTeacherLine(line) {
        var t = line.trim();
        if (t === '' || t.indexOf('//') === 0) return null;
        var parts = t.split('|');
        if (parts.length < 3) return null;
        var logon = parts[0].trim();
        var first = parts[1].trim();
        var last  = parts[2].trim();
        if (logon === '' || first === '' || last === '') return null;
        var rawSecs = parts[3] ? parts[3].trim() : '';
        var sections = rawSecs === '' ? [] : rawSecs.split(/\s+/).filter(function (s) { return s !== ''; });
        return { logon: logon, firstName: first, lastName: last, sections: sections };
    }

    function getTeachers() {
        return teacherInputEl.value.split('\n')
            .map(function (l) { return parseTeacherLine(l); })
            .filter(function (t) { return t !== null; });
    }

    // Return section tokens that are "finished" — i.e. followed by a space or
    // newline. The token currently being typed at the end of the input (no
    // trailing space yet) is excluded, so partial names like "cc106" never leak
    // into the Section Library while you're still typing them.
    // With forceAll=true (paste/blur/submit) every token counts as complete.
    function getCompleteSections(forceAll) {
        var complete = [];
        var lines = teacherInputEl.value.split('\n');
        lines.forEach(function (line) {
            if (line.trim() === '' || line.indexOf('//') === 0) return;
            var parts = line.split('|');
            if (parts.length < 4) return;
            var secPart = parts[3];
            var re = /\S+/g;
            var m;
            while ((m = re.exec(secPart)) !== null) {
                if (forceAll || secPart.charAt(re.lastIndex) !== '') {
                    complete.push(m[0]);
                }
            }
        });
        return complete;
    }

    function rebuildTextarea(teachers) {
        teacherInputEl.value = teachers.map(function (t) {
            return t.logon + ' | ' + t.firstName + ' | ' + t.lastName + ' | ' + t.sections.join(' ');
        }).join('\n');
    }

    // Add any sections mentioned in the teacher input to the Section Library
    // (append in first-seen order, never remove or reshuffle existing entries).
    // Only *completed* sections (followed by a space/newline) are added, so
    // mid-typing prefixes are never saved. Also drop old mid-typing artifacts:
    // entries that are a strict prefix of another entry and aren't assigned to
    // any teacher (e.g. "cc", "cc1", "cc106" when "cc106-hn1a" exists).
    function syncSectionsFromTeachers(forceAll) {
        var completeSections = getCompleteSections(forceAll);
        var current = sectionLibEl.value.split('\n')
            .map(function (l) { return l.trim(); })
            .filter(function (l) { return l !== '' && l.indexOf('//') !== 0; });

        var referenced = {};
        completeSections.forEach(function (s) { referenced[s] = true; });

        var cleaned = current.filter(function (s) {
            if (referenced[s]) return true;
            return !current.some(function (other) {
                return other !== s && other.indexOf(s) === 0;
            });
        });

        var seen = {};
        cleaned.forEach(function (s) { seen[s] = true; });
        var added = [];
        completeSections.forEach(function (s) {
            if (!seen[s]) {
                seen[s] = true;
                added.push(s);
            }
        });
        var result = cleaned.concat(added);
        if (result.length !== current.length || added.length > 0) {
            sectionLibEl.value = result.join('\n');
        }
    }

    // ---- Program detection for filter ----
    function detectProgram(name) {
        var n = name.toLowerCase();
        if (n.indexOf('emc') === 0) return 'EMC';
        if (n.indexOf('btv') === 0) return 'BTVTED';
        if (n.indexOf('bpo') === 0) return 'BPO';
        if (n.indexOf('ist') === 0) return 'IST';
        if (n.indexOf('is')  === 0) return 'IS';
        if (n.indexOf('se')  === 0) return 'SE';
        if (n.indexOf('hn')  === 0) return 'HN';
        if (n.indexOf('ce')  === 0) return 'CE';
        return 'OTHER';
    }

    // Current filter state
    var filterProgram = 'ALL';
    var filterSearch  = '';

    // Debounce timer for syncing completed sections into the library
    var syncTimer = null;

    // ---- Matrix renderer ----
    function renderMatrix(teachers, sections) {
        if (sections.length === 0 && teachers.length === 0) {
            updateFilterBar([]);
            matrixWrapEl.innerHTML = '';
            return;
        }

        // Filtered sections
        var visibleSections = sections.filter(function (s) {
            var progMatch = (filterProgram === 'ALL') || (detectProgram(s) === filterProgram);
            var searchMatch = (filterSearch === '') || (s.toLowerCase().indexOf(filterSearch.toLowerCase()) !== -1);
            return progMatch && searchMatch;
        });

        // Unique programs for the dropdown
        var programs = ['ALL'];
        sections.forEach(function (s) {
            var p = detectProgram(s);
            if (programs.indexOf(p) === -1) programs.push(p);
        });

        updateFilterBar(programs);

        if (sections.length === 0) {
            matrixWrapEl.innerHTML = '<p class="field-hint" style="margin-top:8px;">Add sections to the Section Library above to see the matrix.</p>';
            return;
        }

        if (teachers.length === 0) {
            matrixWrapEl.innerHTML = '<p class="field-hint" style="margin-top:8px;">Add teacher entries in the Teachers textarea below to see the matrix rows.</p>';
            return;
        }

        // Build a lookup: for each teacher, which sections are assigned?
        // sections appear in matrix column order
        // drive letter = F + position in visible sections assigned to this teacher

        var html = '<div class="cat-matrix-outer">';
        html += '<table class="cat-matrix">';
        html += '<thead><tr>';
        html += '<th class="mat-sticky-corner">Teacher</th>';
        visibleSections.forEach(function (s) {
            html += '<th><div class="col-header" title="' + escapeHtml(s) + '">' + escapeHtml(s) + '</div></th>';
        });
        html += '</tr></thead>';
        html += '<tbody>';

        teachers.forEach(function (t, ti) {
            // build an ordered list of all assigned sections that exist in the full sections list
            // drive letter is based on position in full sections (column) order
            var assignedInOrder = sections.filter(function (s) {
                return t.sections.indexOf(s) !== -1;
            });

            html += '<tr>';
            html += '<td class="mat-teacher-cell">' +
                '<span class="mat-logon">' + escapeHtml(t.logon) + '</span>' +
                '<span class="mat-fullname">' + escapeHtml(t.firstName + ' ' + t.lastName) + '</span>' +
                '<button type="button" class="mat-remove" data-teacher="' + ti + '" title="Remove teacher">×</button>' +
                '</td>';

            visibleSections.forEach(function (s) {
                var isChecked = t.sections.indexOf(s) !== -1;
                // Compute drive letter: position of s in assignedInOrder array
                var drivePos = assignedInOrder.indexOf(s);
                var driveLetter = '';
                if (isChecked && drivePos >= 0) {
                    var letterOrd = 'F'.charCodeAt(0) + drivePos;
                    driveLetter = letterOrd <= 'Z'.charCodeAt(0) ? String.fromCharCode(letterOrd) : '?';
                }

                var cellClass = isChecked ? 'mat-cell mat-cell-checked' : 'mat-cell';
                html += '<td class="' + cellClass + '">';
                html += '<label class="mat-label">';
                html += '<input type="checkbox" class="mat-chk" data-teacher="' + ti + '" data-section="' + escapeHtml(s) + '"' + (isChecked ? ' checked' : '') + '>';
                if (driveLetter) {
                    html += '<span class="drive-badge">' + driveLetter + ':</span>';
                }
                html += '</label>';
                html += '</td>';
            });

            html += '</tr>';
        });

        html += '</tbody></table></div>';

        matrixWrapEl.innerHTML = html;
        attachCheckboxEvents(teachers, sections);
        attachRemoveEvents(teachers, sections);
    }

    // Build the filter bar once into #catFilterBar; on later renders just
    // refresh the program dropdown options (preserving the current search text,
    // so typing in the search box never loses focus).
    function updateFilterBar(programs) {
        if (!filterBarEl) return;

        if (filterBarEl.innerHTML === '') {
            filterBarEl.innerHTML =
                '<div class="cat-filter-bar">' +
                '<label style="margin:0;font-weight:600;font-size:13px;">Filter:</label>' +
                '<select id="matrixProgramFilter"></select>' +
                '<input type="text" id="matrixSearchInput" placeholder="search section…" style="flex:1;">' +
                '</div>';
            attachFilterEvents();
        }

        var sel = document.getElementById('matrixProgramFilter');
        if (!sel) return;
        if (programs.indexOf(filterProgram) === -1) filterProgram = 'ALL';
        sel.innerHTML = programs.map(function (p) {
            return '<option value="' + p + '"' + (p === filterProgram ? ' selected' : '') + '>' + p + '</option>';
        }).join('');
    }

    function attachFilterEvents() {
        var progSel = document.getElementById('matrixProgramFilter');
        var searchInp = document.getElementById('matrixSearchInput');
        if (progSel) {
            progSel.addEventListener('change', function () {
                filterProgram = this.value;
                renderMatrix(getTeachers(), getSections());
            });
        }
        if (searchInp) {
            searchInp.addEventListener('input', function () {
                filterSearch = this.value;
                renderMatrix(getTeachers(), getSections());
            });
        }
    }

    function attachCheckboxEvents(teachers, sections) {
        var checkboxes = matrixWrapEl.querySelectorAll('.mat-chk');
        checkboxes.forEach(function (chk) {
            chk.addEventListener('change', function () {
                var ti = parseInt(this.getAttribute('data-teacher'), 10);
                var section = this.getAttribute('data-section');
                var t = teachers[ti];
                if (this.checked) {
                    if (t.sections.indexOf(section) === -1) {
                        // Insert at the column order position from the full sections list
                        var insertPos = sections.indexOf(section);
                        // Find where to insert to maintain column order
                        var insertIdx = t.sections.length;
                        for (var k = 0; k < t.sections.length; k++) {
                            if (sections.indexOf(t.sections[k]) > insertPos) {
                                insertIdx = k;
                                break;
                            }
                        }
                        t.sections.splice(insertIdx, 0, section);
                    }
                } else {
                    var pos = t.sections.indexOf(section);
                    if (pos !== -1) t.sections.splice(pos, 1);
                }
                rebuildTextarea(teachers);
                renderMatrix(teachers, sections);
                renderTeacherTable(teachers, sections);
            });
        });
    }

    function attachRemoveEvents(teachers, sections) {
        var removes = matrixWrapEl.querySelectorAll('.mat-remove');
        removes.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var ti = parseInt(this.getAttribute('data-teacher'), 10);
                teachers.splice(ti, 1);
                rebuildTextarea(teachers);
                renderMatrix(teachers, sections);
                renderTeacherTable(teachers, sections);
            });
        });
    }

    // ---- Teacher table (read-only summary with drive-letter badges) ----
    function renderTeacherTable(teachers, sections) {
        if (!tableViewEl) return;
        if (teachers.length === 0) {
            tableViewEl.innerHTML = '';
            return;
        }

        var html = '<div class="teacher-table-wrap"><table class="teacher-table">';
        html += '<thead><tr><th>Teacher</th><th>Assigned Sections</th></tr></thead><tbody>';

        teachers.forEach(function (t) {
            var assignedInOrder = sections.filter(function (s) {
                return t.sections.indexOf(s) !== -1;
            });
            // Also include any sections not in library (show them without a drive letter)
            var extraSections = t.sections.filter(function (s) {
                return sections.indexOf(s) === -1;
            });

            html += '<tr>';
            html += '<td class="teacher-name-cell">' + escapeHtml(t.logon) +
                '<span class="teacher-fullname">' + escapeHtml(t.firstName + ' ' + t.lastName) + '</span></td>';
            html += '<td class="teacher-sections-cell"><div class="teacher-sections-wrap">';

            var driveIdx = 0;
            assignedInOrder.forEach(function (s) {
                var letterOrd = 'F'.charCodeAt(0) + driveIdx;
                var driveLetter = letterOrd <= 'Z'.charCodeAt(0) ? String.fromCharCode(letterOrd) : '?';
                driveIdx++;
                html += '<span class="section-chip teacher-section-chip">' +
                    escapeHtml(s) +
                    '<span class="drive-badge-inline">' + driveLetter + ':</span>' +
                    '</span>';
            });
            // Extra sections not in library (no drive letter)
            extraSections.forEach(function (s) {
                html += '<span class="section-chip teacher-section-chip teacher-section-extra">' +
                    escapeHtml(s) + '</span>';
            });

            if (t.sections.length === 0) {
                html += '<span class="mat-no-sections">— no sections assigned —</span>';
            }

            html += '</div></td></tr>';
        });

        html += '</tbody></table></div>';
        tableViewEl.innerHTML = html;
    }

    // ---- Master rebuild ----
    function rebuildAll() {
        var teachers = getTeachers();
        var sections = getSections();
        renderMatrix(teachers, sections);
        renderTeacherTable(teachers, sections);
    }

    // ---- Quick-add teacher ----
    var qaLogon = document.getElementById('qaLogon');
    var qaFirst = document.getElementById('qaFirst');
    var qaLast  = document.getElementById('qaLast');
    var qaAddBtn = document.getElementById('qaAddBtn');

    function handleAddTeacher() {
        if (!qaLogon || !qaFirst || !qaLast) return;
        var logon = qaLogon.value.trim();
        var first = qaFirst.value.trim();
        var last  = qaLast.value.trim();
        if (logon === '') {
            alert('Enter the teacher logon / CN first.');
            qaLogon.focus();
            return;
        }
        var existing = getTeachers();
        for (var i = 0; i < existing.length; i++) {
            if (existing[i].logon.toLowerCase() === logon.toLowerCase()) {
                alert('Teacher "' + logon + '" is already in the list.');
                qaLogon.focus();
                return;
            }
        }
        first = first || logon;
        last  = last || first || logon;
        var line = logon + ' | ' + first + ' | ' + last + ' | ';
        var cur = teacherInputEl.value;
        teacherInputEl.value = (cur.trim() === '') ? line : cur.replace(/\s*$/, '\n') + line;
        syncSectionsFromTeachers();
        rebuildAll();
        qaLogon.value = '';
        qaFirst.value = '';
        qaLast.value = '';
        qaLogon.focus();
    }

    if (qaAddBtn) {
        qaAddBtn.addEventListener('click', handleAddTeacher);
        [qaLogon, qaFirst, qaLast].forEach(function (inp) {
            if (inp) inp.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    handleAddTeacher();
                }
            });
        });
    }

    // ---- Wire up live updates ----
    sectionLibEl.addEventListener('input', rebuildAll);
    teacherInputEl.addEventListener('input', function () {
        rebuildAll();
        clearTimeout(syncTimer);
        syncTimer = setTimeout(function () {
            syncSectionsFromTeachers(false);
            rebuildAll();
        }, 200);
    });

    // Pasted content has no trailing space, so treat every token as complete
    // and sync immediately — all pasted sections land in the library.
    teacherInputEl.addEventListener('paste', function () {
        clearTimeout(syncTimer);
        syncSectionsFromTeachers(true);
        rebuildAll();
    });

    // Finalize the trailing token when the user stops typing and clicks away
    // (no trailing space needed in that case).
    teacherInputEl.addEventListener('blur', function () {
        syncSectionsFromTeachers(true);
        rebuildAll();
    });

    // Belt-and-suspenders: sync right before the form is posted.
    var teacherFormEl = document.getElementById('teacherForm');
    if (teacherFormEl) {
        teacherFormEl.addEventListener('submit', function () {
            syncSectionsFromTeachers(true);
        });
    }

    // ---- Initial render ----
    rebuildAll();
});

// ============================================================
// MEOW TAB — searchable course picker + Generate/Copy/Clear
// ============================================================

document.addEventListener('DOMContentLoaded', function () {
    var searchEl = document.getElementById('meowCourseSearch');
    var codeEl   = document.getElementById('meowCourseCode');
    var titleEl  = document.getElementById('meowCourseTitle');
    var listEl   = document.getElementById('meowCourseList');
    var form     = document.getElementById('meowForm');
    var copyBtn  = document.getElementById('meowCopyBtn');
    var clearBtn = document.getElementById('meowClearBtn');
    var courses  = window.EXISTING_COURSES || [];

    if (!searchEl || !codeEl || !titleEl || !listEl) return;

    function escapeHtml(str) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(String(str)));
        return d.innerHTML;
    }

    var highlightedIndex = -1;

    function setHighlight(items, index) {
        items.forEach(function (li, i) {
            if (i === index) {
                li.classList.add('meow-course-selected');
                if (li.scrollIntoView) li.scrollIntoView({ block: 'nearest' });
            } else {
                li.classList.remove('meow-course-selected');
            }
        });
    }

    function renderResults(filter) {
        var q = (filter || '').toLowerCase().trim();
        var matches = [];

        courses.forEach(function (c) {
            if (q === '' ||
                c.code.toLowerCase().indexOf(q) !== -1 ||
                c.abbrev.toLowerCase().indexOf(q) !== -1 ||
                c.title.toLowerCase().indexOf(q) !== -1) {
                matches.push(c);
            }
        });

        if (matches.length === 0) {
            listEl.innerHTML = '<div class="meow-course-item meow-course-empty">No matching courses.</div>';
            listEl.style.display = 'block';
            highlightedIndex = -1;
            return;
        }

        var html = matches.slice(0, 60).map(function (c) {
            return '<div class="meow-course-item" data-code="' + escapeHtml(c.code) + '" data-title="' + escapeHtml(c.title) + '">' +
                '<span class="meow-course-code">' + escapeHtml(c.code) + '</span>' +
                '<span class="meow-course-title">' + escapeHtml(c.title) + '</span>' +
                '</div>';
        }).join('');

        listEl.innerHTML = html;
        listEl.style.display = 'block';
        // Default always starts from the first line up.
        highlightedIndex = 0;
        setHighlight(listEl.querySelectorAll('.meow-course-item[data-code]'), 0);
    }

    function selectCourse(code, title) {
        codeEl.value = code;
        searchEl.value = code + ' - ' + title;
        titleEl.value = title;
        listEl.style.display = 'none';
    }

    searchEl.addEventListener('input', function () {
        renderResults(this.value);
    });

    searchEl.addEventListener('focus', function () {
        if (this.value.trim() === '') renderResults('');
    });

    document.addEventListener('click', function (e) {
        var item = e.target.closest ? e.target.closest('.meow-course-item') : null;
        if (item && item.dataset.code) {
            selectCourse(item.dataset.code, item.dataset.title);
            return;
        }
        if (!e.target.closest || !e.target.closest('.meow-course-picker')) {
            listEl.style.display = 'none';
        }
    });

    searchEl.addEventListener('keydown', function (e) {
        var items = listEl.querySelectorAll('.meow-course-item[data-code]');
        if (e.key === 'Enter') {
            e.preventDefault();
            if (items.length === 0) return;
            var idx = (highlightedIndex >= 0 && highlightedIndex < items.length) ? highlightedIndex : 0;
            var item = items[idx];
            selectCourse(item.dataset.code, item.dataset.title);
        } else if (e.key === 'ArrowDown') {
            e.preventDefault();
            if (items.length === 0) return;
            highlightedIndex = (highlightedIndex + 1) % items.length;
            setHighlight(items, highlightedIndex);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            if (items.length === 0) return;
            highlightedIndex = (highlightedIndex - 1 + items.length) % items.length;
            setHighlight(items, highlightedIndex);
        }
    });

    if (copyBtn) {
        copyBtn.addEventListener('click', function () {
            var preview = document.getElementById('meowPreview');
            if (!preview || preview.value.trim() === '') {
                alert('Generate first — there is nothing to copy.');
                return;
            }
            copyToClipboard('meowPreview');
        });
    }

    if (clearBtn && form) {
        clearBtn.addEventListener('click', function () {
            // form.reset() restores the last POSTED values into the fields,
            // so force everything back to a truly fresh state afterwards.
            form.reset();
            searchEl.value = '';
            codeEl.value = '';
            titleEl.value = '';
            document.getElementById('meowDomain').value = '';
            document.getElementById('meowBaseOU').value = '';
            document.getElementById('meowProgram').value = '';
            document.getElementById('meowSection').value = '';
            document.getElementById('meowYear').value = '';
            document.getElementById('meowCount').value = '';
            var preview = document.getElementById('meowPreview');
            if (preview) preview.value = '';
            var errorMsg = document.querySelector('#tabPanelMeow .error-message');
            if (errorMsg) errorMsg.style.display = 'none';
            // Start fresh: reopen the picker from the first line up.
            renderResults('');
            searchEl.focus();
        });
    }

    if (form) {
        form.addEventListener('submit', function (e) {
            if (codeEl.value.trim() === '') {
                alert('Select a course from the list first.');
                e.preventDefault();
                searchEl.focus();
                return;
            }
            var count = parseInt(document.getElementById('meowCount').value, 10);
            if (isNaN(count) || count < 1) {
                alert('Please enter how many accounts you want to generate (1 or more).');
                e.preventDefault();
                document.getElementById('meowCount').focus();
                return;
            }
            if (count > 100) {
                var ok = confirm('You are about to generate ' + count + ' accounts. Continue?');
                if (!ok) e.preventDefault();
            }
        });
    }
});