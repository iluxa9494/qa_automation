package Steps;

import Config.Drive;
import Pages.WelcomePage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class WelcomeSteps extends Drive {
    WelcomePage welcomePage = PageFactory.initElements(driver, WelcomePage.class);

    @Then("Check {string} has a {string} text")
    public void firstSecondTitleCheck(String arg1, String arg2) {
        welcomePage.hasFirstSecondTitleCheck(arg1, arg2);
    }

    @Then("Check list of the all components has displayed and contained:")
    public void allElementsInListCheck(DataTable table) throws InterruptedException {
        welcomePage.hasAllElementsInListCheck(table);
    }

    @Then("Check {string} element has been unselected, enabled")
    public void welcomeElementUnselectedEnabledCheck(String arg1) {
        welcomePage.haswelcomeElementUnselectedEnabledCheck(arg1);
    }
}