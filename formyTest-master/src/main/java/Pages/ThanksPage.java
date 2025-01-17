package Pages;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ThanksPage {
    WebDriver driver;
    @FindBy(xpath = "//div[@role='alert']")
    public static WebElement successTitle;
    @FindBy(xpath = "//h1[text()='Thanks for submitting your form']")
    public static WebElement pageTitle;

    public ThanksPage(WebDriver driver) {
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

    public void hasThanksElementTitleCheck(String arg1) {
        checkResult(successTitle.getText().equals(arg1));
    }

    public void hasUnselectedTitleCheck(String arg1) {
        switch (arg1) {
            case "success title":
                checkResult(!successTitle.isSelected());
                break;
            case "page title":
                checkResult(!pageTitle.isSelected());
                break;
        }
    }
}