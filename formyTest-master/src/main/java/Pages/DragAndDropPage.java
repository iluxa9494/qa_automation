package Pages;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DragAndDropPage {
    WebDriver driver;
    @FindBy(xpath = "//p[text()='Drop here']")
    public static WebElement boxTitleDropHere;
    @FindBy(xpath = "//p[text()='Dropped!']")
    public static WebElement boxTitleDropped;
    @FindBy(id = "image")
    public static WebElement seleniumLogo;
    @FindBy(id = "box")
    public static WebElement box;
    @FindBy(xpath = " //div[@id = 'image' and @style='position: relative;']")
    public static WebElement initialLogoPosition;
    @FindBy(xpath = "//div[@id = 'image' and @style = 'position: relative; left: 0px; top: 0px;']")
    public static WebElement initialLogoPositionVariant2;
    @FindBy(xpath = "//div[@id = 'image' and @style = 'position: relative; left: 270px; top: 50px;']")
    public static WebElement droppedLogoPosition;

    public DragAndDropPage(WebDriver driver) {
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

    public void isBoxTitleDisplayed(String arg1) {
        switch (arg1) {
            case "Drop here":
                checkResult(boxTitleDropHere.getText().equals(arg1));
                break;
            case "Dropped!":
                checkResult(boxTitleDropped.getText().equals(arg1));
                break;
        }
    }

    public void isSeleniumLogoDisplayed() {
        checkResult(seleniumLogo.isDisplayed());
    }

    public void dropSeleniumLogo() {
        new Actions(driver).dragAndDrop(seleniumLogo, box).build().perform();
    }

    public void isLogoPosition(int i) {
        switch (i) { // i = 1 if needs logo has been on initial position and i = 2 if needs logo has not been on initial position
            case 1:
                checkResult(isDisplayedCheck(initialLogoPosition));
                break;
            case 2:
                checkResult(!isDisplayedCheck(initialLogoPosition));
                break;
        }
    }

    public boolean isDisplayedCheck(WebElement arg1) {
        try {
            return arg1.isDisplayed();
        } catch (NoSuchElementException e) {
            return false;
        }
    }

    public void isLogoInTheBox() {
        checkResult(isDisplayedCheck(droppedLogoPosition));
    }

    public void isLogoInTheInitialPosition() {
        new Actions(driver).dragAndDropBy(seleniumLogo, -270, -50).build().perform();
        isLogoInitialPosition();
    }

    public void isLogoInitialPosition() {
        checkResult(isDisplayedCheck(initialLogoPositionVariant2));
    }

    public void isDropWithoutTouching(String arg1) {
        switch (arg1) {
            case "below":
                new Actions(driver).dragAndDropBy(seleniumLogo, 10, 250).build().perform();
                checkResult(checkLogoPosition("10", "250"));
                break;
            case "to the right":
                new Actions(driver).dragAndDropBy(seleniumLogo, 540, 0).build().perform();
                checkResult(checkLogoPosition("550", "250"));
                break;
            case "above":
                new Actions(driver).dragAndDropBy(seleniumLogo, 0, -250).build().perform();
                checkResult(checkLogoPosition("550", "0"));
                break;
            case "less 50% of the right":
                new Actions(driver).dragAndDropBy(seleniumLogo, 115, 70).build().perform();
                checkResult(checkLogoPosition("115", "70"));
                break;
            case "less 50% of the upper":
                new Actions(driver).dragAndDropBy(seleniumLogo, 150, 150).build().perform();
                checkResult(checkLogoPosition("265", "220"));
                break;
            case "less 50% of the left":
                new Actions(driver).dragAndDropBy(seleniumLogo, 165, -160).build().perform();
                checkResult(checkLogoPosition("430", "60"));
                break;
            case "less 50% of the down":
                new Actions(driver).dragAndDropBy(seleniumLogo, -170, -170).build().perform();
                checkResult(checkLogoPosition("260", "-110"));
                break;
            case "more 50% of the right":
                new Actions(driver).dragAndDropBy(seleniumLogo, 150, 40).build().perform();
                checkResult(checkLogoPosition("150", "40"));
                break;
            case "more 50% of the upper":
                new Actions(driver).dragAndDropBy(seleniumLogo, 270, 180).build().perform();
                checkResult(checkLogoPosition("270", "180"));
                break;
            case "more 50% of the left":
                new Actions(driver).dragAndDropBy(seleniumLogo, 385, 40).build().perform();
                checkResult(checkLogoPosition("385", "40"));
                break;
            case "more 50% of the down":
                new Actions(driver).dragAndDropBy(seleniumLogo, 265, -70).build().perform();
                checkResult(checkLogoPosition("265", "-70"));
                break;
        }
    }

    public boolean checkLogoPosition(String arg1, String arg2) {
        WebElement logoPosition = driver.findElement(By.xpath(
                "//div[@id = 'image' and @style = 'position: relative; left: " + arg1 + "px; top: " + arg2 + "px;']"));
        return isDisplayedCheck(logoPosition);
    }
}