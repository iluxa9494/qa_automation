package Steps;

import io.cucumber.java.en.Given;

public class CiSanitySteps {
    @Given("a passing sanity check")
    public void aPassingSanityCheck() {
        // no-op: CI smoke to validate runner + Allure wiring
    }
}
