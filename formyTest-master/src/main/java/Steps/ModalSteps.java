package Steps;

import Config.Drive;
import Pages.ModalPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class ModalSteps extends Drive {
    ModalPage modalPage = PageFactory.initElements(driver, ModalPage.class);

    @Then("Check open modal button has {string} title")
    public void buttonTitle(String arg1) {
        modalPage.buttonTitleCheck(arg1);
    }

    @Then("Check modal window {string} displayed")
    public void modalWindowDisplayed(String arg1) throws InterruptedException {
        modalPage.hasModalWindowDisplayed(arg1);
    }

    @Then("Check {string} title has a {string} text")
    public void modalWindowTitlesCheck(String arg1, String arg2) {
        modalPage.hasModalWindowTitlesCheck(arg1, arg2);
    }

    @Then("Check open modal button has not selected and enabled")
    public void modalButtonNotSelectedEnabled() {
        modalPage.hasModalButtonNotSelectedEnabled();
    }

    @Then("Click on {string} button")
    public void modalElementClick(String arg1) throws InterruptedException {
        modalPage.hasModalElementClick(arg1);
    }

    @Then("Check page {string} has opened")
    public void pageAddressCheck(String arg1) {
        modalPage.hasPageAddressCheck(arg1);
    }

    @Then("Press escape")
    public void escPressModal() throws InterruptedException {
        modalPage.escapePressModal();
    }
}