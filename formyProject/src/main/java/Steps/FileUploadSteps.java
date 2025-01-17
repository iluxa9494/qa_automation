package Steps;

import Config.Drive;
import Pages.FileUploadPage;
import io.cucumber.java.en.Then;
import org.openqa.selenium.support.PageFactory;

public class FileUploadSteps extends Drive {
    FileUploadPage fileUploadPage = PageFactory.initElements(driver, FileUploadPage.class);

    @Then("Check {string} has {string} {string}")
    public void buttonTitle(String arg1, String arg2, String arg3) {
        fileUploadPage.isButtonTitle(arg1, arg3);
    }

    @Then("Check {string} is enabled, not selected")
    public void enabledElement(String arg1) {
        fileUploadPage.isEnabledElement(arg1);
    }

    @Then("Click on {string}")
    public void clickElementCheckWindow(String arg1) {
        fileUploadPage.clickElementIsWindowOpened(arg1);
    }

    @Then("Upload {string} file")
    public void chooseUploadFile(String arg1) {
        fileUploadPage.chooseUploadFiles(arg1);
    }

    @Then("Check {string} file has displayed in file upload input")
    public void fileUpload(String arg1) throws Exception {
        fileUploadPage.isFileUpload(arg1);
    }

    @Then("Check file upload field has cleared")
    public void fileUploadFieldClear() throws Exception {
        fileUploadPage.isFileUploadFieldClear();
    }

    @Then("Press Enter and check {string} page has opened and title {string} has displayed")
    public void pressEnterAndCheck(String arg1, String arg2) {
        fileUploadPage.pressEnterAndCheckPage(arg1, arg2);
    }
}