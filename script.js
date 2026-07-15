// script.js
// Small helper checks before the form is submitted.
// This is just a first line of defense - PHP still validates on its own.

document.addEventListener('DOMContentLoaded', function () {
    var form = document.getElementById('bulkForm');

    if (!form) {
        return; // safety check, in case the form isn't on the page
    }

    form.addEventListener('submit', function (event) {
        var bulkCountField = document.getElementById('bulkCount');
        var bulkCountValue = parseInt(bulkCountField.value, 10);

        if (isNaN(bulkCountValue) || bulkCountValue < 1) {
            alert('Please enter how many accounts you want to generate (1 or more).');
            event.preventDefault();
            return;
        }

        // Simple warning for large batches, just so nothing runs by accident.
        if (bulkCountValue > 100) {
            var confirmLargeBatch = confirm(
                'You are about to generate ' + bulkCountValue + ' accounts. Continue?'
            );

            if (!confirmLargeBatch) {
                event.preventDefault();
            }
        }
    });
});

// ---- Tab switching between Hak and Dog ----
document.addEventListener('DOMContentLoaded', function () {
    var tabButtons = document.querySelectorAll('.tab-btn');
    var panels = {
        hak: document.getElementById('tabPanelHak'),
        dog: document.getElementById('tabPanelDog')
    };
    var buttons = {
        hak: document.getElementById('tabBtnHak'),
        dog: document.getElementById('tabBtnDog')
    };

    function showTab(tabName) {
        Object.keys(panels).forEach(function (key) {
            panels[key].classList.toggle('active', key === tabName);
            buttons[key].classList.toggle('active', key === tabName);
        });
    }

    tabButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            showTab(button.getAttribute('data-tab'));
        });
    });

    // Decide which tab to open:
    // 1) If the URL says ?tab=dog (from the "clear" links), honor that first.
    // 2) Otherwise, open whichever tab the server just used (e.g. after Generate All).
    var urlParams = new URLSearchParams(window.location.search);
    var tabFromUrl = urlParams.get('tab');
    var serverActiveTab = document.getElementById('activeTabFromServer').value;

    var tabToShow = tabFromUrl === 'dog' ? 'dog' : (serverActiveTab === 'dog' ? 'dog' : 'hak');
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
        var textContent = multiInput.value;

        if (textContent.trim() === '') {
            alert('There is nothing to export yet - paste your sections first.');
            return;
        }

        var fileBlob = new Blob([textContent], { type: 'text/plain' });
        var downloadUrl = URL.createObjectURL(fileBlob);

        var tempLink = document.createElement('a');
        tempLink.href = downloadUrl;
        tempLink.download = 'my_sections_list.txt';
        document.body.appendChild(tempLink);
        tempLink.click();
        document.body.removeChild(tempLink);

        URL.revokeObjectURL(downloadUrl);
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