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
                "json:/reports/databaseUsage/cucumber.json",
                "html:/reports/databaseUsage/cucumber.html",

                // ✅ Jenkins trends (JUnit XML)
                "junit:/reports/databaseUsage/TEST-databaseUsage.xml",

                // ✅ Allure (Cucumber 6 adapter)
                "io.qameta.allure.cucumber6jvm.AllureCucumber6Jvm"
        },
        monochrome = true
)
public class CucumberRun {
}