package Steps;

import Config.Drive;
import Pages.ScrollPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class ScrollSteps extends Drive {
    ScrollPage scrollPage = PageFactory.initElements(driver, ScrollPage.class);

    @Then("Check {string} text paragraph has text:")
    public void scrollTextParagraphCheck(String arg1, String arg2) {
        scrollPage.hasScrollTextParagraphCheck(arg1, arg2);
    }

    @Then("Check {string} title has the {string} text")
    public void scrollTitleTextCheck(String arg1, String arg2) {
        scrollPage.hasScrollTitleTextCheck(arg1, arg2);
    }

    @Then("Check {string} placeholder has a {string} text")
    public void scrollPlaceholderTextCheck(String arg1, String arg2) {
        scrollPage.hasScrollPlaceholderTextCheck(arg1, arg2);
    }

    @Then("Check {string} field has been unselected, enabled")
    public void scrollFieldUnselectedEnabledCheck(String arg1) {
        scrollPage.hasScrollFieldUnselectedEnabledCheck(arg1);
    }

    @Then("Check data has entered in the {string} field after entering")
    public void scrollFieldDataEnterCheck(String arg1, DataTable table) throws Exception {
        scrollPage.hasScrollFieldDataEnterCheck(arg1, table);
    }

    @Then("Clear the {string} field via delete")
    public void scrollFieldDeleteCheck(String arg1) {
        scrollPage.hasScrollFieldDeleteCheck(arg1);
    }

    @Then("Scroll page on {string}")
    public void scrollPageToCheck(String arg1) {
        scrollPage.hasScrollPageToCheck(arg1);
    }

    @Then("Check scroll element has been {string} position")
    public void scrollPositionCheck(String arg1) {
        scrollPage.hasScrollPositionCheck(arg1);
    }
}