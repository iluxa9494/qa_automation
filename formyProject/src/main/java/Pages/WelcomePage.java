package Pages;

import io.cucumber.datatable.DataTable;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class WelcomePage {
    WebDriver driver;
    @FindBy(xpath = "//p[text()='This is a simple site that has form components that can be used for testing purposes.']")
    public static WebElement firstTitle;
    @FindBy(xpath = "//p[text()='Here are the list of all the components']")
    public static WebElement secondTitle;

    public WelcomePage(WebDriver driver) {
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

    public void hasFirstSecondTitleCheck(String arg1, String arg2) {
        switch (arg1) {
            case "first title":
                checkResult(firstTitle.getText().equals(arg2));
                break;
            case "second title":
                checkResult(secondTitle.getText().equals(arg2));
                break;
        }
    }

    public void hasAllElementsInListCheck(DataTable table) throws InterruptedException {
        java.util.List<String> elementsList = table.asList();
        Thread.sleep(300);
        try {
            for (String a : elementsList) {
                WebElement listElement = driver.findElement(By.xpath("//a[@class='dropdown-item' and text()='" + a + "']"));
                listElement.isDisplayed();
            }
            System.out.println("PASSED");
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void haswelcomeElementUnselectedEnabledCheck(String arg1) {
        try {
            WebElement listElement = driver.findElement(By.xpath("//a[@class='dropdown-item' and text()='" + arg1 + "']"));
            checkResult(!listElement.isSelected() && listElement.isEnabled());
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }
}