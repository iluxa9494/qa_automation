package Steps;

import Config.Drive;
import Pages.KeyPressPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class KeyPressSteps extends Drive {
    KeyPressPage keyPressPage = PageFactory.initElements(driver, KeyPressPage.class);

    @Then("Check {string} has a {string} {string}")
    public void titlePlaceholderTextCheck(String arg1, String arg2, String arg3) {
        keyPressPage.hasTitlePlaceholderTextCheck(arg1, arg2, arg3);
    }

    @Then("Check {string} has not selected and enabled")
    public void elementUnselectedEnabled(String arg1) {
        keyPressPage.hasElementUnselectedEnabled(arg1);
    }

    @Then("Check data has entered in full name input after entering")
    public void enterDataInField(DataTable table) throws Exception {
        keyPressPage.hasEnterDataInField(table);
    }

    @Then("Click on button and check {string} has opened")
    public void clickElementAndPageCheck(String arg1) {
        keyPressPage.hasClickElementAndPageCheck(arg1);
    }

    @Then("Check full name input has a {string} value")
    public void fieldValueCheck(String arg1) throws Exception {
        keyPressPage.hasFieldValueCheck(arg1);
    }

    @Then("Check full name input has empty")
    public void inputElementEmpty() throws Exception {
        keyPressPage.hasInputElementEmpty();
    }

    @Then("Clear full name input via delete")
    public void inputElementClearDelete() throws Exception {
        keyPressPage.hasInputElementClearDelete();
    }

    @Then("Copy data from full name input, clear via delete, paste data to the field and check all functions have worked")
    public void copyClearPasteFieldCheck() throws Exception {
        keyPressPage.hasCopyClearPasteFieldCheck();
    }

    @Then("Click on full name input field")
    public void clickOnFiledElement() {
        keyPressPage.clickOnFiledElementCheck();
    }

    @Then("Clear full name input field")
    public void clearFieldCheck() {
        keyPressPage.hasClearFieldCheck();
    }

    @Then("Press Enter")
    public void enterPress() {
        keyPressPage.hasEnterPress();
    }
}