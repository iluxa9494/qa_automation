package Steps;

import Config.Drive;
import Pages.AutocompletePage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class AutocompleteSteps extends Drive {
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);

    @Then("Check all fields is empty")
    public void isAllFieldsEmpty() throws Exception {
        autocompletePage.isAllFieldsEmptyCheck();
    }

    @Then("Check data has entered in {string} field after entering")
    public void enterInField(String arg1, DataTable table) throws Exception {
        autocompletePage.enterDataInField(arg1, table);
    }

    @Then("Check dropdown of {string} field {string} displayed")
    public void isDropdownDisplayed(String arg1, String arg2) {
        autocompletePage.dropdownDisplayed(arg1);
    }

    @Then("Check all 5 elements of dropdown list contains {string} in its titles")
    public void isElementsDropdownDisplayed(String arg1) throws InterruptedException {
        autocompletePage.isElementsInDropdownDisplayed(arg1);
    }

    @Then("Choose {string} and check other fields has not had data excluding city, state, country:")
    public void isAutocomplete(String arg1, DataTable table) throws Exception {
        autocompletePage.isAutocompleteCorrect(arg1, table);
    }

    @Then("Refresh page and check all fields are empty")
    public void refreshPage() throws Exception {
        autocompletePage.refreshPageCheckFields();
    }

    @Then("Check all fields saved its data: Address, Street address, Street address 2, City, State, Zip code, Country:")
    public void backwardForwardPage(DataTable table) throws Exception {
        autocompletePage.backwardForwardPageSavingFieldsData(table);
    }

    @Then("Check {string} title is displayed")
    public void isTitleDisplayed(String arg1) {
        autocompletePage.isTitleDisplayedOk(arg1);
    }

    @Then("Check {string} {string} is {string}")
    public void isFieldTitlePlaceholderDisplayed(String arg1, String arg2, String arg3) {
        autocompletePage.isFieldTitlePlaceholderDisplayedCorrectly(arg1, arg2, arg3);
    }

    @Then("Copy data from {string} field, clear via delete, paste data to the field and check the functions worked")
    public void copyData(String arg1) throws Exception {
        autocompletePage.copyDataFromField(arg1);
    }

    @Then("Clear {string} field via delete")
    public void clearField(String arg1) {
        autocompletePage.clearViaDelete(arg1);
    }
}