import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = {"Steps"},
        plugin = {
                "pretty",
                "html:target/cucumber-html-report",
                "json:target/cucumber/cucumber.json"
        },
        monochrome = true
)
public class CucumberRun {
}