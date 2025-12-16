package Steps;

import Config.Drive;
import com.galenframework.api.Galen;
import com.galenframework.api.GalenPageDump;
import com.galenframework.reports.GalenTestInfo;
import com.galenframework.reports.HtmlReportBuilder;
import com.galenframework.reports.model.LayoutReport;
import io.cucumber.java.en.Then;
import org.junit.Assert;

import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public class DriveSteps extends Drive {

    @Then("Open browser and go to Formy site")
    public void chooseTheDriver() throws IOException {
        // driver создаётся внутри chooseDriver()
        chooseDriver();
    }

    @Then("Close browser")
    public void closeBrowser() {
        // Важно: имя метода такое же, как в Drive
        StopTest();
    }

    @Then("Check layout {string} file")
    public void layoutCheck(String fileName) throws IOException {
        LayoutReport layoutReport = Galen.checkLayout(
                driver,
                "src/main/specs/" + fileName + ".gspec",
                Arrays.asList("desktop")
        );

        List<GalenTestInfo> tests = new LinkedList<>();
        GalenTestInfo test = GalenTestInfo.fromString("test layout");
        test.getReport().layout(layoutReport, "check test layout");
        tests.add(test);

        HtmlReportBuilder htmlReportBuilder = new HtmlReportBuilder();
        htmlReportBuilder.build(tests, "target");

        if (layoutReport.errors() > 0) {
            Assert.fail("Layout test failed");
        }
    }

    @Then("Make page dump of {string} page")
    public void makePageDump(String arg1) throws IOException {
        GalenPageDump dump = new GalenPageDump(driver.getCurrentUrl());
        dump.dumpPage(
                driver,
                "src/main/specs/" + arg1 + "PageVisual.gspec",
                "src/main/specs/pagedump" + arg1
        );
    }
}