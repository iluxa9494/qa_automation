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

public class FormPage {
    WebDriver driver;
    AutocompletePage autocompletePage = PageFactory.initElements(driver, AutocompletePage.class);
    @FindBy(xpath = "//label[@for='first-name']")
    public static WebElement firstNameTitle;
    @FindBy(xpath = "//label[@for='last-name']")
    public static WebElement lastNameTitle;
    @FindBy(xpath = "//label[@for='job-title']")
    public static WebElement jobTitle;
    @FindBy(xpath = "//label[text()='Highest level of education']")
    public static WebElement educationTitle;
    @FindBy(xpath = "//label[text()='Sex']")
    public static WebElement sexTitle;
    @FindBy(xpath = "//label[@for='select-menu']")
    public static WebElement experienceTitle;
    @FindBy(xpath = "//label[text()='Date']")
    public static WebElement dateTitle;
    @FindBy(xpath = "//a[text()='Submit']")
    public static WebElement submitButton;
    @FindBy(id = "select-menu")
    public static WebElement experienceSelector;
    @FindBy(id = "radio-button-1")
    public static WebElement radioButton1;
    @FindBy(id = "radio-button-2")
    public static WebElement radioButton2;
    @FindBy(id = "radio-button-3")
    public static WebElement radioButton3;
    @FindBy(id = "first-name")
    public static WebElement firstNameInput;
    @FindBy(id = "last-name")
    public static WebElement lastNameInput;
    @FindBy(id = "job-title")
    public static WebElement jobInput;
    @FindBy(id = "checkbox-1")
    public static WebElement checkbox1;
    @FindBy(id = "checkbox-2")
    public static WebElement checkbox2;
    @FindBy(id = "checkbox-3")
    public static WebElement checkbox3;
    @FindBy(xpath = "//option[text()='Select an option']")
    public static WebElement selectorSelectAnOption;
    @FindBy(xpath = "//option[text()='0-1']")
    public static WebElement selector01;
    @FindBy(xpath = "//option[text()='2-4']")
    public static WebElement selector24;
    @FindBy(xpath = "//option[text()='5-9']")
    public static WebElement selector59;
    @FindBy(xpath = "//option[text()='10+']")
    public static WebElement selector10plus;

    public FormPage(WebDriver driver) {
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

    public void hasElementPageTitle(String arg1, String arg2) {
        switch (arg1) {
            case "first name input":
                checkResult(firstNameTitle.getText().equals(arg2));
                break;
            case "last name input":
                checkResult(lastNameTitle.getText().equals(arg2));
                break;
            case "job title input":
                checkResult(jobTitle.getText().equals(arg2));
                break;
            case "education radio buttons":
                checkResult(educationTitle.getText().equals(arg2));
                break;
            case "sex checkboxes":
                checkResult(sexTitle.getText().equals(arg2));
                break;
            case "experience selector":
                checkResult(experienceTitle.getText().equals(arg2));
                break;
            case "input date":
                checkResult(dateTitle.getText().equals(arg2));
                break;
            case "submit button":
                checkResult(submitButton.getText().equals(arg2));
                break;
        }
    }

    public void hasElementPagePlaceholders(String arg1, String arg2) {
        switch (arg1) {
            case "first name input":
                comparePlaceholders(arg2);
                break;
            case "last name input":
                comparePlaceholders(arg2);
                break;
            case "job title input":
                comparePlaceholders(arg2);
                break;
            case "input date":
                comparePlaceholders(arg2);
                break;
        }
    }

    public void comparePlaceholders(String arg1) {
        try {
            WebElement inputFieldElements = driver.findElement(By.xpath("//input[@placeholder='" + arg1 + "']"));
            checkResult(inputFieldElements.isDisplayed());
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void isFieldTextCheck(String arg1) {
        try {
            WebElement selected = driver.findElement(By.xpath("//option[text()='" + arg1 + "']"));
            checkResult(selected.getText().equals(arg1));
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void isFormElementClick(String arg1) {
        switch (arg1) {
            case "experience selector":
                experienceSelector.click();
                break;
            case "High School radio button":
                radioButton1.click();
                break;
            case "College radio button":
                radioButton2.click();
                break;
            case "Grad School radio button":
                radioButton3.click();
                break;
            case "Male checkbox":
                checkbox1.click();
                break;
            case "Female checkbox":
                checkbox2.click();
                break;
            case "Prefer not to say checkbox":
                checkbox3.click();
                break;
            case "Select an option":
                selectorSelectAnOption.click();
                break;
            case "0-1":
                selector01.click();
                break;
            case "2-4":
                selector24.click();
                break;
            case "5-9":
                selector59.click();
                break;
            case "10+":
                selector10plus.click();
                break;
            case "submit button":
                submitButton.click();
                break;
        }
    }

    public void elementHasOptionsCheck() {
        checkResult(!(!(selectorSelectAnOption.isSelected()) && selector01.isSelected() && selector24.isSelected()
                && selector59.isSelected() && selector10plus.isSelected()));
    }

    public void hasEmptyElementCheck(String arg1) throws Exception {
        switch (arg1) {
            case "first name input":
                checkResult(autocompletePage.getInputFieldValue(firstNameInput).equals(""));
                break;
            case "last name input":
                checkResult(autocompletePage.getInputFieldValue(lastNameInput).equals(""));
                break;
            case "job title input":
                checkResult(autocompletePage.getInputFieldValue(jobInput).equals(""));
                break;
        }
    }

    public void hasEnterAndCheckValue(String arg1, DataTable table) throws Exception {
        java.util.List<String> fieldData = table.asList();
        switch (arg1) {
            case "first name input":
                firstNameInput.sendKeys(fieldData.get(0));
                autocompletePage.checkResult(autocompletePage.getInputFieldValue(firstNameInput).equals(fieldData.get(0)));
                break;
            case "last name input":
                lastNameInput.sendKeys(fieldData.get(0));
                autocompletePage.checkResult(autocompletePage.getInputFieldValue(lastNameInput).equals(fieldData.get(0)));
                break;
            case "job title input":
                jobInput.sendKeys(fieldData.get(0));
                autocompletePage.checkResult(autocompletePage.getInputFieldValue(jobInput).equals(fieldData.get(0)));
                break;
        }
    }

    public void copyClearPasteAndCheck(String arg1) throws Exception {
        switch (arg1) {
            case "first name input":
                autocompletePage.clearMethod(firstNameInput);
                break;
            case "last name input":
                autocompletePage.clearMethod(lastNameInput);
                break;
            case "job title input":
                autocompletePage.clearMethod(jobInput);
                break;
        }
    }

    public void hasDeleteAndCheck(String arg1) {
        switch (arg1) {
            case "first name input":
                firstNameInput.sendKeys(Keys.DELETE);
                break;
            case "last name input":
                lastNameInput.sendKeys(Keys.DELETE);
                break;
            case "job title input":
                jobInput.sendKeys(Keys.DELETE);
                break;
        }
    }

    public void hasSelectedAndUnselectedElementsCheck(String arg1, String arg2) {
        switch (arg2) {
            case "selected":
                switch (arg1) {
                    case "High School radio button":
                        selectElementCheck(radioButton1);
                        break;
                    case "College radio button":
                        selectElementCheck(radioButton2);
                        break;
                    case "Grad School radio button":
                        selectElementCheck(radioButton3);
                        break;
                    case "Male checkbox":
                        selectElementCheck(checkbox1);
                        break;
                    case "Female checkbox":
                        selectElementCheck(checkbox2);
                        break;
                    case "Prefer not to say checkbox":
                        selectElementCheck(checkbox3);
                        break;
                    case "Select an option":
                        selectElementCheck(selectorSelectAnOption);
                        break;
                    case "0-1":
                        selectElementCheck(selector01);
                        break;
                    case "2-4":
                        selectElementCheck(selector24);
                        break;
                    case "5-9":
                        selectElementCheck(selector59);
                        break;
                    case "10+":
                        selectElementCheck(selector10plus);
                        break;
                }
                break;
            case "unselected":
                switch (arg1) {
                    case "High School radio button":
                        unselectElementCheck(radioButton1);
                        break;
                    case "College radio button":
                        unselectElementCheck(radioButton2);
                        break;
                    case "Grad School radio button":
                        unselectElementCheck(radioButton3);
                        break;
                    case "Male checkbox":
                        unselectElementCheck(checkbox1);
                        break;
                    case "Female checkbox":
                        unselectElementCheck(checkbox2);
                        break;
                    case "Prefer not to say checkbox":
                        unselectElementCheck(checkbox3);
                        break;
                }
                break;
        }
    }

    public void selectElementCheck(WebElement arg1) {
        checkResult(arg1.isSelected());
    }

    public void unselectElementCheck(WebElement arg1) {
        checkResult(!(arg1.isSelected()));
    }

    public void hasFormElementEnabledCheck() {
        checkResult(submitButton.isEnabled());
    }

    public void hasFormElementValueCheck(String arg1, String arg2, String arg3) throws Exception {
        checkResult(autocompletePage.getInputFieldValue(firstNameInput).equals(arg1) && autocompletePage.
                getInputFieldValue(lastNameInput).equals(arg2) && autocompletePage.getInputFieldValue(jobInput).equals(arg3));
    }
}