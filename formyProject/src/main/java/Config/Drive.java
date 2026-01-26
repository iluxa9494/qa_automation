package Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;

public class Drive {

    private static WebDriver driver;

    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause;

    public static synchronized WebDriver getDriver() {
        if (driver == null) {
            driver = createChromeDriver();
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        }
        return driver;
    }

    private static WebDriver createChromeDriver() {
        ChromeOptions options = new ChromeOptions();

        // единственный режим: стабильно для CI/Docker
        options.addArguments("--headless=new");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--disable-gpu");
        options.addArguments("--window-size=1920,1080");
        options.addArguments("--remote-allow-origins=*");

        // если нужно явно указать бинарь Chromium в контейнере
        String chromeBin = System.getenv("CHROME_BIN");
        if (chromeBin != null && !chromeBin.isBlank()) {
            options.setBinary(chromeBin);
        }

        // chromedriver должен быть в PATH (в твоём CI он ставится пакетом chromium-driver)
        return new ChromeDriver(options);
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

    // ---- abort run mechanics (под Hooks) ----

    public static boolean isRunAborted() {
        return runAborted;
    }

    public static Throwable getAbortCause() {
        return abortCause;
    }

    public static synchronized void markRunAborted(Throwable cause) {
        runAborted = true;
        abortCause = cause;
    }
}