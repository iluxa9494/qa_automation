Feature: Drag and drop page

  Background:
    * Open browser and go to Formy site
    * Go to "Drag and Drop" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "DragAndDrop" page
    * Check layout "DragAndDropPageVisual" file
    * Close browser

  Scenario: Title Drag and Drop - displays correctly
    * Check "Drag and Drop" has page title "Drag the image into the box"
    * Close browser

  Scenario: Box title  - display
    * Check title "Drop here" has displayed
    * Close browser

  Scenario: Selenium logo - display
    * Check logo Selenium has displayed
    * Close browser
#functional
  Scenario: Drop logo - success dropping and box title changed
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo to the box
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Close browser

  Scenario: Back logo - box saved its state
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo to the box
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Drop Selenium logo tо the initial position
    * Check title "Dropped!" has displayed
    * Close browser

  Scenario: Box - save its state if logo has not crossed the border
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo "below" without touching box boundary
    * Check title "Drop here" has displayed
    * Drop Selenium logo "to the right" without touching box boundary
    * Check title "Drop here" has displayed
    * Drop Selenium logo "above" without touching box boundary
    * Check title "Drop here" has displayed
    * Close browser

  Scenario: Box - saved its state if logo has crossed the border less 50% of the side lengths of the logo
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo on the box border "less 50% of the right" side lengths of the logo
    * Check title "Drop here" has displayed
    * Drop Selenium logo on the box border "less 50% of the upper" side lengths of the logo
    * Check title "Drop here" has displayed
    * Drop Selenium logo on the box border "less 50% of the left" side lengths of the logo
    * Check title "Drop here" has displayed
    * Drop Selenium logo on the box border "less 50% of the down" side lengths of the logo
    * Check title "Drop here" has displayed
    * Close browser

  Scenario: Box - changed its state if logo has crossed the border more 50% of the side lengths of the logo
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo on the box border "more 50% of the right" side lengths of the logo
    * Check title "Dropped!" has displayed
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo on the box border "more 50% of the upper" side lengths of the logo
    * Check title "Dropped!" has displayed
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo on the box border "more 50% of the left" side lengths of the logo
    * Check title "Dropped!" has displayed
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo on the box border "more 50% of the down" side lengths of the logo
    * Check title "Dropped!" has displayed
    * Close browser

  Scenario: Refresh the page - all elements reset its settings
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo to the box
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Click on "Refresh" and check "dragdrop" page has opened
    * Check logo Selenium has displayed on initial position
    * Check title "Drop here" has displayed
    * Close browser

  Scenario: Backward to the page - all elements saved its settings
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo to the box
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "dragdrop" page has opened
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Close browser

  Scenario: Forward to the page - all elements saved its settings
    * Click on "Refresh" and check "dragdrop" page has opened
    * Drop Selenium logo to the box
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "dragdrop" page has opened
    * Check title "Dropped!" has displayed
    * Check Selenium logo has absent on initial position
    * Check Selenium logo has been in the box
    * Close browser

  #header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "dragdrop" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
    * Click on "Forward" and check "buttons" page has opened
    * Close browser

  Scenario: Header, Components: Checkbox referral check
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
    * Click on "Backward" and check "dragdrop" page has opened
    * Click on "Forward" and check "checkbox" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
    * Click on "Forward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
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
    * Click on "Backward" and check "dragdrop" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser