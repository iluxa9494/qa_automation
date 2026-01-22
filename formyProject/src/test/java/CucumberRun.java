import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = "Steps",
        plugin = {
                "pretty",
                "json:/reports/formy/cucumber.json",
                "html:/reports/formy/cucumber.html"
        },
        monochrome = true
)
public class CucumberRun {
}