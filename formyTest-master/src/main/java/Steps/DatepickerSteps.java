package Steps;

import Config.Drive;
import Pages.DatepickerPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class DatepickerSteps extends Drive {

    DatepickerPage datepickerPage = PageFactory.initElements(driver, DatepickerPage.class);

    @Then("Go to {string} page")
    public void goToPage(String arg1) {
        datepickerPage.goPage(arg1);//for list on welcome page only
        datepickerPage.isPage(arg1);
    }

    @Then("Refresh the page and check: the datepicker page is opened and the input field is empty")
    public void refreshThePage() {
        datepickerPage.refreshPage();
    }

    @Then("Click on input field and check calendar is {string}")
    public void calendarOpened(String arg1) throws Exception {
        datepickerPage.isCalendarOpened(arg1);
    }

    @Then("Click on and check {string} {string} is displayed")
    public void chooseElementOpened(String button, String date) throws Exception {
        datepickerPage.chooseElementIsOpened(button, date);
    }

    @Then("Pick {string} and check the calendar is {string} and the picked date is displayed in the input field")
    public void pickAndCheckCalendarDate(String arg1, String arg2) throws Exception {
        datepickerPage.pickAndCheckCalendarDateIsDisplayed(arg1, arg2);
    }

    @Then("Click on the {string} element and check {string} {string} and {string} are displayed:")
    public void clickAndCheckCurrentYear(String arg1, String arg2, String arg3, String arg4, DataTable table) {
        datepickerPage.chooseAndCheckCurrentYearIsDisplayed(arg1, arg2, arg3, arg4, table);
    }

    @Then("Type {string} and press Enter")
    public void typingPress(String arg1) {
        datepickerPage.typeAndPress(arg1);
    }

    @Then("Check {string} {string} is displayed")
    public void dateCheck(String arg1, String arg2) throws Exception {
        datepickerPage.checkCalendarValue(arg1, arg2);
    }

    @Then("Click on title Datepicker and check calendar is {string}")
    public void clickOnTitle(String arg1) throws Exception {
        datepickerPage.clickOnTitleCheck(arg1);
    }

    //header
    @Then("Click on {string} and check inside a dropdown list with:")
    public void componentsCheck1(String arg1, DataTable table) {
        datepickerPage.headerComponentsCheck(arg1, table);
    }

    @Then("Click on {string} and check {string} page has opened")
    public void componentsClick(String arg1, String arg2) {
        datepickerPage.isPageOpened(arg1, arg2);
    }
}