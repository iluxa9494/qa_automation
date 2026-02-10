package Steps;

import Config.Drive;
import io.cucumber.java.en.Then;

import java.io.IOException;

public class DriveSteps extends Drive {

    @Then("Open browser and go to Formy site")
    public void chooseTheDriver() throws IOException {
        chooseDriver(); // метод из Drive
    }

    @Then("Close browser")
    public void closeBrowser() {
        stopTest(); // единое имя (см. Drive.java ниже)
    }
}
