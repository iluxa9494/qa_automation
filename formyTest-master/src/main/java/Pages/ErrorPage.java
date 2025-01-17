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

public class ErrorPage {
    WebDriver driver;
    @FindBy(xpath = "//div/h1")
    public static WebElement firstTitle;
    @FindBy(xpath = "//div/div/p")
    public static WebElement secondTitle;
    @FindBy(xpath = "//div[@class='dialog']/p")
    public static WebElement thirdTitle;

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

    public void isTitleErrorDisplayed(String arg1, String arg2) {
        switch (arg1) {
            case ("first"):
                checkResult(firstTitle.getText().equals(arg2));
                break;
            case ("second"):
                checkResult(secondTitle.getText().equals(arg2));
                break;
            case ("third"):
                checkResult(thirdTitle.getText().equals(arg2));
                break;
        }
    }
}