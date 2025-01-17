Feature: Checkbox page

  Background:
    * Open browser and go to Formy site
    * Go to "Checkbox" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Checkbox" page
    * Check layout "CheckboxPageVisual" file
    * Close browser
#functional
  Scenario: Page title Checkboxes - displays correctly
    * Check "Checkbox" has page title "Checkboxes"
    * Close browser

  Scenario: All checkboxes - clickability
    * Check all checkboxes has not selected
    * Click on checkbox "Checkbox1"
    * Click on checkbox "Checkbox2"
    * Click on checkbox "Checkbox3"
    * Check all checkboxes has selected
    * Close browser

  Scenario: Refresh - reset checkboxes
    * Check all checkboxes has not selected
    * Click on checkbox "Checkbox1"
    * Click on checkbox "Checkbox2"
    * Click on checkbox "Checkbox3"
    * Click on "Refresh" and check "checkbox" page has opened
    * Check all checkboxes has not selected
    * Close browser

  Scenario: Backward - saved checkboxes state (not selected)
    * Check all checkboxes has not selected
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "checkbox" page has opened
    * Check all checkboxes has not selected
    * Close browser

  Scenario: Backward - saved checkboxes state (selected)
    * Check all checkboxes has not selected
    * Click on checkbox "Checkbox1"
    * Click on checkbox "Checkbox2"
    * Click on checkbox "Checkbox3"
    * Check all checkboxes has selected
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "checkbox" page has opened
    * Check all checkboxes has selected
    * Close browser

  Scenario: Forward - saved checkboxes state (selected)
    * Check all checkboxes has not selected
    * Click on checkbox "Checkbox1"
    * Click on checkbox "Checkbox2"
    * Click on checkbox "Checkbox3"
    * Check all checkboxes has selected
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "checkbox" page has opened
    * Check all checkboxes has selected
    * Close browser

  Scenario: Forward - saved checkboxes state (not selected)
    * Check all checkboxes has not selected
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Go to "Checkbox" page
    * Check all checkboxes has not selected
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "checkbox" page has opened
    * Check all checkboxes has not selected
    * Close browser

#   #header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "autocomplete" page has opened
    * Close browser

  Scenario: Header, Components: Buttons referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "buttons" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Close browser

  Scenario: Header, Components: Drag and Drop referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "dragdrop" page has opened
    * Close browser

  Scenario: Header, Components: Dropdown referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "dropdown" page has opened
    * Close browser

  Scenario: Header, Components: Enabled and disabled elements referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "enabled" page has opened
    * Close browser

  Scenario: Header, Components: Enabled and disabled elements referral check
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
    * Click on "File Upload" and check "fileupload" page has opened
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "fileupload" page has opened
    * Close browser

  Scenario: Header, Components: Key and Mouse Press referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "keypress" page has opened
    * Close browser

  Scenario: Header, Components: Modal referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "modal" page has opened
    * Close browser

  Scenario: Header, Components: Page Scroll referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "scroll" page has opened
    * Close browser

  Scenario: Header, Components: Radio Button referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Close browser

  Scenario: Header, Components: Switch Window referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "switch-window" page has opened
    * Close browser

  Scenario: Header, Components: Complete Web Form referral check
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
    * Click on "Backward" and check "checkbox" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser