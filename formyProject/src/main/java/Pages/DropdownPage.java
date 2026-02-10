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

public class DropdownPage {
    WebDriver driver;
    @FindBy(id = "dropdownMenuButton")
    public static WebElement dropdownButton;
    @FindBy(className = "dropdown-menu show")
    public static WebElement dropdownList;

    public DropdownPage(WebDriver driver) {
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

    public void isTitleDisplayed(String arg1) {
        checkResult(dropdownButton.getText().equals(arg1));
    }

    public void isButtonSelectedOrEnabled() {
        checkResult(dropdownButton.isEnabled() && !(dropdownButton.isSelected()));
    }

    public void isClickDropdownButton() {
        dropdownButton.click();
    }

    public void isDropdownListDisplayed(DataTable table) {
        java.util.List<String> elementsList = table.asList();
        try {
            for (String a : elementsList) {
                WebElement findElementsInButtonDropdown = driver.findElement(By.xpath("//div[@class='dropdown-menu show']/a[@class='dropdown-item' and text()='" + a + "']"));
                findElementsInButtonDropdown.getText();
            }
            System.out.println("PASSED");
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void isListClosed() {
        try {
            dropdownList.isDisplayed();
            checkResultFailed();
        } catch (NoSuchElementException e) {
            System.out.println("PASSED");
        }
    }

    public void isPageOpenedFromDropdownList(String arg1, String arg2) {
        try {
            WebElement findElementsInButtonDropdownList = driver.findElement(By.xpath
                    ("//div[@class='dropdown-menu show']/a[@class='dropdown-item' and text()='" + arg1 + "']"));
            findElementsInButtonDropdownList.click();
            checkResult(driver.getCurrentUrl().substring(36).equals(arg2));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }
}