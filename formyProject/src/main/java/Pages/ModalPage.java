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

public class ModalPage {
    private final WebDriver driver;
    private final DatepickerPage datepickerPage;
    @FindBy(id = "modal-button")
    private WebElement modalButton;
    @FindBy(id = "exampleModalLabel")
    private WebElement modalWindowFirstTitle;
    @FindBy(xpath = "//button[@class='close']")
    private WebElement closeRightTopButtonOfModalWindow;
    @FindBy(id = "close-button")
    private WebElement closeButtonOfModalWindow;
    @FindBy(id = "ok-button")
    private WebElement okButtonOfModalWindow;
    @FindBy(xpath = "//div[@class='modal fade show']")
    private WebElement modalWindow;

    public ModalPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
        this.datepickerPage = new DatepickerPage(driver);
    }

    private boolean isScreenshotsEnabled() {
        String v = System.getProperty("formy.screenshots", "1");
        return !("0".equals(v) || "false".equalsIgnoreCase(v));
    }

    public void makeScreenshot() {
        if (!isScreenshotsEnabled()) {
            return;
        }

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

    public void buttonTitleCheck(String arg1) {
        checkResult(modalButton.getText().equals(arg1));
    }

    public void hasModalWindowDisplayed(String arg1) {
        switch (arg1) {
            case "has":
                try {
                    checkResult(modalWindow.isDisplayed());
                } catch (NoSuchElementException e) {
                    checkResultFailed();
                }
                break;
            case "has not":
                try {
                    checkResult(!modalWindow.isDisplayed());
                } catch (NoSuchElementException e) {
                    System.out.println("PASSED");
                }
                break;
        }
    }

    public void hasModalWindowTitlesCheck(String arg1, String arg2) {
        switch (arg1) {
            case "first":
                checkResult(modalWindowFirstTitle.getText().equals(arg2));
                break;
            case "second":
                WebElement modalWindowSecondTitle = driver.findElement(By.xpath("//div[@class='modal-body']"));
                checkResult(modalWindowSecondTitle.getText().equals(arg2));
                break;
        }
    }

    public void hasModalButtonNotSelectedEnabled() {
        checkResult(!modalButton.isSelected() && modalButton.isEnabled());
    }

    public void hasModalElementClick(String arg1) throws InterruptedException {
        switch (arg1) {
            case "close":
                Thread.sleep(1200);
                closeButtonOfModalWindow.click();
                break;
            case "open modal":
                modalButton.click();
                break;
            case "close right top":
                Thread.sleep(1200);
                closeRightTopButtonOfModalWindow.click();
                break;
            case "ok":
                Thread.sleep(1200);
                okButtonOfModalWindow.click();
                break;
        }
    }

    public void hasPageAddressCheck(String arg1) {
        datepickerPage.openedPageCheck(driver.getCurrentUrl(), arg1);
    }

    public void escapePressModal() throws InterruptedException {
        Thread.sleep(1200);
        modalWindow.sendKeys(Keys.ESCAPE);
    }
}