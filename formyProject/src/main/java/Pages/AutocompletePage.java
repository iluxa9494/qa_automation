package Pages;

import io.cucumber.datatable.DataTable;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import java.time.Duration;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.openqa.selenium.support.PageFactory;

public class AutocompletePage {

    @FindBy(id = "autocomplete")
    private WebElement inputFieldAddress;
    @FindBy(id = "street_number")
    private WebElement inputFieldStreetAddress;
    @FindBy(id = "route")
    private WebElement inputFieldStreetAddress2;
    @FindBy(id = "locality")
    private WebElement inputFieldCity;
    @FindBy(id = "administrative_area_level_1")
    private WebElement inputFieldState;
    @FindBy(id = "postal_code")
    private WebElement inputFieldZipCode;
    @FindBy(id = "country")
    private WebElement inputFieldCountry;

    @FindBy(xpath = "//h1[text()='Autocomplete']")
    private WebElement titleAutocomplete;

    @FindBy(xpath = "//div[@class='pac-item'][1]")
    private WebElement dropdownList;
    @FindBy(xpath = "//div[@class='pac-item'][2]")
    private WebElement dropdownList2Element;
    @FindBy(xpath = "//div[@class='pac-item'][3]")
    private WebElement dropdownList3Element;
    @FindBy(xpath = "//div[@class='pac-item'][4]")
    private WebElement dropdownList4Element;
    @FindBy(xpath = "//div[@class='pac-item'][5]")
    private WebElement dropdownList5Element;

    private final WebDriver driver;
    private final WebDriverWait wait;

    public AutocompletePage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    private void waitVisible(WebElement el) {
        wait.until(ExpectedConditions.visibilityOf(el));
    }

    private void waitClickable(WebElement el) {
        wait.until(ExpectedConditions.elementToBeClickable(el));
    }

    private void clickWithRetry(By locator) {
        int attempts = 0;
        while (attempts < 3) {
            try {
                attempts++;
                WebElement el = wait.until(ExpectedConditions.elementToBeClickable(locator));
                el.click();
                return;
            } catch (StaleElementReferenceException | ElementClickInterceptedException e) {
                if (attempts >= 3) {
                    throw e;
                }
            }
        }
    }

    private void waitForPacResults() {
        // Google autocomplete renders results asynchronously; wait for container then items.
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".pac-container")));
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".pac-item")));
    }

    private boolean isPacVisibleShort() {
        try {
            WebDriverWait shortWait = new WebDriverWait(driver, Duration.ofSeconds(2));
            shortWait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".pac-container")));
            return true;
        } catch (TimeoutException e) {
            return false;
        }
    }

    private String valueOf(WebElement el) {
        String v = el.getAttribute("value");
        return v == null ? "" : v;
    }

    // =========================
    // ✅ Backward-compatible API
    // (чтобы не падали другие Page/Steps)
    // =========================

    public String getInputFieldValue(WebElement el) {
        return valueOf(el);
    }

    public void clearMethod(WebElement el) {
        waitVisible(el);
        el.clear();
        wait.until(d -> valueOf(el).equals(""));
    }

    public void pasteValueToInputField(WebElement el) {
        waitVisible(el);
        el.click();
        // В CI/Headless clipboard может вести себя нестабильно,
        // но оставляем как было по смыслу.
        el.sendKeys(Keys.chord(Keys.CONTROL, "v"));
    }

    public String copyDataFromField(String arg1) {
        WebElement field = resolveField(arg1);
        if (field == null) return "";

        waitVisible(field);
        field.click();

        // Пытаемся "как пользователь"
        try {
            field.sendKeys(Keys.chord(Keys.CONTROL, "a"));
            field.sendKeys(Keys.chord(Keys.CONTROL, "c"));
        } catch (Exception ignored) {
        }

        // Возвращаем то, что реально в value
        return valueOf(field);
    }

    private WebElement resolveField(String arg1) {
        switch (arg1) {
            case "Address": return inputFieldAddress;
            case "Street address": return inputFieldStreetAddress;
            case "Street address 2": return inputFieldStreetAddress2;
            case "City": return inputFieldCity;
            case "State": return inputFieldState;
            case "Zip code": return inputFieldZipCode;
            case "Country": return inputFieldCountry;
            default: return null;
        }
    }

    // =========================
    // Остальная логика
    // =========================

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
        if (arg1) System.out.println("PASSED");
        else checkResultFailed();
    }

    public void checkResultFailed() {
        makeScreenshot();
        Assert.fail("FAILED");
    }

    public void isAllFieldsEmptyCheck() {
        waitVisible(inputFieldAddress);
        checkResult(
                valueOf(inputFieldAddress).equals("") &&
                        valueOf(inputFieldStreetAddress).equals("") &&
                        valueOf(inputFieldStreetAddress2).equals("") &&
                        valueOf(inputFieldCity).equals("") &&
                        valueOf(inputFieldState).equals("") &&
                        valueOf(inputFieldZipCode).equals("") &&
                        valueOf(inputFieldCountry).equals("")
        );
    }

    public void enterDataInField(String arg1, DataTable table) {
        java.util.List<String> fieldData = table.asList();
        String text = fieldData.get(0);

        WebElement field = resolveField(arg1);
        if (field == null) return;

        waitVisible(field);
        field.clear();
        field.sendKeys(text);
        wait.until(d -> valueOf(field).equals(text));
        checkResult(valueOf(field).equals(text));
    }

    public void dropdownDisplayed(String arg1) {
        WebElement field = resolveField(arg1);
        if (field == null) return;

        waitClickable(field);
        field.click();
        field.sendKeys(Keys.SPACE);

        if ("Address".equals(arg1)) {
            waitForPacResults();
            waitVisible(dropdownList);
            checkResult(!dropdownList.getText().equals(""));
        } else {
            checkResult(!isPacVisibleShort());
        }
    }

    public void isElementsInDropdownDisplayed(String arg1) {
        waitForPacResults();
        waitVisible(dropdownList);
        waitVisible(dropdownList2Element);
        waitVisible(dropdownList3Element);
        waitVisible(dropdownList4Element);
        waitVisible(dropdownList5Element);

        checkResult(
                dropdownList.getText().contains(arg1) &&
                        dropdownList2Element.getText().contains(arg1) &&
                        dropdownList3Element.getText().contains(arg1) &&
                        dropdownList4Element.getText().contains(arg1) &&
                        dropdownList5Element.getText().contains(arg1)
        );
    }

    public void isAutocompleteCorrect(String expectedAddress, DataTable table) {
        java.util.List<String> elements = table.asList();

        waitClickable(inputFieldAddress);
        inputFieldAddress.click();
        inputFieldAddress.sendKeys(Keys.SPACE);

        waitForPacResults();
        clickWithRetry(By.cssSelector(".pac-item"));

        wait.until(d -> !valueOf(inputFieldCity).isEmpty());

        checkResult(
                valueOf(inputFieldAddress).equals(expectedAddress) &&
                        valueOf(inputFieldStreetAddress).equals("") &&
                        valueOf(inputFieldStreetAddress2).equals("") &&
                        valueOf(inputFieldCity).equals(elements.get(0)) &&
                        valueOf(inputFieldState).equals(elements.get(1)) &&
                        valueOf(inputFieldZipCode).equals("") &&
                        valueOf(inputFieldCountry).equals(elements.get(2))
        );
    }

    public void refreshPageCheckFields() {
        driver.navigate().refresh();
        isAllFieldsEmptyCheck();
    }

    public void backwardForwardPageSavingFieldsData(DataTable table) {
        java.util.List<String> elements = table.asList();
        waitVisible(inputFieldAddress);

        checkResult(
                valueOf(inputFieldAddress).equals(elements.get(0)) &&
                        valueOf(inputFieldStreetAddress).equals(elements.get(1)) &&
                        valueOf(inputFieldStreetAddress2).equals(elements.get(2)) &&
                        valueOf(inputFieldCity).equals(elements.get(3)) &&
                        valueOf(inputFieldState).equals(elements.get(4)) &&
                        valueOf(inputFieldZipCode).equals(elements.get(5)) &&
                        valueOf(inputFieldCountry).equals(elements.get(6))
        );
    }

    public void isTitleDisplayedOk(String arg1) {
        WebElement titleForm = wait.until(
                ExpectedConditions.visibilityOfElementLocated(By.xpath("//h1[text()='" + arg1 + "']"))
        );
        titleForm.getText();
    }

    public void isFieldTitlePlaceholderDisplayedCorrectly(String arg1, String arg2, String arg3) {
        try {
            if (arg2.equals("title")) {
                WebElement fieldTitle = wait.until(
                        ExpectedConditions.visibilityOfElementLocated(By.xpath("//label[text()='" + arg1 + "']"))
                );
                fieldTitle.getText();
                System.out.println("PASSED");
            }
            if (arg2.equals("placeholder")) {
                WebElement placeholderField = wait.until(
                        ExpectedConditions.visibilityOfElementLocated(By.xpath("//input[@placeholder='" + arg3 + "']"))
                );
                placeholderField.getText();
                System.out.println("PASSED");
            }
        } catch (TimeoutException e) {
            checkResultFailed();
        }
    }

    public void clearViaDelete(String arg1) {
        WebElement field = resolveField(arg1);
        if (field == null) return;

        waitVisible(field);
        field.sendKeys(Keys.chord(Keys.CONTROL, "a"));
        field.sendKeys(Keys.DELETE);
        wait.until(d -> valueOf(field).equals(""));
        checkResult(valueOf(field).equals(""));
    }
}
