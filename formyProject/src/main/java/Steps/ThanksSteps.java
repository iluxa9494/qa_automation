package Steps;

import Config.Drive;
import Pages.ThanksPage;
import io.cucumber.java.en.Then;
public class ThanksSteps extends Drive {
    private ThanksPage thanksPage;

    private ThanksPage thanksPage() {
        if (thanksPage == null) {
            thanksPage = new ThanksPage(driver);
        }
        return thanksPage;
    }
    @Then("Check success title has a {string} text")
    public void thanksElementTitleCheck(String arg1) {
        thanksPage().hasThanksElementTitleCheck(arg1);
    }

    @Then("Check {string} has been unselected")
    public void unselectedTitleCheck(String arg1) {
        thanksPage().hasUnselectedTitleCheck(arg1);
    }
}
