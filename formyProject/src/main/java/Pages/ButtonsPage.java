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

public class ButtonsPage {
    private final WebDriver driver;
    @FindBy(id = "btnGroupDrop1")
    private WebElement dropdownButton;
    @FindBy(xpath = "//div[@class='dropdown-menu show']")
    private WebElement dropdownList;
    @FindBy(xpath = "//a[text()= 'Dropdown link 1']")
    private WebElement dropdownList1;
    @FindBy(xpath = "//a[text()= 'Dropdown link 2']")
    private WebElement dropdownList2;

    public ButtonsPage(WebDriver driver) {
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
        driver.quit();
        Assert.fail("FAILED");
    }

    public void isTitleAbsent() {
        try {
            WebElement buttonsTitle = driver.findElement(By.xpath("//h1"));
            buttonsTitle.getText();
            checkResultFailed();
        } catch (NoSuchElementException e) {
            System.out.println("PASSED");
        }
    }

    public void isCorrectButtonsTitle(String arg1) {
        if (arg1.equals("Dropdown")) {
            checkResult(dropdownButton.getText().equals(arg1));
        } else {
            try {
                WebElement buttonsTitle = driver.findElement(By.xpath("//button[text()='" + arg1 + "']"));
                buttonsTitle.getText();
                System.out.println("PASSED");
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        }
    }

    public void isButtonsEnabledDisplayed(String arg1) {
        if (arg1.equals("Dropdown")) {
            checkResult(dropdownButton.isEnabled() && dropdownButton.isDisplayed());
            dropdownButton.click();
        } else {
            try {
                WebElement button = driver.findElement(By.xpath("//button[text()='" + arg1 + "']"));
                checkResult(button.isEnabled() && button.isDisplayed());
                button.click();
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        }
    }

    public void isDropdownListOpened() {
        checkResult(dropdownList.isDisplayed() && dropdownList1.isDisplayed() && dropdownList2.isDisplayed());
    }
}

