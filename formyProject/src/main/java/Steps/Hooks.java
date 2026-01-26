package Steps;

import Config.Drive;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.remote.UnreachableBrowserException;
import org.testng.SkipException;

public class Hooks extends Drive {

    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause = null;

    @Before(order = 0)
    public void beforeScenario(Scenario scenario) {
        if (runAborted) {
            throw new SkipException(buildSkipMessage(scenario, abortCause));
        }

        try {
            // Единый жизненный цикл: стартуем драйвер и открываем URL здесь
            Drive.start();
        } catch (Throwable t) {
            // Если упали на инициализации — дальше нет смысла гонять остальные сценарии
            runAborted = true;
            abortCause = t;
            throw new SkipException(buildSkipMessage(scenario, t), t);
        }
    }

    @After(order = 0)
    public void afterScenario(Scenario scenario) {
        try {
            if (scenario.isFailed()) {
                Throwable infra = detectInfraFailure();
                if (infra != null) {
                    runAborted = true;
                    abortCause = infra;
                }
            }
        } catch (Throwable ignored) {
            // Не валим teardown из-за диагностик
        } finally {
            // Всегда аккуратно гасим драйвер после сценария
            Drive.stop();
        }
    }

    private static String buildSkipMessage(Scenario scenario, Throwable cause) {
        String msg = "Run aborted earlier (driver/environment failure). Scenario skipped: "
                + scenario.getName();
        if (cause != null) {
            msg += " | cause: " + cause.getClass().getSimpleName()
                    + (cause.getMessage() != null ? ": " + cause.getMessage() : "");
        }
        return msg;
    }

    /**
     * Грубая, но практичная диагностика “инфра-фаила”.
     * Если браузер/сессия умерли — дальнейшие сценарии бессмысленны.
     */
    private Throwable detectInfraFailure() {
        try {
            if (Drive.driver == null) return new IllegalStateException("WebDriver is null");
            Drive.driver.getTitle(); // лёгкий ping в живую сессию
            return null;
        } catch (UnreachableBrowserException e) {
            return e;
        } catch (WebDriverException e) {
            String m = String.valueOf(e.getMessage()).toLowerCase();
            if (m.contains("disconnected")
                    || m.contains("chrome not reachable")
                    || m.contains("session deleted")
                    || m.contains("invalid session")
                    || m.contains("tab crashed")
                    || m.contains("devtoolsactiveport")
                    || m.contains("cannot find chrome binary")) {
                return e;
            }
            return null;
        } catch (Throwable t) {
            return t;
        }
    }
}