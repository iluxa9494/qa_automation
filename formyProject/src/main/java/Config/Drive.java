package Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.SessionNotCreatedException;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.util.Properties;

public class Drive {

    protected static WebDriver driver;

    // --- "Abort run" contract for Cucumber Hooks ---
    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause = null;

    public static boolean isRunAborted() {
        return runAborted;
    }

    public static Throwable getAbortCause() {
        return abortCause;
    }

    public static void markRunAborted(Throwable cause) {
        runAborted = true;
        abortCause = cause;
    }

    public static WebDriver getDriver() {
        return driver;
    }

    public static void safeQuit() {
        try {
            if (driver != null) driver.quit();
        } catch (Throwable ignored) {
        } finally {
            driver = null;
        }
    }

    // --- Existing API (kept for backward compatibility with DriveSteps) ---
    @BeforeSuite
    public void chooseDriver() throws IOException {
        if (isRunAborted()) return;

        Properties prop = new Properties();
        try (FileInputStream fis = new FileInputStream("src/main/resources/config.properties")) {
            prop.load(fis);
        }

        String driverType = prop.getProperty("driverType", "chrome");
        String url = prop.getProperty("url");

        try {
            switch (driverType) {
                case "chrome": {
                    String chromeDriverPath =
                            System.getenv().getOrDefault("CHROMEDRIVER_PATH", "/usr/bin/chromedriver");
                    System.setProperty("webdriver.chrome.driver", chromeDriverPath);

                    ChromeOptions options = new ChromeOptions();
                    options.addArguments("--headless=new");
                    options.addArguments("--no-sandbox");
                    options.addArguments("--disable-dev-shm-usage");
                    options.addArguments("--disable-gpu");
                    options.addArguments("--window-size=1920,1080");
                    options.addArguments("--remote-allow-origins=*");

                    String chromeBin = System.getenv("CHROME_BIN");
                    if (chromeBin != null && !chromeBin.isBlank()) {
                        options.setBinary(chromeBin);
                    }

                    driver = new ChromeDriver(options);
                    break;
                }
                default:
                    throw new RuntimeException("Unsupported driverType: " + driverType);
            }

            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            if (url != null && !url.isBlank()) {
                driver.get(url);
            }

        } catch (SessionNotCreatedException | WebDriverException e) {
            // mark whole run aborted (infra failure)
            markRunAborted(e);
            safeQuit();
            throw e;
        }
    }

    @AfterSuite(alwaysRun = true)
    public void stopTest() {
        safeQuit();
    }
}