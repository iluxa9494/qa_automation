package Steps;

import Config.Drive;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import org.openqa.selenium.*;
import org.testng.SkipException;

public class Hooks extends Drive {

    // Если инфраструктура/драйвер упал на одном сценарии — остальные помечаем как skipped,
    // чтобы не тратить время/ресурсы.
    private static volatile boolean runAborted = false;
    private static volatile Throwable abortCause = null;

    @Before(order = 0)
    public void abortIfRunAborted(Scenario scenario) {
        if (runAborted) {
            String msg = "Run aborted earlier (driver/environment failure). Scenario skipped: " + scenario.getName();
            if (abortCause != null) {
                msg += " | cause: " + abortCause.getClass().getSimpleName() + ": " + abortCause.getMessage();
            }
            throw new SkipException(msg);
        }
    }

    @After(order = 0)
    public void teardownAndMaybeAbort(Scenario scenario) {
        WebDriver d = Drive.driver;

        // Если сценарий упал — пытаемся:
        // 1) при включенных скриншотах приложить скрин
        // 2) определить инфраструктурный фейл и, если да — остановить дальнейшие сценарии
        if (scenario.isFailed() && d != null) {
            maybeAttachScreenshot(scenario, d);

            try {
                Throwable infra = detectInfraFailure(d);
                if (infra != null) {
                    markRunAborted(infra);
                }
            } catch (Throwable ignored) {
                // не должны падать на хуках
            }
        }

        // Всегда стараемся корректно закрыть драйвер (даже если Close browser был в шагах)
        safeQuit();
    }

    private void maybeAttachScreenshot(Scenario scenario, WebDriver d) {
        if (!screenshotsEnabled()) return;

        try {
            if (d instanceof TakesScreenshot) {
                byte[] png = ((TakesScreenshot) d).getScreenshotAs(OutputType.BYTES);
                scenario.attach(png, "image/png", "screenshot");
            }
        } catch (Throwable ignored) {
        }
    }

    private boolean screenshotsEnabled() {
        // Приоритет: -Dformy.screenshots=0 -> отключить
        String sys = System.getProperty("formy.screenshots");
        if (sys != null) return !"0".equals(sys.trim());

        // Fallback: ENV FORMY_SCREENSHOTS=0
        String env = System.getenv("FORMY_SCREENSHOTS");
        if (env != null) return !"0".equals(env.trim());

        return true; // default ON
    }

    private static synchronized void markRunAborted(Throwable t) {
        if (!runAborted) {
            runAborted = true;
            abortCause = t;
        }
    }

    private Throwable detectInfraFailure(WebDriver d) {
        if (d == null) return null;

        try {
            // лёгкая "проверка живости" сессии
            d.getTitle();
            return null;
        } catch (NoSuchSessionException e) {
            return e;
        } catch (SessionNotCreatedException e) {
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

    private void safeQuit() {
        try {
            if (Drive.driver != null) {
                Drive.driver.quit();
            }
        } catch (Throwable ignored) {
        } finally {
            Drive.driver = null;
        }
    }
}