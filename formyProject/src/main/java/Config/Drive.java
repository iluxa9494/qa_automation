package Config;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;

import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import org.openqa.selenium.edge.EdgeDriver;

import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;

import org.openqa.selenium.safari.SafariDriver;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.util.Properties;

public class Drive {
    public static WebDriver driver;

    @BeforeSuite
    public void chooseDriver() throws IOException {

        FileInputStream fis = new FileInputStream("src/main/resources/config.properties");
        Properties prop = new Properties();
        prop.load(fis);

        String driverType = prop.getProperty("driverType");
        String url = prop.getProperty("url");

        switch (driverType) {

            case "chrome": {
                WebDriverManager.chromedriver().setup();

                ChromeOptions options = new ChromeOptions();
                options.addArguments("--headless=new"); // ✅ Selenium 4 / Chrome new headless
                options.addArguments("--no-sandbox");
                options.addArguments("--disable-dev-shm-usage");
                options.addArguments("--disable-gpu");
                options.addArguments("--window-size=1920,1080");

                driver = new ChromeDriver(options);

                driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
                driver.get(url);
                break;
            }

            case "firefox": {
                WebDriverManager.firefoxdriver().setup();

                FirefoxOptions options = new FirefoxOptions();
                options.addArguments("-headless");

                driver = new FirefoxDriver(options);

                driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
                driver.get(url);
                break;
            }

            case "edge": {
                WebDriverManager.edgedriver().setup();

                driver = new EdgeDriver();

                driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
                driver.get(url);
                break;
            }

            case "safari": {
                driver = new SafariDriver();
                driver.manage().window().maximize();
                driver.get(url);
                break;
            }


            default:
                System.out.println("Selected incorrect driverType");
                break;
        }
    }

    @AfterSuite
    public void StopTest() {
        if (driver != null) {
            driver.quit();
        }
    }
}