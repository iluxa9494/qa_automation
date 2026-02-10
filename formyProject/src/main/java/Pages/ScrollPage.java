package Pages;

import io.cucumber.datatable.DataTable;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.testng.Assert;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ScrollPage {
    WebDriver driver;
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);
    @FindBy(id = "name")
    public static WebElement fullNameInput;
    @FindBy(id = "date")
    public static WebElement dateInput;

    public ScrollPage(WebDriver driver) {
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

    public void hasScrollTextParagraphCheck(String arg1, String arg2) {
        try {
            WebElement paragraph = driver.findElement(By.xpath("//p[" + arg1.charAt(0) + "]"));
            checkResult(paragraph.getText().equals(arg2));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void hasScrollTitleTextCheck(String arg1, String arg2) {
        try {
            WebElement titleElement = driver.findElement(By.xpath("//label[text()='" + arg1 + "']"));
            checkResult(titleElement.getText().equals(arg2));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void hasScrollPlaceholderTextCheck(String arg1, String arg2) {
        switch (arg1) {
            case "Full Name":
                checkResult(fullNameInput.getAttribute("placeholder").equals(arg2));
                break;
            case "Date":
                checkResult(dateInput.getAttribute("placeholder").equals(arg2));
                break;
        }
    }

    public void hasScrollFieldUnselectedEnabledCheck(String arg1) {
        switch (arg1) {
            case "Full Name":
                checkResult(!fullNameInput.isSelected() && fullNameInput.isEnabled());
                break;
            case "Date":
                checkResult(!dateInput.isSelected() && dateInput.isEnabled());
                break;
        }
    }

    public void hasScrollFieldDataEnterCheck(String arg1, DataTable table) throws Exception {
        java.util.List<String> fieldData = table.asList();
        switch (arg1) {
            case "full name":
                fullNameInput.sendKeys(fieldData.get(0));
                checkResult(autocompletePage.getInputFieldValue(fullNameInput).equals(fieldData.get(0)));
                break;
            case "date":
                dateInput.sendKeys(fieldData.get(0));
                checkResult(autocompletePage.getInputFieldValue(dateInput).equals(fieldData.get(0)));
                break;
        }
    }

    public void hasScrollFieldDeleteCheck(String arg1) {
        switch (arg1) {
            case "full name":
                fullNameInput.sendKeys(Keys.DELETE);
                break;
            case "date":
                dateInput.sendKeys(Keys.DELETE);
                break;
        }
    }

    public void hasScrollPageToCheck(String arg1) {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        switch (arg1) {
            case "500 px down to the page bottom":
                js.executeScript("window.scrollBy(0,500)");
                break;
            case "250 px up to the page middle":
                js.executeScript("window.scrollBy(0,-250)");
                break;
            case "500 px up to the page top":
                js.executeScript("window.scrollBy(0,-500)");
                break;
            case "250 px down to the page middle":
                js.executeScript("window.scrollBy(0,250)");
                break;
        }
    }

    public void hasScrollPositionCheck(String arg1) {
        switch (arg1) {
            case "bottom":
                positionCheck(500L, arg1);
                break;
            case "middle":
                positionCheck(250L, arg1);
                break;
            case "top":
                positionCheck(0L, arg1);
                break;
            case "after refresh bottom": // offset by 3 px up has been accepted as norm (a feature)
                positionCheck(497L, arg1);
                break;
        }
    }

    public void positionCheck(Long arg1, String arg2) {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        checkResult((long) js.executeScript("return window.pageYOffset;") == arg1);
    }
}