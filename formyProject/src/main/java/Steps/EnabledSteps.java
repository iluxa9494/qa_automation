package Steps;

import Config.Drive;
import Pages.EnabledPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.support.PageFactory;

public class EnabledSteps extends Drive {
    EnabledPage enabledPage = PageFactory.initElements(driver, EnabledPage.class);

    @Then("Check disabled input field has not selected and not enabled")
    public void unselectedAndDisabledFieldCheck() {
        enabledPage.isUnselectedAndDisabledCheck();
    }

    @Then("Check placeholder of {string} has text {string}")
    public void placeholderTextCheck(String arg1, String arg2) {
        enabledPage.isPlaceholderTextCheck(arg1, arg2);
    }

    @Then("Check input field has not selected, enabled")
    public void unselectedAndDisabledEnabledFieldCheck() {
        enabledPage.isUnselectedAndDisabledEnabledFieldCheck();
    }

    @Then("Check input field is empty")
    public void inputFieldEmptyCheck() throws Exception {
        enabledPage.isInputFieldEmptyCheck();
    }

    @Then("Check field input has {string} value")
    public void fieldValueCheck(String arg1) throws Exception {
        enabledPage.whatFieldValueCheck(arg1);
    }

    @Then("Check data has entered in enabled input field after entering")
    public void enterValueInEnabledInputFiled(DataTable table) throws Exception {
        enabledPage.isEnterValueInEnabledInputFiled(table);
    }

    @Then("Clear enabled input field via delete")
    public void clearEnabledInputFieldViaDelete() {
        enabledPage.isClearEnabledInputFieldViaDelete();
    }

    @Then("Copy data from enabled input field, clear via delete, paste data to the field and check the functions have worked")
    public void copyClearPasteValueEnabledInputField() throws Exception {
        enabledPage.isCopyClearPasteValueEnabledInputField();
    }

    @Then("Enter {string} in disabled input field and check data has not entered")
    public void eneterValueInDisabledField(String arg1) throws ElementNotInteractableException {
        enabledPage.isEnterValueInDisabledField(arg1);
    }
}