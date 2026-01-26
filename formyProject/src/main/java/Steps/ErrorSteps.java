package Steps;

import Config.Drive;
import Pages.ErrorPage;
import io.cucumber.java.en.Then;
import org.testng.Assert;

public class ErrorSteps extends Drive {

    private ErrorPage errorPage() {
        return new ErrorPage(Drive.getDriver());
    }

    @Then("User sees error page")
    public void userSeesErrorPage() {
        Assert.assertTrue(errorPage().errorHeading.isDisplayed(), "Error heading should be displayed");
    }
}