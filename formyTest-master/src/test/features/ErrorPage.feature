Feature: Error page

  Background:
    * Open browser and go to Formy site
    * Go to "Dropdown" page
    * Click on dropdown button
    * Check elements have displayed:
      | Autocomplete                  |
      | Buttons                       |
      | Checkbox                      |
      | Datepicker                    |
      | Drag and Drop                 |
      | Dropdown                      |
      | Enabled and disabled elements |
      | File Upload                   |
      | File Download                 |
      | Key and Mouse Press           |
      | Modal                         |
      | Page Scroll                   |
      | Radio Button                  |
      | Switch Window                 |
      | Complete Web Form             |
    * Click on "File Download" in dropdown list and check "filedownload" page has opened

#nonfunctional - layout/visual
  Scenario: Layout test
#    * Make page dump of "Error" page
    * Check layout "ErrorPageVisual" file
    * Close browser

  Scenario: Titles has displayed
    * Click on "Refresh" and check "filedownload" page has opened
    * Check "first" title "The page you were looking for doesn't exist." has displayed
    * Check "second" title "You may have mistyped the address or the page may have moved." has displayed
    * Check "third" title "If you are the application owner check the logs for more information." has displayed
    * Close browser
#functional
  Scenario: Forward - window with titles has displayed
    * Click on "Backward" and check "dropdown" page has opened
    * Click on "Forward" and check "filedownload" page has opened
    * Click on "Refresh" and check "filedownload" page has opened
    * Check "first" title "The page you were looking for doesn't exist." has displayed
    * Check "second" title "You may have mistyped the address or the page may have moved." has displayed
    * Check "third" title "If you are the application owner check the logs for more information." has displayed
    * Close browser

  Scenario: Backward - page filedownload has not opened, window with titles has not displayed more
    * Click on "Backward" and check "dropdown" page has opened
    * Click on "Form" and check "form" page has opened
    * Click on "Backward" and check "dropdown" page has opened
    * Click on "Backward" and check "Welcome to Formy" page has opened
    * Click on "Forward" and check "dropdown" page has opened
    * Click on "Forward" and check "form" page has opened
    * Close browser

  Scenario: Refresh - window with titles has displayed
    * Click on "Refresh" and check "filedownload" page has opened
    * Check "first" title "The page you were looking for doesn't exist." has displayed
    * Check "second" title "You may have mistyped the address or the page may have moved." has displayed
    * Check "third" title "If you are the application owner check the logs for more information." has displayed
    * Close browser