package Config;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.opera.OperaDriver;
import org.openqa.selenium.safari.SafariDriver;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

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
            case "chrome":
                WebDriverManager.chromedriver().setup();
                driver = new ChromeDriver();
                driver.manage().window().maximize();
                driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
                driver.get(url);
                break;
            case "firefox":
                WebDriverManager.firefoxdriver().setup();
                driver = new FirefoxDriver();
                driver.manage().window().maximize();
                driver.get(url);
                break;
            case "safari":
                driver = new SafariDriver();
                driver.manage().window().maximize();
                driver.get(url);
                break;
            case "opera":
                WebDriverManager.operadriver().setup();
                driver = new OperaDriver();
                driver.manage().window().maximize();
                driver.get(url);
                break;
            case "edge":
                WebDriverManager.edgedriver().setup();
                driver = new EdgeDriver();
                driver.manage().window().maximize();
                driver.get(url);
                break;
            default:
                System.out.println("Selected incorrect driverType");
                break;
        }
    }

    @AfterSuite
    public void StopTest() {
        driver.quit();
    }
}