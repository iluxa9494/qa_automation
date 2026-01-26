// formyProject/src/main/java/Config/Drive.java
package Config;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.util.Properties;

public class Drive {

    protected static WebDriver driver;

    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause = null;

    public static WebDriver getDriver() {
        return driver;
    }

    public static boolean isRunAborted() {
        return runAborted;
    }

    public static Throwable getAbortCause() {
        return abortCause;
    }

    public static void markRunAborted(Throwable cause) {
        runAborted = true;
        if (abortCause == null) {
            abortCause = cause;
        }
    }

    public static void resetAbort() {
        runAborted = false;
        abortCause = null;
    }

    public void chooseDriver() throws IOException {
        ensureDriverStarted();
    }

    public void stopTest() {
        safeQuit();
    }

    public synchronized void ensureDriverStarted() throws IOException {
        if (runAborted) {
            throw new RuntimeException("Run is aborted; driver will not be started.", abortCause);
        }
        if (driver != null) {
            return;
        }

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

        } catch (Throwable t) {
            markRunAborted(t);
            safeQuit();
            throw t;
        }
    }

    public static synchronized void safeQuit() {
        if (driver != null) {
            try {
                driver.quit();
            } catch (Throwable ignored) {
            } finally {
                driver = null;
            }
        }
    }
}