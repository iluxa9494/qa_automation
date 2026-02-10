package Steps;

import Config.Drive;
import Pages.DragAndDropPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class DragAndDropSteps extends Drive {
    DragAndDropPage dragAndDropPage = PageFactory.initElements(driver, DragAndDropPage.class);

    @Then("Check title {string} has displayed")
    public void boxTitleDisplayed(String arg1) {
        dragAndDropPage.isBoxTitleDisplayed(arg1);
    }

    @Then("Check logo Selenium has displayed")
    public void seleniumLogoDisplayed() {
        dragAndDropPage.isSeleniumLogoDisplayed();
    }

    @Then("Drop Selenium logo to the box")
    public void dropLogo() {
        dragAndDropPage.dropSeleniumLogo();
    }

    @Then("Check Selenium logo has absent on initial position")
    public void logoAbsenceInitialPosition() {
        dragAndDropPage.isLogoPosition(2);
    }

    @Then("Check logo Selenium has displayed on initial position")
    public void logoInitialPosition() {
        dragAndDropPage.isLogoPosition(1);
    }


    @Then("Check Selenium logo has been in the box")
    public void logoInTheBox() {
        dragAndDropPage.isLogoInTheBox();
    }

    @Then("Drop Selenium logo tо the initial position")
    public void logoInTheInitialPosition() {
        dragAndDropPage.isLogoInTheInitialPosition();
    }

    @Then("Drop Selenium logo {string} without touching box boundary")
    public void dropWithoutTouching(String arg1) {
        dragAndDropPage.isDropWithoutTouching(arg1);
    }

    @Then("Drop Selenium logo on the box border {string} side lengths of the logo")
    public void dropLogoOnTheBox(String arg1) {
        dragAndDropPage.isDropWithoutTouching(arg1);
    }
}