import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = "Steps",
        plugin = {
                "pretty",
                "json:target/cucumber/cucumber.json",
                "html:target/cucumber.html"
        },
        monochrome = true
)
public class CucumberRun {
}