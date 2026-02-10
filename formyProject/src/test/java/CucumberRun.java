import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = {"Steps"},
        plugin = {
                "pretty",
                // ✅ HTML plugin должен писать в ФАЙЛ, а не в папку
                "html:target/cucumber.html",
                // ✅ JSON для Nested Data
                "json:target/cucumber/cucumber.json"
        },
        monochrome = true
)
public class CucumberRun {
}