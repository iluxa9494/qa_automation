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

public class ErrorPage {

    private final WebDriver driver;

    @FindBy(xpath = "//div/h1")
    private WebElement firstTitle;

    @FindBy(xpath = "//div/div/p")
    private WebElement secondTitle;

    @FindBy(xpath = "//div[@class='dialog']/p")
    private WebElement thirdTitle;

    public ErrorPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void makeScreenshot() {
        if (driver == null) return;

        String ts = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss").format(new Date());
        try {
            File scrFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(scrFile, new File("src/Screenshots/" + ts + ".png"));
        } catch (IOException | WebDriverException e) {
            System.out.println("Some troubles with screenshot");
        }
    }

    public void checkResult(boolean ok) {
        if (ok) {
            System.out.println("PASSED");
        } else {
            checkResultFailed();
        }
    }

    public void checkResultFailed() {
        makeScreenshot();
        Assert.fail("FAILED");
    }

    public void isTitleErrorDisplayed(String which, String expected) {
        switch (which) {
            case "first":
                checkResult(firstTitle.getText().equals(expected));
                break;
            case "second":
                checkResult(secondTitle.getText().equals(expected));
                break;
            case "third":
                checkResult(thirdTitle.getText().equals(expected));
                break;
            default:
                checkResultFailed();
        }
    }
}