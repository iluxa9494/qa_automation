Feature: Switch window page

  Background:
    * Open browser and go to Formy site
    * Go to "Switch Window" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "SwitchWindow" page
    * Check layout "SwitchWindowPageVisual" file
    * Close browser

  Scenario: Page title Switch Window - displays correctly
    * Check "Switch Window" has page title "Switch Window"
    * Close browser

  Scenario: Open new tab and Open alert button titles - displays correctly
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Close browser
#functional
  Scenario: Open new tab and Open alert buttons - enabled, unselected
    * Check "open new tab" has been unselected and enabled
    * Check "open alert" has been unselected and enabled
    * Close browser

  Scenario: Open new tab button - opened Welcome to Formy page in a new window tab
    * Click on the "open new tab" button
    * Switch to a "new" window tab
    * Check "Welcome Page" has page title "Welcome to Formy"
    * Switch to a "previous" window tab
    * Check "Switch Window" has page title "Switch Window"
    * Close browser

  Scenario: Alert - accepted
    * Click on the "open alert" button
    * Check an alert has "opened"
    * Check an alert has a title "This is a test alert!"
    * Accept alert
    * Check an alert has "absent"
    * Close browser

  Scenario: Alert - dismiss
    * Click on the "open alert" button
    * Check an alert has "opened"
    * Check an alert has a title "This is a test alert!"
    * Dismiss alert
    * Check an alert has "absent"
    * Close browser

  Scenario: Refresh the page - all page elements have saved its state, redirects
    * Click on the "open new tab" button
    * Switch to a "new" window tab
    * Check "Welcome Page" has page title "Welcome to Formy"
    * Switch to a "previous" window tab
    * Check "Switch Window" has page title "Switch Window"
    * Click on "Refresh" and check "switch-window" page has opened
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Click on the "open alert" button
    * Check an alert has "opened"
    * Dismiss alert
    * Click on "Refresh" and check "switch-window" page has opened
    * Check an alert has "absent"
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Close browser

  Scenario: Backward to the page - all page elements have saved its state, redirects
    * Click on the "open new tab" button
    * Switch to a "new" window tab
    * Check "Welcome Page" has page title "Welcome to Formy"
    * Switch to a "previous" window tab
    * Check "Switch Window" has page title "Switch Window"
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Click on the "open alert" button
    * Check an alert has "opened"
    * Dismiss alert
    * Click on "Forward" and check "form" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Check an alert has "absent"
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Close browser

  Scenario: Forward to the page - all page elements have saved its state, redirects
    * Click on the "open new tab" button
    * Switch to a "new" window tab
    * Check "Welcome Page" has page title "Welcome to Formy"
    * Switch to a "previous" window tab
    * Check "Switch Window" has page title "Switch Window"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "switch-window" page has opened
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Click on the "open alert" button
    * Check an alert has "opened"
    * Dismiss alert
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "switch-window" page has opened
    * Check an alert has "absent"
    * Check "open new tab" button has an "Open new tab" title
    * Check "open alert" button has an "Open alert" title
    * Close browser

#header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Autocomplete" and check "autocomplete" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "autocomplete" page has opened
    * Close browser

  Scenario: Header, Components: Buttons referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Buttons" and check "buttons" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "buttons" page has opened
    * Close browser

  Scenario: Header, Components: Checkbox referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Checkbox" and check "checkbox" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "checkbox" page has opened
    * Close browser

  Scenario: Header, Components: Autocomplete referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Datepicker" and check "datepicker" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Close browser

  Scenario: Header, Components: Drag and Drop referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Drag and Drop" and check "dragdrop" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "dragdrop" page has opened
    * Close browser

  Scenario: Header, Components: Dropdown referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Dropdown" and check "dropdown" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "dropdown" page has opened
    * Close browser

  Scenario: Header, Components: Enabled and disabled elements referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Enabled and disabled elements" and check "enabled" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "enabled" page has opened
    * Close browser

  Scenario: Header, Components: Enabled and disabled elements referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "File Upload" and check "fileupload" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "fileupload" page has opened
    * Close browser

  Scenario: Header, Components: Key and Mouse Press referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Key and Mouse Press" and check "keypress" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "keypress" page has opened
    * Close browser

  Scenario: Header, Components: Modal referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Modal" and check "modal" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "modal" page has opened
    * Close browser

  Scenario: Header, Components: Page Scroll referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Page Scroll" and check "scroll" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "scroll" page has opened
    * Close browser

  Scenario: Header, Components: Radio Button referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Radio Button" and check "radiobutton" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Close browser

  Scenario: Header, Components: Complete Web Form referral check
    * Click on "Components" and check inside a dropdown list with:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "Complete Web Form" and check "form" page has opened
    * Click on "Backward" and check "switch-window" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser