import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/features",
        glue = "Steps",
        plugin = {
                "pretty",

                // ✅ отчёты
                "json:/reports/formy/cucumber.json",
                "html:/reports/formy/cucumber.html",

                // ✅ Jenkins trends (JUnit XML)
                "junit:/reports/formy/TEST-formy.xml",

                // ✅ Allure (Cucumber 7 adapter)
                "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"
        },
        monochrome = true
)
public class CucumberRun {
}