Feature: Scroll page

  Background:
    * Open browser and go to Formy site
    * Go to "Page Scroll" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Scroll" page
    * Check layout "ScrollPageVisual" file
    * Close browser

  Scenario: Page title Large page content - displays correctly
    * Check "Page Scroll" has page title "Large page content"
    * Close browser

  Scenario: Text paragraphs - displays correctly
    * Check "1st" text paragraph has text:
      | Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. |
    * Check "2d" text paragraph has text:
      | Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. |
    * Check "3d" text paragraph has text:
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. |
    * Check "4th" text paragraph has text:
      | Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur. |
    * Check "5th" text paragraph has text:
      | At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. |
    * Check "6th" text paragraph has text:
      | Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. |
    * Check "7th" text paragraph has text:
      | Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. |
    * Check "8th" text paragraph has text:
      | Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. |
    * Close browser

  Scenario: Full Name and Date titles - display correctly
    * Check "Full Name" title has the "Full Name" text
    * Check "Date" title has the "Date" text
    * Close browser

  Scenario: Full Name and Date placeholders - display correctly
    * Check "Full Name" placeholder has a "Full name" text
    * Check "Date" placeholder has a "MM/DD/YYYY" text
    * Close browser
#functional
  Scenario: Full Name and Date fields - unselected, enabled
    * Check "Full name" field has been unselected, enabled
    * Check "Date" field has been unselected, enabled
    * Close browser

  Scenario: Full Name field - enable for entering data
    * Check data has entered in the "full name" field after entering
      | џ®њƒ |
    * Clear the "full name" field via delete
    * Check data has entered in the "full name" field after entering
      | 01/01/2021 |
    * Clear the "full name" field via delete
    * Check data has entered in the "full name" field after entering
      | 00:00:00 |
    * Clear the "full name" field via delete
    * Check data has entered in the "full name" field after entering
      | 11111 |
    * Clear the "full name" field via delete
    * Check data has entered in the "full name" field after entering
      | Menlo Park |
    * Close browser

  Scenario: Date field - enable for entering data
    * Check data has entered in the "date" field after entering
      | џ®њƒ |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 01/01/2021 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 00:00:00 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 11111 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | Menlo Park |
    * Close browser

  Scenario: Full name field - enable to enter max length
#  100 symbols for full name field
    * Check data has entered in the "full name" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear the "full name" field via delete
    * Check data has entered in the "full name" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
    * Close browser

  Scenario: Date field - enable to enter max length
#  100 symbols for date field
    * Check data has entered in the "date" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
    * Close browser

  Scenario: Date field - enable to enter different date formats
    * Check data has entered in the "date" field after entering
      | 012/01/2021 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 2021/01/05 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 01/2021/21 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 01/010/2021 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | 01/01/21 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | January/01/2021 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | Jan/01/2021 |
    * Clear the "date" field via delete
    * Check data has entered in the "date" field after entering
      | Jan 1st, 2021 |
    * Clear the "date" field via delete
    * Close browser

  Scenario: Scroll page - scroll down to the page bottom
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Close browser

  Scenario: Scroll page - scroll up to the page top
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Scroll page on "500 px up to the page top"
    * Check scroll element has been "top" position
    * Close browser

  Scenario: Scroll page - scroll down to the page middle
    * Scroll page on "250 px down to the page middle"
    * Check scroll element has been "middle" position
    * Close browser

  Scenario: Scroll page - scroll up to the page middle
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Scroll page on "250 px up to the page middle"
    * Check scroll element has been "middle" position
    * Close browser

  Scenario: Refresh the page - scroll elements saved its position
    * Check scroll element has been "top" position
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Click on "Refresh" and check "scroll" page has opened
    * Check scroll element has been "after refresh bottom" position
    * Close browser

  Scenario: Backward to the page - scroll elements saved its position
    * Check scroll element has been "top" position
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "scroll" page has opened
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Click on "Forward" and check "form" page has opened
    * Click on "Backward" and check "scroll" page has opened
    * Check scroll element has been "bottom" position
    * Close browser

  Scenario: Forward to the page - scroll elements saved its position
    * Check scroll element has been "top" position
    * Scroll page on "500 px down to the page bottom"
    * Check scroll element has been "bottom" position
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "scroll" page has opened
    * Check scroll element has been "bottom" position
    * Close browser

#  header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "scroll" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
    * Click on "Forward" and check "modal" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
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
    * Click on "Backward" and check "scroll" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser