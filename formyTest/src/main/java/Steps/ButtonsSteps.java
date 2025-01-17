package Steps;

import Config.Drive;
import Pages.ButtonsPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class ButtonsSteps extends Drive {
    ButtonsPage buttonsPage = PageFactory.initElements(driver, ButtonsPage.class);

    @Then("Check there are no any page titles")
    public void titleAbsent() {
        buttonsPage.isTitleAbsent();
    }

    @Then("Check {string} button has correct title")
    public void buttonsTitle(String arg1) {
        buttonsPage.isCorrectButtonsTitle(arg1);
    }

    @Then("Click on and check {string} button is enabled, displayed")
    public void buttonsClickable(String arg1) {
        buttonsPage.isButtonsEnabledDisplayed(arg1);
    }

    @Then("Check dropdown list with Dropdown link 1, Dropdown link 2 elements has opened")
    public void dropdownListOpened() {
        buttonsPage.isDropdownListOpened();
    }
}