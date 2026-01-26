package Steps;

import Config.Drive;
import Pages.ErrorPage;
import io.cucumber.java.en.Then;
public class ErrorSteps extends Drive {
    private ErrorPage errorPage;

    private ErrorPage errorPage() {
        if (errorPage == null) {
            errorPage = new ErrorPage(driver);
        }
        return errorPage;
    }
    @Then("Check {string} title {string} has displayed")
    public void titleErrorDisplayed(String arg1, String arg2) {
        errorPage().isTitleErrorDisplayed(arg1, arg2);
    }
}
