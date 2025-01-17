Feature: Welcome to Formy page

  Background:
    * Open browser and go to Formy site

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Welcome" page
    * Check layout "WelcomePageVisual" file
    * Close browser

  Scenario: Page title Form - displays correctly
    * Check "Welcome Page" has page title "Welcome to Formy"
    * Close browser

  Scenario: Titles - displays correctly
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Close browser

  Scenario: All components list - displays correctly
    * Check list of the all components has displayed and contained:
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
    * Close browser
#functional
  Scenario: All components list - go to its page
    * Go to "Autocomplete" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Buttons" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Checkbox" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Datepicker" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Drag and Drop" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Dropdown" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Enabled and disabled elements" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "File Upload" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Key and Mouse Press" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Modal" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Radio Button" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Page Scroll" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Switch Window" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Go to "Complete Web Form" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: All components list - unselected, enabled
    * Check "Autocomplete" element has been unselected, enabled
    * Check "Buttons" element has been unselected, enabled
    * Check "Checkbox" element has been unselected, enabled
    * Check "Datepicker" element has been unselected, enabled
    * Check "Drag and Drop" element has been unselected, enabled
    * Check "Dropdown" element has been unselected, enabled
    * Check "Enabled and disabled elements" element has been unselected, enabled
    * Check "File Upload" element has been unselected, enabled
    * Check "Key and Mouse Press" element has been unselected, enabled
    * Check "Modal" element has been unselected, enabled
    * Check "Radio Button" element has been unselected, enabled
    * Check "Page Scroll" element has been unselected, enabled
    * Check "Switch Window" element has been unselected, enabled
    * Check "Complete Web Form" element has been unselected, enabled
    * Close browser

  Scenario: Backward to the page - all page elements have saved its state
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Go to "Autocomplete" page
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Close browser

  Scenario: Forward to the page - all page elements have saved its state
    * Go to "Autocomplete" page
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Click on "Backward" and check "autocomplete" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Close browser

  Scenario: Refresh the page - all page elements have saved its state
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Click on "Refresh" and check "Welcome to Formy" page has opened
    * Check "first title" has a "This is a simple site that has form components that can be used for testing purposes." text
    * Check "second title" has a "Here are the list of all the components" text
    * Check list of the all components has displayed and contained:
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
    * Close browser

#header
  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
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
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser