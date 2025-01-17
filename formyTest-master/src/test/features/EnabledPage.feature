Feature: Enabled and disabled elements page

  Background:
    * Open browser and go to Formy site
    * Go to "Enabled and disabled elements" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Enabled" page
    * Check layout "EnabledPageVisual" file
    * Close browser

  Scenario: Page title Dropdown - displays correctly
    * Check "Enabled and disabled elements" has page title "Enabled and Disabled elements"
    * Close browser
#functional
#disabled field
  Scenario: Disabled input - not selected, not enabled
    * Check disabled input field has not selected and not enabled
    * Close browser

  Scenario: Disabled input placeholder - correct title
    * Check placeholder of "disabled input field" has text "Disabled input here..."
    * Close browser

  Scenario: Disabled input - try to enter value
    * Enter "M1џ01/0100:00" in disabled input field and check data has not entered
    * Close browser

#enabled field
  Scenario: Enabled input - not selected, enabled
    * Check input field has not selected, enabled
    * Close browser

  Scenario: Enabled input field - empty field when page just opened
    * Check input field is empty
    * Close browser

  Scenario: Enabled input placeholder - correct title
    * Check placeholder of "enabled input field" has text "Input here..."
    * Close browser

  Scenario: Enabled input field - opportunity to enter miscellaneous symbols/date/time/numbers/letters
    * Check data has entered in enabled input field after entering
      | џ®њƒ |
    * Check data has entered in enabled input field after entering
      | 01/01/2021 |
    * Check data has entered in enabled input field after entering
      | 00:00:00 |
    * Check data has entered in enabled input field after entering
      | 11111 |
    * Check data has entered in enabled input field after entering
      | Menlo Park |
    * Close browser

  Scenario: Enabled input field - entering max length of symbols for value
# 100 symbols max length
    * Check data has entered in enabled input field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear enabled input field via delete
    * Check data has entered in enabled input field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
    * Close browser

  Scenario: Enabled input field - opportunity to copy/paste/delete data
    * Check data has entered in enabled input field after entering
      | Menlo Park |
    * Copy data from enabled input field, clear via delete, paste data to the field and check the functions have worked
    * Close browser

  Scenario: Refresh the page - disabled field save its state, enabled field - reset its state
    * Check input field is empty
    * Check disabled input field has not selected and not enabled
    * Check data has entered in enabled input field after entering
      | Menlo Park |
    * Click on "Refresh" and check "enabled" page has opened
    * Check input field is empty
    * Check disabled input field has not selected and not enabled
    * Close browser

  Scenario: Backward - all fields saved the data
    * Check input field is empty
    * Check disabled input field has not selected and not enabled
    * Check data has entered in enabled input field after entering
      | Menlo Park |
    * Click on "Form" and check "form" page has opened
    * Check "Complete Web Form" title is displayed
    * Click on "Backward" and check "enabled" page has opened
    * Check disabled input field has not selected and not enabled
    * Check field input has "Menlo Park" value
    * Close browser

  Scenario: Forward - all fields saved the data
    * Check input field is empty
    * Check disabled input field has not selected and not enabled
    * Check data has entered in enabled input field after entering
      | Menlo Park |
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "enabled" page has opened
    * Check disabled input field has not selected and not enabled
    * Check field input has "Menlo Park" value
    * Close browser

#  header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "enabled" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "File Upload" and check "fileupload" page has opened
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
    * Click on "Forward" and check "radiobutton" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
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
    * Click on "Backward" and check "enabled" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser