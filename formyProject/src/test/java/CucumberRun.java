import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        // Файлы лежат в formyProject/src/test/features/*.feature
        features = "src/test/features",
        glue = {"Steps"},
        plugin = {
                "pretty",
                // HTML репорт для Jenkins HTML Publisher
                "html:target/cucumber-html-report",
                // JSON для агрегации в Nested Data Report
                "json:target/cucumber/cucumber.json"
        },
        monochrome = true
)
public class CucumberRun {
}