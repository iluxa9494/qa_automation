package Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.util.Objects;
import java.util.Properties;

/**
 * Simple WebDriver lifecycle manager.
 *
 * IMPORTANT:
 * - Do NOT rely on TestNG annotations here (Cucumber/JUnit won't run them).
 * - Initialize the driver explicitly from Cucumber hooks or from your first step (DriveSteps).
 */
public class Drive {

    private static final Object LOCK = new Object();

    private static Properties prop;
    public static WebDriver driver;

    private static Properties loadProperties() throws IOException {
        if (prop != null) {
            return prop;
        }
        Properties p = new Properties();
        try (FileInputStream fs = new FileInputStream("src/main/resources/config.properties")) {
            p.load(fs);
        }
        prop = p;
        return prop;
    }

    public void chooseDriver() throws IOException {
        startIfNeeded();
    }

    public static WebDriver startIfNeeded() throws IOException {
        synchronized (LOCK) {
            if (driver != null) {
                return driver;
            }

            Properties p = loadProperties();

            String browser = p.getProperty("browser", "chrome").trim().toLowerCase();
            boolean headless = "1".equals(System.getProperty("formy.headless", "0"))
                    || "true".equalsIgnoreCase(System.getProperty("formy.headless", "false"));

            if ("chrome".equals(browser)) {
                ChromeOptions options = new ChromeOptions();
                if (headless) {
                    options.addArguments("--headless=new");
                    options.addArguments("--window-size=1920,1080");
                }
                options.addArguments("--no-sandbox");
                options.addArguments("--disable-dev-shm-usage");
                driver = new ChromeDriver(options);

            } else if ("firefox".equals(browser)) {
                FirefoxOptions options = new FirefoxOptions();
                if (headless) {
                    options.addArguments("-headless");
                }
                driver = new FirefoxDriver(options);

            } else {
                throw new IllegalArgumentException("Unsupported browser in config.properties: " + browser);
            }

            // Timeouts
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(60));
            driver.manage().timeouts().scriptTimeout(Duration.ofSeconds(30));

            // If not headless, maximize
            if (!headless) {
                try {
                    driver.manage().window().maximize();
                } catch (Exception ignored) {
                    // Some remote/headless envs may not support it
                }
            }

            // Optional auto-open URL
            String url = Objects.toString(p.getProperty("url"), "").trim();
            String overrideUrl = Objects.toString(System.getProperty("formy.url"), "").trim();
            if (!overrideUrl.isEmpty()) {
                url = overrideUrl;
            }
            if (!url.isEmpty()) {
                driver.get(url);
            }

            return driver;
        }
    }

    public void stopTest() {
        stop();
    }

    public static void stop() {
        synchronized (LOCK) {
            if (driver == null) {
                return;
            }
            try {
                driver.quit();
            } finally {
                driver = null;
            }
        }
    }
}

