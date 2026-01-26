package Steps;

import Config.Drive;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import org.openqa.selenium.NoSuchSessionException;
import org.openqa.selenium.SessionNotCreatedException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverException;
import org.testng.SkipException;

public class Hooks extends Drive {

    @Before(order = 0)
    public void abortIfRunAborted(Scenario scenario) {
        if (Drive.isRunAborted()) {
            String msg = "Run aborted earlier (driver/environment failure). Scenario skipped: "
                    + scenario.getName();
            Throwable cause = Drive.getAbortCause();
            if (cause != null) {
                msg += " | cause: " + cause.getClass().getSimpleName() + ": " + cause.getMessage();
            }
            throw new SkipException(msg);
        }
    }

    @After(order = 0)
    public void teardownAndMaybeAbort(Scenario scenario) {
        if (scenario.isFailed()) {
            try {
                Throwable infra = detectInfraFailure();
                if (infra != null) {
                    Drive.markRunAborted(infra);
                }
            } catch (Throwable ignored) {
            }
        }

        Drive.safeQuit();
    }

    private Throwable detectInfraFailure() {
        WebDriver d = Drive.getDriver();
        if (d == null) return null;

        try {
            d.getTitle();
            return null;
        } catch (NoSuchSessionException | SessionNotCreatedException e) {
            return e;
        } catch (WebDriverException e) {
            String m = String.valueOf(e.getMessage()).toLowerCase();
            if (m.contains("tab crashed")
                    || m.contains("disconnected")
                    || m.contains("chrome not reachable")
                    || m.contains("session deleted")
                    || m.contains("invalid session")
                    || m.contains("cannot find chrome binary")
                    || m.contains("devtoolsactiveport")
                    || m.contains("unknown error")) {
                return e;
            }
            return null;
        } catch (Throwable t) {
            return t;
        }
    }
}