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

public class RadioButtonPage {
    private final WebDriver driver;
    @FindBy(id = "radio-button-1")
    private WebElement radioButton1;
    @FindBy(xpath = "//input[@value='option2']")
    private WebElement radioButton2;
    @FindBy(xpath = "//input[@value='option3']")
    private WebElement radioButton3;
    @FindBy(xpath = "//label[@for='radio-button-1']")
    private WebElement radioButton1Title;
    @FindBy(xpath = "//label[@for='radio-button-2']")
    private WebElement radioButton2Title;
    @FindBy(xpath = "//label[@for='radio-button-3']")
    private WebElement radioButton3Title;

    public RadioButtonPage(WebDriver driver) {
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


    public void hasRadioButtonTitleCheck(String arg1, String arg2) {
        switch (arg1) {
            case "Radio button 1":
                checkResult(radioButton1Title.getText().equals(arg2));
                break;
            case "Radio button 2":
                checkResult(radioButton2Title.getText().equals(arg2));
                break;
            case "Radio button 3":
                checkResult(radioButton3Title.getText().equals(arg2));
                break;
        }
    }

    public void hasRadioButtonSelectionCheck(String arg1, String arg2) {
        switch (arg2) {
            case "selected":
                switch (arg1) {
                    case "Radio button 1":
                        checkResult(radioButton1.isSelected());
                        break;
                    case "Radio button 2":
                        checkResult(radioButton2.isSelected());
                        break;
                    case "Radio button 3":
                        checkResult(radioButton3.isSelected());
                        break;
                }
                break;
            case "unselected":
                switch (arg1) {
                    case "Radio button 1":
                        checkResult(!(radioButton1.isSelected()));
                        break;
                    case "Radio button 2":
                        checkResult(!(radioButton2.isSelected()));
                        break;
                    case "Radio button 3":
                        checkResult(!(radioButton3.isSelected()));
                        break;
                }
                break;
        }
    }

    public void hasRadioButtonClickCheck(String arg1) {
        switch (arg1) {
            case "Radio button 1 radio button":
                radioButton1.click();
                break;
            case "Radio button 2 radio button":
                radioButton2.click();
                break;
            case "Radio button 3 radio button":
                radioButton3.click();
                break;
            case "Radio button 1 title":
                radioButton1Title.click();
                break;
            case "Radio button 2 title":
                radioButton2Title.click();
                break;
            case "Radio button 3 title":
                radioButton3Title.click();
                break;
        }
    }

    public void hasRadioButtonEscCheck(){
        radioButton1.sendKeys(Keys.ESCAPE);
    }

    public void hasRadioButtonEnterCheck(){
        radioButton1.sendKeys(Keys.ENTER);
    }
}

