Feature: Autocomplete page

  Background:
    * Open browser and go to Formy site
    * Go to "Autocomplete" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Autocomplete" page
    * Check layout "AutocompletePageVisual" file
    * Close browser
#functional
  Scenario: Dropdown - Address field has dropdown only
    * Check all fields is empty
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Check dropdown of "Address" field "has" displayed

    * Check data has entered in "Street address" field after entering
      | 1 Hacker Way |
    * Check dropdown of "Street address" field "has not" displayed

    * Check data has entered in "Street address 2" field after entering
      | 149 Commonwealth Dr |
    * Check dropdown of "Street address 2" field "has not" displayed

    * Check data has entered in "City" field after entering
      | Menlo Park |
    * Check dropdown of "City" field "has not" displayed

    * Check data has entered in "State" field after entering
      | CA |
    * Check dropdown of "State" field "has not" displayed

    * Check data has entered in "Zip code" field after entering
      | 94025 |
    * Check dropdown of "Zip code" field "has not" displayed

    * Check data has entered in "Country" field after entering
      | USA |
    * Check dropdown of "Country" field "has not" displayed
    * Close browser

  Scenario: Search - comparing typed symbols in the field with results in the dropdown
    * Check all fields is empty
    * Check data has entered in "Address" field after entering
      | Menl |
    * Check all 5 elements of dropdown list contains "Menl" in its titles
    * Close browser

  Scenario: Autocomplete fields
    * Check all fields is empty
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Choose "Menlo Park, Калифорния, США" and check other fields has not had data excluding city, state, country:
      | Менло-Парк                |
      | CA                        |
      | Соединенные Штаты Америки |
    * Close browser

  Scenario: Refresh the page - all fields are empty
    * Check all fields is empty
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Choose "Menlo Park, Калифорния, США" and check other fields has not had data excluding city, state, country:
      | Менло-Парк                |
      | CA                        |
      | Соединенные Штаты Америки |
    * Check data has entered in "Street address" field after entering
      | 1 Hacker Way |
    * Check data has entered in "Street address 2" field after entering
      | 149 Commonwealth Dr |
    * Check data has entered in "Zip code" field after entering
      | 94025 |
    * Refresh page and check all fields are empty
    * Close browser

  Scenario: Backward - all fields saved the data
    * Check all fields is empty
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Choose "Menlo Park, Калифорния, США" and check other fields has not had data excluding city, state, country:
      | Менло-Парк                |
      | CA                        |
      | Соединенные Штаты Америки |
    * Check data has entered in "Street address" field after entering
      | 1 Hacker Way |
    * Check data has entered in "Street address 2" field after entering
      | 149 Commonwealth Dr |
    * Check data has entered in "Zip code" field after entering
      | 94025 |
    * Click on "Form" and check "form" page has opened
    * Check "Complete Web Form" title is displayed
    * Click on "Backward" and check "autocomplete" page has opened
    * Check all fields saved its data: Address, Street address, Street address 2, City, State, Zip code, Country:
      | Menlo Park, Калифорния, США |
      | 1 Hacker Way                |
      | 149 Commonwealth Dr         |
      | Менло-Парк                  |
      | CA                          |
      | 94025                       |
      | Соединенные Штаты Америки   |
    * Close browser

  Scenario: Forward - all fields saved the data
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Choose "Menlo Park, Калифорния, США" and check other fields has not had data excluding city, state, country:
      | Менло-Парк                |
      | CA                        |
      | Соединенные Штаты Америки |
    * Check data has entered in "Street address" field after entering
      | 1 Hacker Way |
    * Check data has entered in "Street address 2" field after entering
      | 149 Commonwealth Dr |
    * Check data has entered in "Zip code" field after entering
      | 94025 |
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "autocomplete" page has opened
    * Check all fields saved its data: Address, Street address, Street address 2, City, State, Zip code, Country:
      | Menlo Park, Калифорния, США |
      | 1 Hacker Way                |
      | 149 Commonwealth Dr         |
      | Менло-Парк                  |
      | CA                          |
      | 94025                       |
      | Соединенные Штаты Америки   |
    * Close browser

  Scenario: Titles and Placeholders - display correctly
    * Check "Address" "title" is "Address"
    * Check "Address" "placeholder" is "Enter address"

    * Check "Street address" "title" is "Street address"
    * Check "Street address" "placeholder" is "Street address"

    * Check "Street address 2" "title" is "Street address 2"
    * Check "Street address 2" "placeholder" is "Street address 2"

    * Check "City" "title" is "City"
    * Check "City" "placeholder" is "City"

    * Check "State" "title" is "State"
    * Check "State" "placeholder" is "State"

    * Check "Zip code" "title" is "Zip code"
    * Check "Zip code" "placeholder" is "Zip code"

    * Check "Country" "title" is "Country"
    * Check "Country" "placeholder" is "Country"
    * Close browser

  Scenario: Input fields - opportunity to copy/paste/delete data
    * Check data has entered in "Address" field after entering
      | Menlo Park |
    * Copy data from "Address" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "Street address" field after entering
      | 1 Hacker Way |
    * Copy data from "Street address" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "Street address 2" field after entering
      | 149 Commonwealth Dr |
    * Copy data from "Street address 2" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "City" field after entering
      | Menlo Park |
    * Copy data from "City" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "State" field after entering
      | CA |
    * Copy data from "State" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "Zip code" field after entering
      | 94025 |
    * Copy data from "Zip code" field, clear via delete, paste data to the field and check the functions worked

    * Check data has entered in "Country" field after entering
      | USA |
    * Copy data from "Country" field, clear via delete, paste data to the field and check the functions worked
    * Close browser

  Scenario: Input fields - opportunity to enter miscellaneous symbols/date/time/numbers/letters
    * Check data has entered in "Address" field after entering
      | џ®њƒ |
    * Check data has entered in "Address" field after entering
      | 01/01/2021 |
    * Check data has entered in "Address" field after entering
      | 00:00:00 |
    * Check data has entered in "Address" field after entering
      | 11111 |
    * Check data has entered in "Address" field after entering
      | Menlo Park |

    * Check data has entered in "Street address" field after entering
      | џ®њƒ |
    * Check data has entered in "Street address" field after entering
      | 01/01/2021 |
    * Check data has entered in "Street address" field after entering
      | 00:00:00 |
    * Check data has entered in "Street address" field after entering
      | 11111 |
    * Check data has entered in "Street address" field after entering
      | Menlo Park |

    * Check data has entered in "Street address 2" field after entering
      | џ®њƒ |
    * Check data has entered in "Street address 2" field after entering
      | 01/01/2021 |
    * Check data has entered in "Street address 2" field after entering
      | 00:00:00 |
    * Check data has entered in "Street address 2" field after entering
      | 11111 |
    * Check data has entered in "Street address 2" field after entering
      | Menlo Park |

    * Check data has entered in "City" field after entering
      | џ®њƒ |
    * Check data has entered in "City" field after entering
      | 01/01/2021 |
    * Check data has entered in "City" field after entering
      | 00:00:00 |
    * Check data has entered in "City" field after entering
      | 11111 |
    * Check data has entered in "City" field after entering
      | Menlo Park |

    * Check data has entered in "State" field after entering
      | џ®њƒ |
    * Check data has entered in "State" field after entering
      | 01/01/2021 |
    * Check data has entered in "State" field after entering
      | 00:00:00 |
    * Check data has entered in "State" field after entering
      | 11111 |
    * Check data has entered in "State" field after entering
      | Menlo Park |

    * Check data has entered in "Zip code" field after entering
      | џ®њƒ |
    * Check data has entered in "Zip code" field after entering
      | 01/01/2021 |
    * Check data has entered in "Zip code" field after entering
      | 00:00:00 |
    * Check data has entered in "Zip code" field after entering
      | 11111 |
    * Check data has entered in "Zip code" field after entering
      | Menlo Park |

    * Check data has entered in "Country" field after entering
      | џ®њƒ |
    * Check data has entered in "Country" field after entering
      | 01/01/2021 |
    * Check data has entered in "Country" field after entering
      | 00:00:00 |
    * Check data has entered in "Country" field after entering
      | 11111 |
    * Check data has entered in "Country" field after entering
      | Menlo Park |
    * Close browser

  Scenario: Input fields - entering max length of symbols for value
# 100 symbols for Address field
    * Check data has entered in "Address" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "Address" field via delete
    * Check data has entered in "Address" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
# 100 symbols for Street address field
    * Check data has entered in "Street address" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "Street address" field via delete
    * Check data has entered in "Street address" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
# 100 symbols for Street address 2 field
    * Check data has entered in "Street address 2" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "Street address 2" field via delete
    * Check data has entered in "Street address 2" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
# 100 symbols for City field
    * Check data has entered in "City" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "City" field via delete
    * Check data has entered in "City" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
# 100 symbols for State field
    * Check data has entered in "State" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "State" field via delete
    * Check data has entered in "State" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
# 20 symbols for Zip code field
    * Check data has entered in "Zip code" field after entering
      | 12345678912345678912 |
    * Clear "Zip code" field via delete
    * Check data has entered in "Zip code" field after entering
      | 1 2 3 4 5 6 7 8 9 10 |
# 100 symbols for Country field
    * Check data has entered in "Country" field after entering
      | MenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenloMenlo |
    * Clear "Country" field via delete
    * Check data has entered in "Country" field after entering
      | Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo Menlo |
    * Close browser

#  header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "autocomplete" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "autocomplete" page has opened
    * Click on "Forward" and check "form" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
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
    * Click on "Backward" and check "autocomplete" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser