package Pages;

import io.cucumber.datatable.DataTable;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.StringSelection;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class AutocompletePage {
    @FindBy(id = "autocomplete")
    public static WebElement inputFieldAddress;
    @FindBy(id = "street_number")
    public static WebElement inputFieldStreetAddress;
    @FindBy(id = "route")
    public static WebElement inputFieldStreetAddress2;
    @FindBy(id = "locality")
    public static WebElement inputFieldCity;
    @FindBy(id = "administrative_area_level_1")
    public static WebElement inputFieldState;
    @FindBy(id = "postal_code")
    public static WebElement inputFieldZipCode;
    @FindBy(id = "country")
    public static WebElement inputFieldCountry;
    @FindBy(xpath = "//h1[text()='Autocomplete']")
    public static WebElement titleAutocomplete;
    @FindBy(xpath = "//div[@class='pac-item'][1]")
    public static WebElement dropdownList;
    @FindBy(xpath = "//div[@class='pac-item'][2]")
    public static WebElement dropdownList2Element;
    @FindBy(xpath = "//div[@class='pac-item'][3]")
    public static WebElement dropdownList3Element;
    @FindBy(xpath = "//div[@class='pac-item'][4]")
    public static WebElement dropdownList4Element;
    @FindBy(xpath = "//div[@class='pac-item'][5]")
    public static WebElement dropdownList5Element;

    WebDriver driver;

    public AutocompletePage(WebDriver driver) {
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

    public String getOSValue() throws IOException {
        FileInputStream fis = new FileInputStream("src/main/resources/config.properties");
        Properties prop = new Properties();
        prop.load(fis);
        return prop.getProperty("os");
    }

    public String getInputFieldValue(WebElement arg1) throws Exception {
        StringSelection sS = new StringSelection("");
        Toolkit.getDefaultToolkit().getSystemClipboard().setContents(sS, null);
        String osType = getOSValue();
        if (osType.equals("macOS")) {
            arg1.sendKeys(Keys.chord(Keys.COMMAND + "a"));
            arg1.sendKeys(Keys.chord(Keys.COMMAND + "c"));
        }
        if (osType.equals("windowsOS") || osType.equals("linuxOS")) {
            arg1.sendKeys(Keys.chord(Keys.CONTROL + "a"));
            arg1.sendKeys(Keys.chord(Keys.CONTROL + "c"));
        }
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
        return (String) clipboard.getData(DataFlavor.stringFlavor);
    }

    public void pasteValueToInputField(WebElement arg1) throws Exception {
        String osType = getOSValue();
        if (osType.equals("macOS")) {
            arg1.sendKeys(Keys.chord(Keys.COMMAND + "v"));
        }
        if (osType.equals("windowsOS") || osType.equals("linuxOS")) {
            arg1.sendKeys(Keys.chord(Keys.CONTROL + "v"));
        }
    }

    public void isDropdownDisplayedCheck(WebElement arg1, String arg2) {
        if (!(arg1.getText().equals(""))) {
            checkResult(arg2.equals("Address"));
        } else {
            checkResult(!arg2.equals("Address"));
        }
    }

    public void isAllFieldsEmptyCheck() throws Exception {
        checkResult(getInputFieldValue(inputFieldAddress).equals("") && getInputFieldValue(inputFieldStreetAddress)
                .equals("") && getInputFieldValue(inputFieldStreetAddress2).equals("") && getInputFieldValue(inputFieldCity)
                .equals("") && getInputFieldValue(inputFieldState).equals("") && getInputFieldValue(inputFieldZipCode)
                .equals("") && getInputFieldValue(inputFieldCountry).equals(""));
    }

    public void enterDataInField(String arg1, DataTable table) throws Exception {
        java.util.List<String> fieldData = table.asList();
        switch (arg1) {
            case "Address":
                inputFieldAddress.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldAddress).equals(fieldData.get(0)));
                break;
            case "Street address":
                inputFieldStreetAddress.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldStreetAddress).equals(fieldData.get(0)));
                break;
            case "Street address 2":
                inputFieldStreetAddress2.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldStreetAddress2).equals(fieldData.get(0)));
                break;
            case "City":
                inputFieldCity.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldCity).equals(fieldData.get(0)));
                break;
            case "State":
                inputFieldState.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldState).equals(fieldData.get(0)));
                break;
            case "Zip code":
                inputFieldZipCode.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldZipCode).equals(fieldData.get(0)));
                break;
            case "Country":
                inputFieldCountry.sendKeys(fieldData.get(0));
                checkResult(getInputFieldValue(inputFieldCountry).equals(fieldData.get(0)));
                break;
        }
    }

    public void dropdownDisplayed(String arg1) {
        switch (arg1) {
            case "Address":
                inputFieldAddress.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldAddress.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldAddress.click();
                dropdownList.getText();
                inputFieldAddress.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "Street address":
                inputFieldStreetAddress.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldStreetAddress.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldStreetAddress.click();
                dropdownList.getText();
                inputFieldStreetAddress.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "Street address 2":
                inputFieldStreetAddress2.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldStreetAddress2.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldStreetAddress2.click();
                dropdownList.getText();
                inputFieldStreetAddress2.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "City":
                inputFieldCity.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldCity.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldCity.click();
                dropdownList.getText();
                inputFieldCity.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "State":
                inputFieldState.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldState.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldState.click();
                dropdownList.getText();
                inputFieldState.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "Zip code":
                inputFieldZipCode.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldZipCode.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldZipCode.click();
                dropdownList.getText();
                inputFieldZipCode.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
            case "Country":
                inputFieldCountry.sendKeys(Keys.RIGHT);
                dropdownList.getText();
                inputFieldCountry.sendKeys(Keys.LEFT);
                dropdownList.getText();
                inputFieldCountry.click();
                dropdownList.getText();
                inputFieldCountry.sendKeys(Keys.SPACE);
                isDropdownDisplayedCheck(dropdownList, arg1);
                break;
        }
    }

    public void isElementsInDropdownDisplayed(String arg1) throws InterruptedException {
        Thread.sleep(300);
        checkResult((dropdownList.getText().contains(arg1)) && (dropdownList2Element.getText().contains(arg1)) &&
                (dropdownList3Element.getText().contains(arg1)) && (dropdownList4Element.getText().contains(arg1)) &&
                (dropdownList5Element.getText().contains(arg1)));
    }

    public void isAutocompleteCorrect(String arg1, DataTable table) throws Exception {
        java.util.List<String> elements = table.asList();
        inputFieldAddress.sendKeys(Keys.RIGHT);
        dropdownList.getText();
        inputFieldAddress.sendKeys(Keys.LEFT);
        dropdownList.getText();
        inputFieldAddress.click();
        dropdownList.getText();
        inputFieldAddress.sendKeys(Keys.SPACE);
        dropdownList.click();
        Thread.sleep(300);
        checkResult(getInputFieldValue(inputFieldAddress).equals(arg1) && getInputFieldValue(inputFieldStreetAddress).equals("") &&
                getInputFieldValue(inputFieldStreetAddress2).equals("") && getInputFieldValue(inputFieldCity).equals(elements.get(0)) &&
                getInputFieldValue(inputFieldState).equals(elements.get(1)) && getInputFieldValue(inputFieldZipCode).equals("") &&
                getInputFieldValue(inputFieldCountry).equals(elements.get(2)));
    }

    public void refreshPageCheckFields() throws Exception {
        driver.navigate().refresh();
        isAllFieldsEmptyCheck();
    }

    public void backwardForwardPageSavingFieldsData(DataTable table) throws Exception {
        Thread.sleep(500);
        java.util.List<String> elements = table.asList();
        checkResult(getInputFieldValue(inputFieldAddress).equals(elements.get(0)) && getInputFieldValue(inputFieldStreetAddress)
                .equals(elements.get(1)) && getInputFieldValue(inputFieldStreetAddress2).equals(elements.get(2)) &&
                getInputFieldValue(inputFieldCity).equals(elements.get(3)) && getInputFieldValue(inputFieldState).equals(elements.get(4)) &&
                getInputFieldValue(inputFieldZipCode).equals(elements.get(5)) && getInputFieldValue(inputFieldCountry).equals(elements.get(6)));
    }

    public void isTitleDisplayedOk(String arg1) {
        WebElement titleForm = driver.findElement(By.xpath("//h1[text()='" + arg1 + "']"));
        titleForm.getText();
    }

    public void isFieldTitlePlaceholderDisplayedCorrectly(String arg1, String arg2, String arg3) {
        if (arg2.equals("title")) {
            try {
                WebElement fieldTitle = driver.findElement(By.xpath("//label[text()='" + arg1 + "']"));
                fieldTitle.getText();
                System.out.println("PASSED");
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        }
        if (arg2.equals("placeholder")) {
            try {
                WebElement placeholderField = driver.findElement(By.xpath("//input[@placeholder='" + arg3 + "']"));
                placeholderField.getText();
                System.out.println("PASSED");
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        }
    }

    public void copyDataFromField(String arg1) throws Exception {
        switch (arg1) {
            case "Address":
                clearMethod(inputFieldAddress);
                break;
            case "Street address":
                clearMethod(inputFieldStreetAddress);
                break;
            case "Street address 2":
                clearMethod(inputFieldStreetAddress2);
                break;
            case "City":
                clearMethod(inputFieldCity);
                break;
            case "State":
                clearMethod(inputFieldState);
                break;
            case "Zip code":
                clearMethod(inputFieldZipCode);
                break;
            case "Country":
                clearMethod(inputFieldCountry);
                break;
        }
    }

    public void clearMethod(WebElement arg1) throws Exception {
        String copyDataFromField = getInputFieldValue(arg1);
        arg1.sendKeys(Keys.DELETE);
        pasteValueToInputField(arg1);
        String copyDataFromFieldFinal = getInputFieldValue(arg1);
        checkResult(copyDataFromField.equals(copyDataFromFieldFinal));
    }

    public void clearViaDelete(String arg1) {
        switch (arg1) {
            case "Address":
                inputFieldAddress.sendKeys(Keys.DELETE);
                break;
            case "Street address":
                inputFieldStreetAddress.sendKeys(Keys.DELETE);
                break;
            case "Street address 2":
                inputFieldStreetAddress2.sendKeys(Keys.DELETE);
                break;
            case "City":
                inputFieldCity.sendKeys(Keys.DELETE);
                break;
            case "State":
                inputFieldState.sendKeys(Keys.DELETE);
                break;
            case "Zip code":
                inputFieldZipCode.sendKeys(Keys.DELETE);
                break;
            case "Country":
                inputFieldCountry.sendKeys(Keys.DELETE);
                break;
        }
    }
}