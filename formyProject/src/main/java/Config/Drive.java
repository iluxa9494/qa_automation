package Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;

public class Drive {

    // Оставляем поле, чтобы не ломать существующие Steps, где используется Drive.driver напрямую
    public static WebDriver driver;

    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause = null;

    public static synchronized WebDriver getDriver() {
        return driver;
    }

    public static synchronized boolean isRunAborted() {
        return runAborted;
    }

    public static synchronized Throwable getAbortCause() {
        return abortCause;
    }

    public static synchronized void markRunAborted(Throwable cause) {
        runAborted = true;
        abortCause = cause;
    }

    /**
     * Инициализация драйвера. Вызывай в шагах перед использованием страниц.
     * Если драйвер уже поднят — повторно не создаём.
     */
    public static synchronized void chooseDriver() {
        if (runAborted) return;
        if (driver != null) return;

        try {
            ChromeOptions options = new ChromeOptions();

            // Часто нужно для Docker/CI. Локально тоже не мешает.
            options.addArguments("--no-sandbox");
            options.addArguments("--disable-dev-shm-usage");
            options.addArguments("--disable-gpu");
            options.addArguments("--window-size=1920,1080");

            // Если в CI нужен headless — раскомментируй:
            // options.addArguments("--headless=new");

            driver = new ChromeDriver(options);
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        } catch (Throwable t) {
            markRunAborted(t);
            safeQuit();
            throw t;
        }
    }

    public static synchronized void safeQuit() {
        if (driver == null) return;
        try {
            driver.quit();
        } catch (Throwable ignored) {
        } finally {
            driver = null;
        }
    }

    // оставлено для обратной совместимости, если где-то вызывается
    public static void stopTest() {
        safeQuit();
    }
}