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

public class KeyPressPage {
    WebDriver driver;
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);
    DatepickerPage datepickerPage = PageFactory.initElements(driver, DatepickerPage.class);
    @FindBy(id = "name")
    public static WebElement fullNameInput;
    @FindBy(xpath = "//label[text()='Full name']")
    public static WebElement fullNameTitle;
    @FindBy(id = "button")
    public static WebElement button;

    public KeyPressPage(WebDriver driver) {
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

    public void hasTitlePlaceholderTextCheck(String arg1, String arg2, String arg3) {
        switch (arg1) {
            case "full name input":
                if (arg3.equals("title")) {
                    checkResult(fullNameTitle.getText().equals(arg2));
                }
                if (arg3.equals("placeholder")) {
                    try {
                        WebElement placeholder = driver.findElement(By.xpath("//input[@placeholder='Enter full name']"));
                        checkResult(placeholder.isEnabled());
                    } catch (NoSuchElementException e) {
                        checkResultFailed();
                    }
                }
                break;
            case "button":
                checkResult(button.getText().equals(arg2));
                break;
        }
    }

    public void hasElementUnselectedEnabled(String arg1) {
        switch (arg1) {
            case "full name input":
                checkResult(!(fullNameInput.isSelected()) && fullNameInput.isEnabled());
                break;
            case "button":
                checkResult(!(button.isSelected()) && button.isEnabled());
                break;
        }
    }

    public void hasEnterDataInField(DataTable table) throws Exception {
        java.util.List<String> fieldData = table.asList();
        fullNameInput.sendKeys(fieldData.get(0));
        hasFieldValueCheck(fieldData.get(0));
    }

    public void hasClickElementAndPageCheck(String arg1) {
        button.click();
        datepickerPage.openedPageCheck(driver.getCurrentUrl(), arg1);
    }

    public void hasFieldValueCheck(String arg1) throws Exception {
        checkResult(autocompletePage.getInputFieldValue(fullNameInput).equals(arg1));
    }

    public void hasInputElementEmpty() throws Exception {
        checkResult(autocompletePage.getInputFieldValue(fullNameInput).equals(""));
    }

    public void hasInputElementClearDelete() throws Exception {
        fullNameInput.sendKeys(Keys.DELETE);
        hasInputElementEmpty();
    }

    public void hasCopyClearPasteFieldCheck() throws Exception {
        autocompletePage.clearMethod(fullNameInput);
    }

    public void clickOnFiledElementCheck() {
        fullNameInput.click();
    }

    public void hasClearFieldCheck() {
        fullNameInput.clear();
    }

    public void hasEnterPress() {
        fullNameInput.sendKeys(Keys.ENTER);
    }
}