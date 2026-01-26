package Steps;

import Config.Drive;
import Pages.ErrorPage;
import io.cucumber.java.en.Then;

public class ErrorSteps extends Drive {

    private ErrorPage errorPage;

    private ErrorPage page() {
        if (errorPage == null) {
            errorPage = new ErrorPage(Drive.getDriver());
        }
        return errorPage;
    }

    @Then("Check {string} title {string} has displayed")
    public void titleErrorDisplayed(String arg1, String arg2) {
        page().isTitleErrorDisplayed(arg1, arg2);
    }
}