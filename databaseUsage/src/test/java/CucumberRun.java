import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.Rule;
import org.junit.rules.Timeout;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = "Steps",
        plugin = {
                "pretty",
                "junit:/reports/databaseUsage/TEST-databaseUsage.xml",
                "io.qameta.allure.cucumber6jvm.AllureCucumber6Jvm"
        },
        monochrome = true
)
public class CucumberRun {
    @Rule
    public Timeout globalTimeout = Timeout.seconds(Integer.getInteger("qa.junit.timeout.seconds", 1200));
}
