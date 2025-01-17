package Steps;

import Config.Drive;
import Pages.ErrorPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class ErrorSteps extends Drive {
    ErrorPage errorPage = PageFactory.initElements(driver, ErrorPage.class);

    @Then("Check {string} title {string} has displayed")
    public void titleErrorDisplayed(String arg1, String arg2) {
        errorPage.isTitleErrorDisplayed(arg1, arg2);
    }
}