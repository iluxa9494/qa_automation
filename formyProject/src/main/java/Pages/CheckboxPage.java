package Pages;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.openqa.selenium.support.PageFactory;

public class CheckboxPage {
    private final WebDriver driver;
    @FindBy(id = "checkbox-1")
    private WebElement checkbox1;
    @FindBy(id = "checkbox-2")
    private WebElement checkbox2;
    @FindBy(id = "checkbox-3")
    private WebElement checkbox3;

    public CheckboxPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
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

    public void isCorrectTitle(String arg1, String arg2) {
        try {
            WebElement pageTitle = driver.findElement(By.xpath("//h1[text()='" + arg2 + "']"));
            checkResult(pageTitle.getText().equals(arg2));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void areCheckboxesNotSelected() {
        checkResult(!(checkbox1.isSelected() && checkbox2.isSelected() && checkbox3.isSelected()));
    }

    public void areCheckboxesSelected() {
        checkResult(checkbox1.isSelected() && checkbox2.isSelected() && checkbox3.isSelected());
    }

    public void areClickOnCheckbox(String arg1) {
        switch (arg1) {
            case "Checkbox1":
                checkbox1.click();
                break;
            case "Checkbox2":
                checkbox2.click();
                break;
            case "Checkbox3":
                checkbox3.click();
                break;
        }
    }
}

