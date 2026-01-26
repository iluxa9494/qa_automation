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

import java.io.IOException;

public class Hooks extends Drive {

    /**
     * Единственный жизненный цикл:
     *  - @Before: гарантируем, что драйвер поднят и стартовая страница открыта (chooseDriver делает driver.get(url))
     *  - @After : снимаем скрин при падении (если возможно) и всегда закрываем драйвер
     *
     * Плюс: если инфраструктура (chrome/chromedriver) упала — помечаем ран как aborted
     *       и следующие сценарии сразу SKIP, чтобы не было "лавины" фейлов.
     */

    @Before(order = 0)
    public void beforeScenario(Scenario scenario) {
        // если ран уже "aborted" — просто пропускаем всё дальше
        if (Drive.isRunAborted()) {
            throw new SkipException(skipMsg("Run aborted earlier", scenario, Drive.getAbortCause()));
        }

        // гарантируем наличие драйвера
        if (Drive.getDriver() != null) return;

        try {
            chooseDriver(); // поднимает WebDriver и открывает URL из config.properties
        } catch (IOException e) {
            Drive.markRunAborted(e);
            throw new SkipException(skipMsg("Driver init failed (IOException)", scenario, e));
        } catch (Throwable t) {
            Drive.markRunAborted(t);
            throw new SkipException(skipMsg("Driver init failed", scenario, t));
        }
    }

    @After(order = 0)
    public void afterScenario(Scenario scenario) {
        // если сценарий упал — пытаемся понять "инфра" это или тест
        if (scenario.isFailed()) {
            try {
                Throwable infra = detectInfraFailure();
                if (infra != null) {
                    Drive.markRunAborted(infra);
                }
            } catch (Throwable ignored) {
            }

            // try attach screenshot (если есть сессия)
            tryAttachScreenshot(scenario);
        }

        // всегда гасим драйвер (один сценарий = один браузер)
        Drive.safeQuit();
    }

    private void tryAttachScreenshot(Scenario scenario) {
        WebDriver d = Drive.getDriver();
        if (d == null) return;

        try {
            if (d instanceof org.openqa.selenium.TakesScreenshot) {
                byte[] png = ((org.openqa.selenium.TakesScreenshot) d).getScreenshotAs(org.openqa.selenium.OutputType.BYTES);
                scenario.attach(png, "image/png", "failure-screenshot");
            }
        } catch (Throwable ignored) {
            // если сессия умерла — не мешаем teardown
        }
    }

    private Throwable detectInfraFailure() {
        WebDriver d = Drive.getDriver();
        if (d == null) return null;

        try {
            // "пинг" сессии
            d.getTitle();
            return null;
        } catch (NoSuchSessionException | SessionNotCreatedException e) {
            return e;
        } catch (WebDriverException e) {
            String m = String.valueOf(e.getMessage()).toLowerCase();
            // типовые инфраструктурные ошибки chrome/chromedriver в docker/ci
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

    private String skipMsg(String prefix, Scenario scenario, Throwable cause) {
        String msg = prefix + ". Scenario skipped: " + scenario.getName();
        if (cause != null) {
            msg += " | cause: " + cause.getClass().getSimpleName() + ": " + cause.getMessage();
        }
        return msg;
    }
}