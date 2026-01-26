package Steps;

import Config.Drive;
import Pages.DropdownPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
public class DropdownSteps extends Drive {
    private DropdownPage dropdownPage;

    private DropdownPage dropdownPage() {
        if (dropdownPage == null) {
            dropdownPage = new DropdownPage(driver);
        }
        return dropdownPage;
    }
    @Then("Check Dropdown button has title {string}")
    public void titleDisplayed(String arg1) {
        dropdownPage().isTitleDisplayed(arg1);
    }

    @Then("Check Dropdown button not selected, enabled")
    public void buttonSelectedOrEnabled() {
        dropdownPage().isButtonSelectedOrEnabled();
    }

    @Then("Check elements have displayed:")
    public void dropdownListDisplayed(DataTable table) {
        dropdownPage().isDropdownListDisplayed(table);
    }

    @Then("Check dropdown list has closed")
    public void listClosed() {
        dropdownPage().isListClosed();
    }

    @Then("Click on {string} in dropdown list and check {string} page has opened")
    public void pageOpenedFromDropdownList(String arg1, String arg2) {
        dropdownPage().isPageOpenedFromDropdownList(arg1, arg2);
    }

    @Then("Click on dropdown button")
    public void clickDropdownButton() {
        dropdownPage().isClickDropdownButton();
    }
}
