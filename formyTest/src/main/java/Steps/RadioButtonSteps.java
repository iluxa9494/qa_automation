package Steps;

import Config.Drive;
import Pages.RadioButtonPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class RadioButtonSteps extends Drive {
    RadioButtonPage radioButtonPage = PageFactory.initElements(driver, RadioButtonPage.class);

    @Then("Check radio button {string} has a {string} title")
    public void radioButtonTitleCheck(String arg1, String arg2) {
        radioButtonPage.hasRadioButtonTitleCheck(arg1, arg2);
    }

    @Then("Check {string} radio button has {string}")
    public void radioButtonSelectionCheck(String arg1, String arg2) {
        radioButtonPage.hasRadioButtonSelectionCheck(arg1, arg2);
    }

    @Then("Click on the {string} element")
    public void radioButtonClickCheck(String arg1) {
        radioButtonPage.hasRadioButtonClickCheck(arg1);
    }

    @Then("Press Escape")
    public void radioButtonEscCheck() {
        radioButtonPage.hasRadioButtonEscCheck();
    }

    @Then("Press enter")
    public void radioButtonEnterCheck() {
        radioButtonPage.hasRadioButtonEnterCheck();
    }
}