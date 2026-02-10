package Pages;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class SwitchWindowPage {

    WebDriver driver;
    @FindBy(id = "new-tab-button")
    public static WebElement openNewTabButton;
    @FindBy(id = "alert-button")
    public static WebElement openAlertButton;

    public SwitchWindowPage(WebDriver driver) {
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


    public void hasSwitchWindowButtonTitleCheck(String arg1, String arg2) {
        switch (arg1) {
            case "open new tab":
                checkResult(openNewTabButton.getText().equals(arg2));
                break;
            case "open alert":
                checkResult(openAlertButton.getText().equals(arg2));
                break;
        }
    }

    public void hasSwitchWindowButtonsUnselectedEnabledCheck(String arg1) {
        switch (arg1) {
            case "open new tab":
                checkResult(!openNewTabButton.isSelected() && openNewTabButton.isEnabled());
                break;
            case "open alert":
                checkResult(!openAlertButton.isSelected() && openAlertButton.isEnabled());
                break;
        }
    }

    public void hasSwitchWindowButtonsClickCheck(String arg1) {
        switch (arg1) {
            case "open new tab":
                openNewTabButton.click();
                break;
            case "open alert":
                openAlertButton.click();
                break;
        }
    }

    public void hasSwitchWindowTabCheck(String arg1) {
        ArrayList<String> tabs = new ArrayList<>(driver.getWindowHandles());
        switch (arg1) {
            case "new":
                driver.switchTo().window(tabs.get(1));
                break;
            case "previous":
                driver.close();
                driver.switchTo().window(tabs.get(0));
                break;
        }
    }

    public void hasSwitchWindowAlertOpenedCheck(String arg1) {
        switch (arg1) {
            case "opened":
                checkResult(alertCheck());
                break;
            case "absent":
                checkResult(!alertCheck());
                break;
        }
    }

    public boolean alertCheck() {
        try {
            driver.switchTo().alert();
            return true;
        } catch (NoAlertPresentException e) {
            return false;
        }
    }

    public void hasSwitchWindowAlertTitleCheck(String arg1) {
        checkResult(driver.switchTo().alert().getText().equals(arg1));
    }

    public void hasSwitchWindowAlertAcceptCheck() {
        driver.switchTo().alert().accept();
    }

    public void hasSwitchWindowAlertEscapeCheck() {
        driver.switchTo().alert().dismiss();
    }
}