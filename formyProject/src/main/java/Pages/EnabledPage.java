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

public class EnabledPage {
    WebDriver driver;
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);

    @FindBy(id = "disabledInput")
    public static WebElement disabledField;
    @FindBy(id = "input")
    public static WebElement enabledField;

    public EnabledPage(WebDriver driver) {
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

    public void isTitleAbsent() {
        try {
            WebElement buttonsTitle = driver.findElement(By.xpath("//h1"));
            buttonsTitle.getText();
            checkResultFailed();
        } catch (NoSuchElementException e) {
            System.out.println("PASSED");
        }
    }

    public void isUnselectedAndDisabledCheck() {
        checkResult(!disabledField.isSelected() && !disabledField.isEnabled());
    }

    public void isPlaceholderTextCheck(String arg1, String arg2) {
        try {
            WebElement inputFieldPlaceholder = driver.findElement(By.xpath("//input[@placeholder='" + arg2 + "']"));
            checkResult(inputFieldPlaceholder.isDisplayed());
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void isUnselectedAndDisabledEnabledFieldCheck() {
        checkResult(!enabledField.isSelected() && enabledField.isEnabled());
    }

    public void isInputFieldEmptyCheck() throws Exception {
        checkResult(autocompletePage.getInputFieldValue(enabledField).equals(""));
    }

    public void whatFieldValueCheck(String arg1) throws Exception {
        checkResult(autocompletePage.getInputFieldValue(enabledField).equals(arg1));
    }

    public void isEnterValueInEnabledInputFiled(DataTable table) throws Exception {
        java.util.List<String> fieldData = table.asList();
        enabledField.sendKeys(fieldData.get(0));
        whatFieldValueCheck(fieldData.get(0));
    }

    public void isClearEnabledInputFieldViaDelete() {
        enabledField.sendKeys(Keys.DELETE);
    }

    public void isCopyClearPasteValueEnabledInputField() throws Exception {
        enabledField.sendKeys(Keys.DELETE);
        autocompletePage.pasteValueToInputField(enabledField);
        String copyDataFromEnabledFieldFinal = autocompletePage.getInputFieldValue(enabledField);
        checkResult(autocompletePage.getInputFieldValue(enabledField).equals(copyDataFromEnabledFieldFinal));
    }

    public void isEnterValueInDisabledField(String arg1) throws ElementNotInteractableException {
        try {
            disabledField.sendKeys(arg1);
            checkResultFailed();
        } catch (ElementNotInteractableException e) {
            System.out.println("PASSED");
        }
    }
}