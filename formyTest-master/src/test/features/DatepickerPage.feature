Feature: Datepicker page

  Background:
    * Open browser and go to Formy site
    * Go to "Datepicker" page

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Datepicker" page
    * Check layout "DatepickerPageVisual" file
    * Close browser
#functional
  Scenario: Pick the date from last month
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "previous" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from next month
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "next" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the current date
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from last year
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "previous" "year" is displayed
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from next year
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "next" "year" is displayed
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from last decade
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on and check "previous" "decade" is displayed
    * Click on the "2010" element and check "year" "2010" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from next decade
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on and check "next" "decade" is displayed
    * Click on the "2030" element and check "year" "2030" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from last century
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on the "decade" element and check "current century" "2000-2090" and "decades" are displayed:
      | 1990 |
      | 2000 |
      | 2010 |
      | 2020 |
      | 2030 |
      | 2040 |
      | 2050 |
      | 2060 |
      | 2070 |
      | 2080 |
      | 2090 |
      | 2100 |
    * Click on and check "previous" "century" is displayed
    * Click on the "1900" element and check "decade" "1900-1909" and "years" are displayed:
      | 1899 |
      | 1900 |
      | 1901 |
      | 1902 |
      | 1903 |
      | 1904 |
      | 1905 |
      | 1906 |
      | 1907 |
      | 1908 |
      | 1909 |
      | 1910 |
    * Click on the "1900" element and check "year" "1900" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from next century
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on the "decade" element and check "current century" "2000-2090" and "years" are displayed:
      | 1990 |
      | 2000 |
      | 2010 |
      | 2020 |
      | 2030 |
      | 2040 |
      | 2050 |
      | 2060 |
      | 2070 |
      | 2080 |
      | 2090 |
      | 2100 |
    * Click on and check "next" "century" is displayed
    * Click on the "2100" element and check "decade" "2100-2109" and "years" are displayed:
      | 2099 |
      | 2100 |
      | 2101 |
      | 2102 |
      | 2103 |
      | 2104 |
      | 2105 |
      | 2106 |
      | 2107 |
      | 2108 |
      | 2109 |
      | 2110 |
    * Click on the "2100" element and check "year" "2100" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from previous millennium
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on the "decade" element and check "current century" "2000-2090" and "decades" are displayed:
      | 1990 |
      | 2000 |
      | 2010 |
      | 2020 |
      | 2030 |
      | 2040 |
      | 2050 |
      | 2060 |
      | 2070 |
      | 2080 |
      | 2090 |
      | 2100 |
    * Click on the "century" element and check "current millennium" "2000-2900" and "centuries" are displayed:
      | 1900 |
      | 2000 |
      | 2100 |
      | 2200 |
      | 2300 |
      | 2400 |
      | 2500 |
      | 2600 |
      | 2700 |
      | 2800 |
      | 2900 |
      | 3000 |
    * Click on and check "previous" "millennium" is displayed
    * Click on the "1000" element and check "century" "1000-1090" and "decades" are displayed:
      | 990  |
      | 1000 |
      | 1010 |
      | 1020 |
      | 1030 |
      | 1040 |
      | 1050 |
      | 1060 |
      | 1070 |
      | 1080 |
      | 1090 |
      | 1100 |
    * Click on the "1000" element and check "decade" "1000-1009" and "years" are displayed:
      | 999  |
      | 1000 |
      | 1001 |
      | 1002 |
      | 1003 |
      | 1004 |
      | 1005 |
      | 1006 |
      | 1007 |
      | 1008 |
      | 1009 |
      | 1010 |
    * Click on the "1000" element and check "year" "1000" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick the date from next millennium
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on the "month" element and check "current year" "2021" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on the "year" element and check "current decade" "2020-2029" and "years" are displayed:
      | 2019 |
      | 2020 |
      | 2021 |
      | 2022 |
      | 2023 |
      | 2024 |
      | 2025 |
      | 2026 |
      | 2027 |
      | 2028 |
      | 2029 |
      | 2030 |
    * Click on the "decade" element and check "current century" "2000-2090" and "decades" are displayed:
      | 1990 |
      | 2000 |
      | 2010 |
      | 2020 |
      | 2030 |
      | 2040 |
      | 2050 |
      | 2060 |
      | 2070 |
      | 2080 |
      | 2090 |
      | 2100 |
    * Click on the "century" element and check "current millennium" "2000-2900" and "centuries" are displayed:
      | 1900 |
      | 2000 |
      | 2100 |
      | 2200 |
      | 2300 |
      | 2400 |
      | 2500 |
      | 2600 |
      | 2700 |
      | 2800 |
      | 2900 |
      | 3000 |
    * Click on and check "next" "millennium" is displayed
    * Click on the "3000" element and check "century" "3000-3090" and "decades" are displayed:
      | 2990 |
      | 3000 |
      | 3010 |
      | 3020 |
      | 3030 |
      | 3040 |
      | 3050 |
      | 3060 |
      | 3070 |
      | 3080 |
      | 3090 |
      | 3100 |
    * Click on the "3000" element and check "decade" "3000-3009" and "years" are displayed:
      | 2999 |
      | 3000 |
      | 3001 |
      | 3002 |
      | 3003 |
      | 3004 |
      | 3005 |
      | 3006 |
      | 3007 |
      | 3008 |
      | 3009 |
      | 3010 |
    * Click on the "3000" element and check "year" "3000" and "months" are displayed:
      | Jan |
      | Feb |
      | Mar |
      | Apr |
      | May |
      | Jun |
      | Jul |
      | Aug |
      | Sep |
      | Oct |
      | Nov |
      | Dec |
    * Click on and check "Jan" "month" is displayed
    * Pick "1th day" and check the calendar is "closed" and the picked date is displayed in the input field
    * Close browser

  Scenario: Pick of current date after text entering in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Type "hello" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Pick of current date after numbers entering in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Type "11111" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Keep the entered date on the field after pressing Enter
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Type "01/01/2021" and press Enter
    * Check "01/01/2021" "date" is displayed
    * Close browser

  Scenario: Keep the entered date on the field after click
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Type "01/01/2021" and press Enter
    * Click on title Datepicker and check calendar is "closed"
    * Check "01/01/2021" "date" is displayed
    * Close browser

  Scenario: Pick of current date after miscellaneous symbols entering in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Type "≈ç¬ø©" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Deleting numbers inputted after the date in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Click on input field and check calendar is "opened"
    * Type "22222" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Deleting text inputted after the date in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Click on input field and check calendar is "opened"
    * Type "hi" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Deleting miscellaneous symbols inputted after the date in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Click on input field and check calendar is "opened"
    * Type "џ®њƒ" and press Enter
    * Check "current" "date" is displayed
    * Close browser

  Scenario: Saving calendar state after page field click
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "previous" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Click on input field and check calendar is "opened"
    * Check "previous" "month" is displayed
    * Close browser

  Scenario: "Refresh" - deleting the date from input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Close browser

  Scenario: "Refresh" - cancel calendar state (last month)
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "previous" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Check "current" "month" is displayed
    * Close browser

  Scenario: "Refresh" - cancel calendar state (next month)
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "next" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Check "current" "month" is displayed
    * Close browser

  Scenario: "Backward" - saving the date in the input field
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "datepicker" page has opened
    * Check "current" "date" is displayed
    * Close browser

  Scenario: "Backward" - cancel calendar state (last month)
    * Refresh the page and check: the datepicker page is opened and the input field is empty
    * Click on input field and check calendar is "opened"
    * Click on and check "previous" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "datepicker" page has opened
    * Click on input field and check calendar is "opened"
    * Check "current date" "in the calendar" is displayed
    * Close browser

  Scenario: "Backward" - cancel calendar state (next month)
    * Click on input field and check calendar is "opened"
    * Click on and check "next" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "datepicker" page has opened
    * Click on input field and check calendar is "opened"
    * Check "current date" "in the calendar" is displayed
    * Close browser

  Scenario: "Forward" - saving the date in the input field
    * Click on input field and check calendar is "opened"
    * Pick "current date" and check the calendar is "closed" and the picked date is displayed in the input field
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Check "current" "date" is displayed
    * Close browser

  Scenario: "Forward" - cancel calendar state (last month)
    * Click on input field and check calendar is "opened"
    * Click on and check "previous" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Click on input field and check calendar is "opened"
    * Check "current" "month" is displayed
    * Close browser

  Scenario: "Forward" - cancel calendar state (next month)
    * Click on input field and check calendar is "opened"
    * Click on and check "next" "month" is displayed
    * Click on title Datepicker and check calendar is "closed"
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "datepicker" page has opened
    * Click on input field and check calendar is "opened"
    * Check "current" "month" is displayed
    * Close browser

   #header
  Scenario: Header: Formy referral check
    * Click on "Formy" and check "Welcome to Formy" page has opened
    * Click on "Backward" and check "datepicker" page has opened
    * Click on "Forward" and check "Welcome to Formy" page has opened
    * Close browser

  Scenario: Header: Form referral check
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
    * Click on "Forward" and check "checkbox" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
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
    * Click on "Backward" and check "datepicker" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser