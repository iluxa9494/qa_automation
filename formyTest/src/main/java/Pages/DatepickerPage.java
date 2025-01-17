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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Properties;

public class DatepickerPage {
    WebDriver driver;
    @FindBy(xpath = "//input[@id='datepicker']")
    public static WebElement inputFieldDatepicker;
    @FindBy(xpath = "//h1[text()='Datepicker']")
    public static WebElement titleDatepicker;
    //calendar
    @FindBy(xpath = "//div[@class='datepicker-days']")
    public static WebElement calendarBody;
    //header elements
    @FindBy(xpath = "//a[@id='logo']")
    public static WebElement formyPage;
    @FindBy(xpath = "//a[text()='Form']")
    public static WebElement formPage;
    @FindBy(xpath = "//a[@id='navbarDropdownMenuLink']")
    public static WebElement headerDropdownComponents;
    LocalDate currentDate = LocalDate.now();
    @FindBy(xpath = "//td[@class='today day']")
    public static WebElement todayDay;
    //months
    String currentMonth = String.valueOf(currentDate.getMonth());
    LocalDate prevMonth = currentDate.minusMonths(1);
    String previousMonth = String.valueOf(prevMonth.getMonth());
    LocalDate forwardMonth = currentDate.plusMonths(1);
    String nextMonth = String.valueOf(forwardMonth.getMonth());
    //years
    LocalDate prevYear = currentDate.minusYears(1);
    String previousYear = String.valueOf(prevYear.getYear());
    LocalDate forwardYear = currentDate.plusYears(1);
    String nextYear = String.valueOf(forwardYear.getYear());
    //decades
    String previousDecade = "2010-2019";
    String nextDecade = "2030-2039";
    //centuries
    String previousCentury = "1900-1990";
    String nextCentury = "2100-2190";
    //millenniums
    String previousMillennium = "1000-1900";
    String nextMillennium = "3000-3900";

    public DatepickerPage(WebDriver driver) {
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

    public void refreshPage() {
        driver.navigate().refresh();
    }

    public void goPage(String page) {
        WebElement choosePage = driver.findElement(By.xpath("//li/a[@class='btn btn-lg' and text()='" + page + "']"));
        choosePage.click();
    }

    public void isCalendarOpened(String arg1) throws Exception {
        inputFieldDatepicker.click();
        isDropdownClose(arg1);
    }

    public void isDropdownClose(String arg1) {
        switch (arg1) {
            case "closed":
                try {
                    checkResult(!calendarBody.isDisplayed());
                } catch (NoSuchElementException e) {
                    System.out.println("PASSED");
                }
                break;
            case "opened":
                try {
                    checkResult(calendarBody.isDisplayed());
                } catch (NoSuchElementException e) {
                    checkResultFailed();
                }
                break;
        }
    }

    public void chooseElementIsOpened(String button, String date) {
        if (button.equals("next") || button.equals("previous")) {
            if (date.equals("month")) {
                date = "day";
            }
            if (date.equals("year")) {
                date = "month";
            }
            if (date.equals("decade")) {
                date = "year";
            }
            if (date.equals("century")) {
                date = "decade";
            }
            if (date.equals("millennium")) {
                date = "centurie";
            }
            if (button.equals("previous")) {
                button = "prev";
            }
            WebElement choseButton = driver.findElement(By.xpath("//div[@class='datepicker-" + date + "s']//th[@class='" + button + "']"));
            choseButton.click();
        }
        if (button.equals("Jan")) {
            WebElement choseButton = driver.findElement(By.xpath("//div[@class='datepicker-months']//span[contains(text(),'" + button + "')]"));
            choseButton.click();
        }
        WebElement calendarSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + date + "s']//th[@class='datepicker-switch']"));
        String getCurrentValueFromCalendar = calendarSwitcher.getText();
        if (date.equals("day")) {
            getCurrentValueFromCalendar = getCurrentValueFromCalendar.substring(0, getCurrentValueFromCalendar.length() - 5).toUpperCase();
        }
        switch (button) {
            case "prev":
                switch (date) {
                    case "day":
                        checkResult(getCurrentValueFromCalendar.equals(previousMonth));
                        break;
                    case "month":
                        checkResult(getCurrentValueFromCalendar.equals(previousYear));
                        break;
                    case "year":
                        checkResult(getCurrentValueFromCalendar.equals(previousDecade));
                        break;
                    case "decade":
                        checkResult(getCurrentValueFromCalendar.equals(previousCentury));
                        break;
                    case "centurie":
                        checkResult(getCurrentValueFromCalendar.equals(previousMillennium));
                        break;
                }
                break;
            case "next":
                switch (date) {
                    case "day":
                        checkResult(getCurrentValueFromCalendar.equals(nextMonth));
                        break;
                    case "month":
                        checkResult(getCurrentValueFromCalendar.equals(nextYear));
                        break;
                    case "year":
                        checkResult(getCurrentValueFromCalendar.equals(nextDecade));
                        break;
                    case "decade":
                        checkResult(getCurrentValueFromCalendar.equals(nextCentury));
                        break;
                    case "centurie":
                        checkResult(getCurrentValueFromCalendar.equals(nextMillennium));
                        break;
                }
                break;
        }
    }

    public void pickAndCheckCalendarDateIsDisplayed(String arg1, String arg2) throws Exception {
        switch (arg1) {
            case "1th day":
                WebElement firstCalendarDay = driver.findElement(By.xpath("//tr[1]//td[text()='1']"));
                firstCalendarDay.click();
                Thread.sleep(500);
                isDropdownClose(arg2);
                Thread.sleep(500);
                getCalendarPlaceholderValueByClipboard(arg1);
                break;

            case "current date":
                todayDay.click();
                isDropdownClose(arg2);
                getCalendarPlaceholderValueByClipboard(arg1);
                break;
        }
    }

    public String getInputFieldValue() throws Exception {
        StringSelection sS = new StringSelection("");
        Toolkit.getDefaultToolkit().getSystemClipboard().setContents(sS, null);
        String osType = getOSValue();
        if (osType.equals("macOS")) {
            inputFieldDatepicker.sendKeys(Keys.chord(Keys.COMMAND + "a"));
            inputFieldDatepicker.sendKeys(Keys.chord(Keys.COMMAND + "c"));
        }
        if (osType.equals("windowsOS") || osType.equals("linuxOS")) {
            inputFieldDatepicker.sendKeys(Keys.chord(Keys.CONTROL + "a"));
            inputFieldDatepicker.sendKeys(Keys.chord(Keys.CONTROL + "c"));
        }
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
        return (String) clipboard.getData(DataFlavor.stringFlavor);
    }

    public void currentDateCheck() throws Exception {
        DateTimeFormatter format = DateTimeFormatter.ofPattern("MM/dd/YYYY");
        checkResult(getInputFieldValue().equals(currentDate.format(format)));
    }

    public void checkCalendarValue(String arg1, String arg2) throws Exception {
        if (arg1.equals("current") && arg2.equals("date")) {
            currentDateCheck();
        }
        if (arg1.equals("current date") && arg2.equals("in the calendar")) {
            todayDay.click();
            currentDateCheck();
        }
        if (arg1.equals("01/01/2021")) {
            checkResult(getInputFieldValue().equals(arg1));
        }
        if ((arg1.equals("current") || arg1.equals("previous")) && arg2.equals("month")) {
            WebElement calendarSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-days']//th[@class='datepicker-switch']"));
            String getCurrentValueFromCalendar = calendarSwitcher.getText();
            String getSwitcherValue = getCurrentValueFromCalendar.substring(0, getCurrentValueFromCalendar.length() - 5).toUpperCase();
            switch (arg1) {
                case "current":
                    checkResult(getSwitcherValue.equals(currentMonth));
                    break;
                case "previous":
                    checkResult(getSwitcherValue.equals(previousMonth));
                    break;
            }
        }
    }

    public void getCalendarPlaceholderValueByClipboard(String date) throws Exception {
        switch (date) {
            case "1th day":
                checkResult(getInputFieldValue().startsWith("/01/", 2));
                break;
            case "current date":
                currentDateCheck();
                break;
        }
    }

    public void chooseAndCheckCurrentYearIsDisplayed(String arg1, String arg2, String arg3, String arg4, DataTable table) {
        java.util.List<String> monthsElements = table.asList();
        if (arg1.equals("month") || arg1.equals("year") || arg1.equals("decade") || arg1.equals("century")) {

            if (arg1.equals("month")) {
                arg1 = "day";
                WebElement dateSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//th[@class='datepicker-switch']"));
                dateSwitcher.click();
                arg1 = "month";
            }
            if (arg1.equals("year")) {
                arg1 = "month";
                WebElement dateSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//th[@class='datepicker-switch']"));
                dateSwitcher.click();
                arg1 = "year";
            }
            if (arg1.equals("decade")) {
                arg1 = "year";
                WebElement dateSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//th[@class='datepicker-switch']"));
                dateSwitcher.click();
                arg1 = "decade";
            }
            if (arg1.equals("century")) {
                arg1 = "decade";
                WebElement dateSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//th[@class='datepicker-switch']"));
                dateSwitcher.click();
                arg1 = "centurie";
            }
            WebElement dateSwitcherAfterChanging = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//th[@class='datepicker-switch']"));
            String switcherValueType1 = dateSwitcherAfterChanging.getText();
            try {
                if (switcherValueType1.equals(arg3)) {
                    for (String a : monthsElements) {
                        WebElement tableDateElement = driver.findElement(By.xpath("//div[@class='datepicker-" + arg1 + "s']//span[text()='" + a + "']"));
                        tableDateElement.getText();
                    }
                    System.out.println("PASSED");
                }
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        }

        if (arg1.equals("1000") || arg1.equals("1900") || arg1.equals("2010") || arg1.equals("2030") || arg1.equals("2100")
                || arg1.equals("3000")) {
            if (arg2.equals("year") || arg2.equals("decade") || arg2.equals("century")) {
                if (arg2.equals("century")) {
                    arg2 = "centurie";
                }
                WebElement tableDateSwitcher = driver.findElement(By.xpath("//div[@class='datepicker-" + arg2 + "s']//span[text()=" + arg1 + "]"));
                tableDateSwitcher.click();
                try {
                    WebElement getDateSwitcherValue = driver.findElement(By.xpath("//div[@class='datepicker-" + arg4 + "']//th[text()='" + arg3 + "']"));
                    getDateSwitcherValue.getText();
                    for (String a : monthsElements) {
                        WebElement tableDateElement = driver.findElement(By.xpath("//div[@class='datepicker-" + arg4 + "']//span[text()='" + a + "']"));
                        tableDateElement.getText();
                    }
                    System.out.println("PASSED");
                } catch (NoSuchElementException e) {
                    checkResultFailed();
                }
            }
        }
    }


    public void typeAndPress(String arg1) {
        inputFieldDatepicker.sendKeys(arg1, Keys.ENTER);
    }

    public void clickOnTitleCheck(String arg1) {
        titleDatepicker.click();
        isDropdownClose(arg1);
    }

    //header
    public void isPageOpened(String arg1, String arg2) {
        switch (arg1) {
            case "Formy":
                formyPage.click();
                break;
            case "Form":
                formPage.click();
                break;
            case "Backward":
                driver.navigate().back();
                break;
            case "Forward":
                driver.navigate().forward();
                break;
            case "Refresh":
                driver.navigate().refresh();
                break;
            default:
                WebElement clickOnComponentElement = driver.findElement(By.xpath("//a[@class='dropdown-item' and text()='" + arg1 + "']"));
                clickOnComponentElement.click();
                break;
        }
        if ("Welcome to Formy".equals(arg2)) {
            try {
                WebElement welcomeTitle = driver.findElement(By.xpath("//h1[text()='Welcome to Formy']"));
                checkResult(welcomeTitle.isEnabled());
            } catch (NoSuchElementException e) {
                checkResultFailed();
            }
        } else {
            openedPageCheck(driver.getCurrentUrl(), arg2);
        }
    }

    public void openedPageCheck(String arg1, String arg2) {
        checkResult(arg1.substring(36).equals(arg2));
    }

    public void output(WebElement arg1, String arg2) {
        try {
            arg1.getText();
            System.out.println("PASSED");
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }

    public void isPage(String arg1) { //byTitle
        switch (arg1) {
            case "Buttons":
                WebElement buttonPrimary = driver.findElement(By.xpath("//button[@type='button' and text()='Primary']"));
                output(buttonPrimary, arg1);
                break;
            case "Checkbox":
                WebElement pageTitleCheckbox = driver.findElement(By.xpath("//h1[text()='Checkboxes']"));
                output(pageTitleCheckbox, arg1);
                break;
            case "Drag and Drop":
                WebElement pageTitleDragDrop = driver.findElement(By.xpath("//h1[text()='Drag the image into the box']"));
                output(pageTitleDragDrop, arg1);
                break;
            case "Enabled and disabled elements":
                WebElement pageTitleEnabled = driver.findElement(By.xpath("//h1[text()='Enabled and Disabled elements']"));
                output(pageTitleEnabled, arg1);
                break;
            case "File Upload":
                WebElement pageTitleFileUpload = driver.findElement(By.tagName("h1"));
                output(pageTitleFileUpload, arg1);
                break;
            case "Key and Mouse Press":
                WebElement pageTitleKey = driver.findElement(By.xpath("//h1[text()='Keyboard and Mouse Input']"));
                output(pageTitleKey, arg1);
                break;
            case "Page Scroll":
                WebElement pageTitlePageScroll = driver.findElement(By.xpath("//h1[text()='Large page content']"));
                output(pageTitlePageScroll, arg1);
                break;
            case "Radio Button":
                WebElement pageTitleRadioButtons = driver.findElement(By.xpath("//h1[text()='Radio buttons']"));
                output(pageTitleRadioButtons, arg1);
                break;
            case "Thanks":
                WebElement pageTitleThanks = driver.findElement(By.xpath("//h1[text()='Thanks for submitting your form']"));
                output(pageTitleThanks, arg1);
                break;
            default:
                WebElement findElementsInComponentsDropdown = driver.findElement(By.xpath("//h1[text()='" + arg1 + "']"));
                output(findElementsInComponentsDropdown, arg1);
                break;
        }
    }

    public void headerComponentsCheck(String arg1, DataTable table) {
        java.util.List<String> elements = table.asList();
        String getComponentsName = headerDropdownComponents.getText();
        if (getComponentsName.equals(arg1)) {
            headerDropdownComponents.click();
        } else {
            checkResultFailed();
        }
        try {
            for (String a : elements) {
                WebElement findElementsInComponentsDropdown = driver.findElement(By.xpath("//a[@class='dropdown-item' and text()='" + a + "']"));
                findElementsInComponentsDropdown.getText();
            }
            System.out.println("PASSED");
        } catch (NoSuchElementException e) {
            checkResultFailed();
        }
    }
}