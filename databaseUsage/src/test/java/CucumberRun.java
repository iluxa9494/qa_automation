import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = {"Steps"},
        plugin = {
                "pretty",
                // HTML репорт должен быть ФАЙЛОМ
                "html:target/cucumber.html",
                // JSON для агрегации/дженкинса и nested report
                "json:target/cucumber/cucumber.json"
        },
        monochrome = true
)
public class CucumberRun {
}