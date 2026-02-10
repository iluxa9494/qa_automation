package Steps;

import Config.Drive;
import Pages.ThanksPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class ThanksSteps extends Drive {
    ThanksPage thanksPage = PageFactory.initElements(driver, ThanksPage.class);

    @Then("Check success title has a {string} text")
    public void thanksElementTitleCheck(String arg1) {
        thanksPage.hasThanksElementTitleCheck(arg1);
    }

    @Then("Check {string} has been unselected")
    public void unselectedTitleCheck(String arg1) {
        thanksPage.hasUnselectedTitleCheck(arg1);
    }
}