package Steps;

import Config.Drive;
import Pages.CheckboxPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class CheckboxSteps extends Drive {
    CheckboxPage checkboxPage = PageFactory.initElements(driver, CheckboxPage.class);

    @Then("Check {string} has page title {string}")
    public void correctTitle(String arg1, String arg2) {
        checkboxPage.isCorrectTitle(arg1, arg2);
    }

    @Then("Check all checkboxes has not selected")
    public void checkboxesNotSelected() {
        checkboxPage.areCheckboxesNotSelected();
    }

    @Then("Click on checkbox {string}")
    public void clickOnTitleOfCheckboxes(String arg1) {
        checkboxPage.areClickOnCheckbox(arg1);
    }

    @Then("Check all checkboxes has selected")
    public void checkboxesSelected() {
        checkboxPage.areCheckboxesSelected();
    }
}