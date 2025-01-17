package Steps;

import Config.Drive;
import Pages.DatepickerPage;
import Pages.FormPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class FormSteps extends Drive {
    FormPage formPage = PageFactory.initElements(driver, FormPage.class);
    DatepickerPage datepickerPage = PageFactory.initElements(driver, DatepickerPage.class);

    @Then("Check element {string} has a {string} title")
    public void hasElementPageTitles(String arg1, String arg2) {
        formPage.hasElementPageTitle(arg1, arg2);
    }

    @Then("Check element {string} has a {string} placeholder")
    public void elementPagePlaceholders(String arg1, String arg2) {
        formPage.hasElementPagePlaceholders(arg1, arg2);
    }

    @Then("Check element experience selector has a {string} field text")
    public void fieldTextCheck(String arg1) {
        formPage.isFieldTextCheck(arg1);
    }

    @Then("Click on the {string}")
    public void formElementClick(String arg1) {
        formPage.isFormElementClick(arg1);
    }

    @Then("Check element experience selector has a Select an option, 0-1, 2-4, 5-9, 10+ titles")
    public void elementOptionsCheck() {
        formPage.elementHasOptionsCheck();
    }

    @Then("Check {string} has empty")
    public void emptyElementCheck(String arg1) throws Exception {
        formPage.hasEmptyElementCheck(arg1);
    }

    @Then("Check data has entered in {string} after entering")
    public void enterAndCheckValue(String arg1, DataTable table) throws Exception {
        formPage.hasEnterAndCheckValue(arg1, table);
    }

    @Then("Copy data from {string}, clear via delete, paste data to the field and check the functions have worked")
    public void copyClearPasteCheck(String arg1) throws Exception {
        formPage.copyClearPasteAndCheck(arg1);
    }

    @Then("Clear {string} via delete")
    public void deleteAndCheck(String arg1) {
        formPage.hasDeleteAndCheck(arg1);
    }

    @Then("Check {string} has been {string}")
    public void selectedAndUnselectedElementsCheck(String arg1, String arg2) {
        formPage.hasSelectedAndUnselectedElementsCheck(arg1, arg2);
    }

    @Then("Check {string} page has opened")
    public void hasThanksPageCheck(String arg1) {
        datepickerPage.isPage(arg1);
    }

    @Then("Check element {string} has enabled")
    public void formElementEnabledCheck(String arg1) {
        formPage.hasFormElementEnabledCheck();
    }

    @Then("Check: first name input has a {string}, last name input has a {string}, job title input has a {string}")
    public void formElementValueCheck(String arg1, String arg2, String arg3) throws Exception {
        formPage.hasFormElementValueCheck(arg1, arg2, arg3);
    }
}