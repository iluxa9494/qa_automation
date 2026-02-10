package Pages;

import Config.Drive;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class ErrorPage {

    private final WebDriver driver;

    @FindBy(xpath = "//h1")
    public WebElement errorHeading;

    @FindBy(xpath = "//p[contains(.,'Not Found')]")
    public WebElement notFound;

    public ErrorPage() {
        this(Drive.getDriver());
    }

    public ErrorPage(WebDriver driver) {
        if (driver == null) {
            throw new IllegalStateException("WebDriver is null. Call Drive.chooseDriver() before creating page objects.");
        }
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }
}