Feature: Radio button page

  Background:
    * Open browser and go to Formy site
    * Go to "Radio Button" page

#nonfunctional - layout/visual
  Scenario: Layout test
    * Make page dump of "RadioButton" page
    * Check layout "RadioButtonPageVisual" file
    * Close browser

  Scenario: Page title Radio buttons - displays correctly
    * Check "Radio Button" has page title "Radio buttons"
    * Close browser

  Scenario: Radio button titles - displays correctly
    * Check radio button "Radio button 1" has a "Radio button 1" title
    * Check radio button "Radio button 2" has a "Radio button 2" title
    * Check radio button "Radio button 3" has a "Radio button 3" title
    * Close browser
#functional
  Scenario: Radio buttons - successful select
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 2 radio button" element
    * Check "Radio button 2" radio button has "selected"
    * Click on the "Radio button 3 radio button" element
    * Check "Radio button 3" radio button has "selected"
    * Click on the "Radio button 1 radio button" element
    * Check "Radio button 1" radio button has "selected"
    * Close browser

  Scenario: Radio buttons - 1st button selected via title click, 2d and 3d via radio button click only
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 2 title" element
    * Check "Radio button 2" radio button has "unselected"
    * Click on the "Radio button 3 title" element
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 1 title" element
    * Check "Radio button 1" radio button has "selected"
    * Close browser

  Scenario: Radio buttons - escape has not change radio button state
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 2 radio button" element
    * Press Escape
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "selected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 3 radio button" element
    * Press Escape
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "selected"
    * Click on the "Radio button 1 radio button" element
    * Press Escape
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Close browser

  Scenario: Radio buttons - enter has not change radio button state
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 2 radio button" element
    * Press enter
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "selected"
    * Check "Radio button 3" radio button has "unselected"
    * Click on the "Radio button 3 radio button" element
    * Press enter
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "selected"
    * Click on the "Radio button 3 radio button" element
    * Press enter
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "selected"
    * Close browser

  Scenario: Refresh the page - all radio buttons has reset its state
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 2 radio button" element
    * Check "Radio button 2" radio button has "selected"
    * Click on "Refresh" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 3 radio button" element
    * Check "Radio button 3" radio button has "selected"
    * Click on "Refresh" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 3 radio button" element
    * Click on the "Radio button 1 radio button" element
    * Check "Radio button 1" radio button has "selected"
    * Click on "Refresh" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Close browser

  Scenario: Backward to the page - all radio buttons has saved its state
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 2 radio button" element
    * Check "Radio button 2" radio button has "selected"
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "selected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 3 radio button" element
    * Check "Radio button 3" radio button has "selected"
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "selected"

    * Click on the "Radio button 3 radio button" element
    * Click on the "Radio button 1 radio button" element
    * Check "Radio button 1" radio button has "selected"
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Close browser

  Scenario: Forward to the page - all radio buttons has saved its state
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 2 radio button" element
    * Check "Radio button 2" radio button has "selected"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "selected"
    * Check "Radio button 3" radio button has "unselected"

    * Click on the "Radio button 3 radio button" element
    * Check "Radio button 3" radio button has "selected"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "unselected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "selected"

    * Click on the "Radio button 3 radio button" element
    * Click on the "Radio button 1 radio button" element
    * Check "Radio button 1" radio button has "selected"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
    * Check "Radio button 1" radio button has "selected"
    * Check "Radio button 2" radio button has "unselected"
    * Check "Radio button 3" radio button has "unselected"
    * Close browser

# header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
    * Click on "Forward" and check "scroll" page has opened
    * Close browser

  Scenario: Header, Components: Switch Window referral check
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
    * Click on "Switch Window" and check "switch-window" page has opened
    * Click on "Backward" and check "radiobutton" page has opened
    * Click on "Forward" and check "switch-window" page has opened
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
    * Click on "Backward" and check "radiobutton" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser