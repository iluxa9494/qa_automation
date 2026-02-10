package Pages;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.testng.Assert;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FileUploadPage {
    WebDriver driver;
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);
    @FindBy(xpath = "//button[text()='Choose']")
    public static WebElement chooseButton;
    @FindBy(xpath = "//button[text()='Reset']")
    public static WebElement resetButton;
    @FindBy(id = "file-upload-field")
    public static WebElement fileUploadField;
    @FindBy(xpath = "//h1[text()='File upload']")
    public static WebElement title;

    public FileUploadPage(WebDriver driver) {
        this.driver = driver;
    }

    public void makeScreenshot() {
        String arg1 = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss").format(new Date());
        try {
            File scrFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(scrFile, new File("src/Screenshots/" + arg1 + ".png"));
        } catch (IOException e) {
            System.out.println("Some troubles with screenshot");
        }
    }

    public void checkResult(boolean arg1) {
        if (arg1) {
            System.out.println("PASSED");
        } else {
            checkResultFailed();
        }
    }

    public void checkResultFailed() {
        makeScreenshot();
        Assert.fail("FAILED");
    }

    public void isButtonTitle(String arg1, String arg2) {
        switch (arg1) {
            case "choose button":
                checkResult(chooseButton.getText().equals(arg2));
                break;
            case "reset button":
                checkResult(resetButton.getText().equals(arg2));
                break;
            case "file upload field":
                try {
                    WebElement fileUploadFieldPlaceholder = driver.findElement(By.xpath("//input[@placeholder='" + arg2 + "']"));
                    fileUploadFieldPlaceholder.getText();
                    System.out.println("PASSED");
                } catch (NoSuchElementException e) {
                    checkResultFailed();
                }
                break;
        }
    }

    public void isEnabledElement(String arg1) {
        switch (arg1) {
            case "choose button":
                checkResult(!chooseButton.isSelected() && chooseButton.isEnabled());
                break;
            case "reset button":
                checkResult(!resetButton.isSelected() && resetButton.isEnabled());
                break;
            case "file upload field":
                checkResult(!fileUploadField.isSelected() && fileUploadField.isEnabled());
                break;
        }
    }

    public void clickElementIsWindowOpened(String arg1) {
        switch (arg1) {
            case "choose button":
                chooseButton.click();
                break;
            case "reset button":
                resetButton.click();
                break;
            case "file upload field":
                fileUploadField.click();
                break;
        }
    }

    public void chooseUploadFiles(String arg1) {
        fileUploadField.sendKeys("src/Files Format/" + arg1);
    }

    public void isFileUpload(String arg1) throws Exception {
        checkResult(autocompletePage.getInputFieldValue(fileUploadField).substring(17).equals(arg1));
    }

    public void isFileUploadFieldClear() throws Exception {
        checkResult(autocompletePage.getInputFieldValue(fileUploadField).equals(""));
    }

    public void pressEnterAndCheckPage(String arg1, String arg2) {
        fileUploadField.sendKeys(Keys.ENTER);
        try {
            WebElement errorPage = driver.findElement(By.xpath("//h1"));
            checkResult(driver.getCurrentUrl().substring(36).equals(arg1) && errorPage.getText().equals(arg2));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }
}