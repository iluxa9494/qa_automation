package Steps;

import Config.Drive;
import Pages.SwitchWindowPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class SwitchWindowSteps extends Drive {
    SwitchWindowPage switchWindowPage = PageFactory.initElements(driver, SwitchWindowPage.class);

    @Then("Check {string} button has an {string} title")
    public void switchWindowButtonsTitleCheck(String arg1, String arg2) {
        switchWindowPage.hasSwitchWindowButtonTitleCheck(arg1, arg2);
    }

    @Then("Check {string} has been unselected and enabled")
    public void switchWindowButtonsUnselectedEnabledCheck(String arg1) {
        switchWindowPage.hasSwitchWindowButtonsUnselectedEnabledCheck(arg1);
    }

    @Then("Click on the {string} button")
    public void switchWindowButtonsClickCheck(String arg1) {
        switchWindowPage.hasSwitchWindowButtonsClickCheck(arg1);
    }

    @Then("Switch to a {string} window tab")
    public void switchWindowTabCheck(String arg1) {
        switchWindowPage.hasSwitchWindowTabCheck(arg1);
    }

    @Then("Check an alert has {string}")
    public void switchWindowAlertOpenedCheck(String arg1) {
        switchWindowPage.hasSwitchWindowAlertOpenedCheck(arg1);
    }

    @Then("Check an alert has a title {string}")
    public void switchWindowAlertTitleCheck(String arg1) {
        switchWindowPage.hasSwitchWindowAlertTitleCheck(arg1);
    }

    @Then("Accept alert")
    public void switchWindowAlertAcceptCheck() {
        switchWindowPage.hasSwitchWindowAlertAcceptCheck();
    }

    @Then("Dismiss alert")
    public void switchWindowAlertEscapeCheck() {
        switchWindowPage.hasSwitchWindowAlertEscapeCheck();
    }
}