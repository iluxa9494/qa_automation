Feature: File upload page

  Background:
    * Open browser and go to Formy site
    * Go to "File Upload" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "FileUpload" page
    * Check layout "FileUploadPageVisual" file
    * Close browser

  Scenario: Page title File upload - displays correctly
    * Check "File upload" has page title "File upload"
    * Close browser

  Scenario: Choose button - title is "Choose"
    * Check "choose button" has "title" "Choose"
    * Close browser

  Scenario: Reset button - title is "Reset"
    * Check "reset button" has "title" "Reset"
    * Close browser

  Scenario: File upload field - placeholder is "Choose a file..."
    * Check "file upload field" has "placeholder" "Choose a file..."
    * Close browser
#functional
  Scenario: Choose button - enabled, clickable, not selected
    * Check "choose button" is enabled, not selected
    * Close browser

  Scenario: Choose button - upload window opened
    * Click on "choose button"
    * Close browser

  Scenario: File upload field - enabled, clickable, not selected
    * Check "file upload field" is enabled, not selected
    * Close browser

  Scenario: File upload field - upload window opened
    * Click on "file upload field"
    * Close browser

  Scenario: File upload field - upload files of the most popular file formats
    * Upload "JAVA.java" file
    * Check "JAVA.java" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "JS.js" file
    * Check "JS.js" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "JSON.json" file
    * Check "JSON.json" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "MOV.mov" file
    * Check "MOV.mov" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "MP3.mp3" file
    * Check "MP3.mp3" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "PNG.png" file
    * Check "PNG.png" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "TXT.txt" file
    * Check "TXT.txt" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "XML.xml" file
    * Check "XML.xml" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared

    * Upload "ZIP.zip" file
    * Check "ZIP.zip" file has displayed in file upload input
    * Click on "reset button"
    * Check file upload field has cleared
    * Close browser

  Scenario: File upload field - error page after pressing Enter
    * Upload "JAVA.java" file
    * Press Enter and check "fileupload" page has opened and title "The page you were looking for doesn't exist." has displayed
    * Close browser

  Scenario: Reset button - enabled, clickable, not selected
    * Check "reset button" is enabled, not selected
    * Close browser

  Scenario: Reset button - clear file upload field
    * Click on "reset button"
    * Check file upload field has cleared
    * Close browser

  Scenario: Refresh the page - file upload field reset its state
    * Upload "JAVA.java" file
    * Check "JAVA.java" file has displayed in file upload input
    * Click on "Refresh" and check "fileupload" page has opened
    * Check file upload field has cleared
    * Close browser

  Scenario: Backward to the page - file upload field saved its state
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Go to "File Upload" page
    * Upload "JAVA.java" file
    * Check "JAVA.java" file has displayed in file upload input
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Check "JAVA.java" file has displayed in file upload input
    * Close browser

  Scenario: Forward to the page - file upload field saved its state
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Go to "File Upload" page
    * Upload "JAVA.java" file
    * Check "JAVA.java" file has displayed in file upload input
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "fileupload" page has opened
    * Check "JAVA.java" file has displayed in file upload input
    * Close browser

  #header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Autocomplete" and check "autocomplete" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "autocomplete" page has opened
    * Close browser

  Scenario: Header, Components: Buttons referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Buttons" and check "buttons" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "buttons" page has opened
    * Close browser

  Scenario: Header, Components: Checkbox referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Checkbox" and check "checkbox" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "checkbox" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Datepicker" and check "datepicker" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Close browser

  Scenario: Header, Components: Drag and Drop referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Drag and Drop" and check "dragdrop" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "dragdrop" page has opened
    * Close browser

  Scenario: Header, Components: Dropdown referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Dropdown" and check "dropdown" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "dropdown" page has opened
    * Close browser

  Scenario: Header, Components: Enabled and disabled elements referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Enabled and disabled elements" and check "enabled" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "enabled" page has opened
    * Close browser

  Scenario: Header, Components: Key and Mouse Press referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Key and Mouse Press" and check "keypress" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "keypress" page has opened
    * Close browser

  Scenario: Header, Components: Modal referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Modal" and check "modal" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "modal" page has opened
    * Close browser

  Scenario: Header, Components: Page Scroll referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Page Scroll" and check "scroll" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "scroll" page has opened
    * Close browser

  Scenario: Header, Components: Radio Button referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Radio Button" and check "radiobutton" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Close browser

  Scenario: Header, Components: Switch Window referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Switch Window" and check "switch-window" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "switch-window" page has opened
    * Close browser

  Scenario: Header, Components: Complete Web Form referral check
    * Check "File upload" has page title "File upload"
    * Click on "Components" and check inside a dropdown list with:
      |Autocomplete|
      |Buttons|
      |Checkbox|
      |Datepicker|
      |Drag and Drop|
      |Dropdown|
      |Enabled and disabled elements|
      |File Upload|
      |Key and Mouse Press|
      |Modal|
      |Page Scroll|
      |Radio Button|
      |Switch Window|
      |Complete Web Form|
    * Click on "Complete Web Form" and check "form" page has opened
    * Click on "Backward" and check "fileupload" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser
