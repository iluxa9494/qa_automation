package Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.IOException;
import java.time.Duration;

public class Drive {

    // было private -> делаем protected, чтобы наследники (Steps.* extends Drive) могли использовать `driver`
    protected static WebDriver driver;

    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause;

    public static synchronized WebDriver getDriver() {
        if (driver == null) {
            driver = createChromeDriver();
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        }
        return driver;
    }

    // 👇 peek без создания (чтобы Hooks мог “пинговать” и не поднимать сессию заново)
    public static synchronized WebDriver peekDriver() {
        return driver;
    }

    private static WebDriver createChromeDriver() {
        ChromeOptions options = new ChromeOptions();

        // стабильный режим для CI/Docker
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

        return new ChromeDriver(options);
    }

    // ---- Backward compatible lifecycle API ----

    public static synchronized void start() {
        // раньше это делали хуки/степы — оставляем контракт
        getDriver();
    }

    public static synchronized void stop() {
        safeQuit();
    }

    // Старые имена, чтобы не править DriveSteps
    public static void chooseDriver() throws IOException {
        start();
        String baseUrl = System.getenv("FORMY_BASE_URL");
        if (baseUrl == null || baseUrl.isBlank()) {
            baseUrl = "https://formy-project.herokuapp.com/";
        }
        getDriver().get(baseUrl);
    }

    public static void stopTest() {
        stop();
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