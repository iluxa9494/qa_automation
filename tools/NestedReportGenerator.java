import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.time.Instant;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NestedReportGenerator {

    private static final String UI_JSON =
            System.getenv().getOrDefault("CUCUMBER_UI_JSON", "reports/formy/cucumber.json");
    private static final String DB_JSON =
            System.getenv().getOrDefault("CUCUMBER_DB_JSON", "reports/databaseUsage/cucumber.json");
    private static final String GATLING_GLOBAL_STATS =
            System.getenv().getOrDefault("GATLING_GLOBAL_STATS_JSON", "reports/gatling/latest/js/global_stats.json");
    private static final String OUT =
            System.getenv().getOrDefault("NESTED_OUT_JSON", "reports/nested/data.json");

    // --- Cucumber (tolerant parsing, scenario-level) ---
    private static final Pattern ELEMENT_WITH_STEPS_BLOCK =
            Pattern.compile("\\{(?:(?!\\{).)*?\"steps\"\\s*:\\s*\\[(?:(?!\\]).)*\\](?:(?!\\}).)*\\}",
                    Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    private static final Pattern STEP_STATUS =
            Pattern.compile("\"status\"\\s*:\\s*\"(passed|failed|skipped|pending|undefined|ambiguous)\"",
                    Pattern.CASE_INSENSITIVE);

    private enum ScenarioResult { PASSED, FAILED, SKIPPED }

    private record ScenarioStats(int passed, int failed, int skipped, int total) {}
    private record GatlingStats(int ok, int ko, int total) {}

    private static ScenarioStats parseCucumber(Path path) throws Exception {
        if (!Files.exists(path)) return new ScenarioStats(0, 0, 0, 0);
        String s = Files.readString(path, StandardCharsets.UTF_8);

        int passed = 0, failed = 0, skipped = 0, total = 0;

        Matcher m = ELEMENT_WITH_STEPS_BLOCK.matcher(s);
        while (m.find()) {
            total++;
            ScenarioResult r = classifyScenario(m.group());
            switch (r) {
                case FAILED -> failed++;
                case SKIPPED -> skipped++;
                case PASSED -> passed++;
            }
        }
        return new ScenarioStats(passed, failed, skipped, total);
    }

    private static ScenarioResult classifyScenario(String block) {
        Matcher st = STEP_STATUS.matcher(block);
        boolean hasAny = false;
        boolean hasFailed = false;
        boolean hasSkippedLike = false;

        while (st.find()) {
            hasAny = true;
            String status = st.group(1).toLowerCase();
            if ("failed".equals(status)) hasFailed = true;
            if ("skipped".equals(status) || "pending".equals(status) || "undefined".equals(status) || "ambiguous".equals(status)) {
                hasSkippedLike = true;
            }
        }
        if (!hasAny) return ScenarioResult.SKIPPED;
        if (hasFailed) return ScenarioResult.FAILED;
        if (hasSkippedLike) return ScenarioResult.SKIPPED;
        return ScenarioResult.PASSED;
    }

    // --- Gatling global_stats.json ---
    private static final Pattern GAT_OK =
            Pattern.compile("\"numberOfRequests\"\\s*:\\s*\\{[^\\}]*?\"ok\"\\s*:\\s*\"?(\\d+)\"?",
                    Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private static final Pattern GAT_KO =
            Pattern.compile("\"numberOfRequests\"\\s*:\\s*\\{[^\\}]*?\"ko\"\\s*:\\s*\"?(\\d+)\"?",
                    Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    private static GatlingStats parseGatling(Path path) throws Exception {
        if (!Files.exists(path)) return new GatlingStats(0, 0, 0);
        String s = Files.readString(path, StandardCharsets.UTF_8);
        int ok = extractInt(GAT_OK, s);
        int ko = extractInt(GAT_KO, s);
        return new GatlingStats(ok, ko, ok + ko);
    }

    private static int extractInt(Pattern p, String s) {
        Matcher m = p.matcher(s);
        if (m.find()) {
            try { return Integer.parseInt(m.group(1)); } catch (Exception ignored) {}
        }
        return 0;
    }

    private static String jsonEscape(String x) {
        return x.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static String buildOutput(ScenarioStats ui, ScenarioStats db, GatlingStats gat) {
        String ts = jsonEscape(Instant.now().toString());
        return "{\n" +
                "  \"id\": \"qa_automation\",\n" +
                "  \"name\": \"QA Automation Summary\",\n" +
                "  \"meta\": {\"generatedAt\": \"" + ts + "\"},\n" +
                "  \"items\": [\n" +
                "    {\"id\": \"ui_formy\", \"name\": \"UI tests (Formy)\", \"result\": {\"passed\": " + ui.passed + ", \"failed\": " + ui.failed + ", \"skipped\": " + ui.skipped + ", \"total\": " + ui.total + "}},\n" +
                "    {\"id\": \"db_tests\", \"name\": \"DB tests\", \"result\": {\"passed\": " + db.passed + ", \"failed\": " + db.failed + ", \"skipped\": " + db.skipped + ", \"total\": " + db.total + "}},\n" +
                "    {\"id\": \"gatling\", \"name\": \"Load tests (Gatling)\", \"result\": {\"ok\": " + gat.ok + ", \"ko\": " + gat.ko + ", \"total\": " + gat.total + "}}\n" +
                "  ]\n" +
                "}\n";
    }

    public static void main(String[] args) throws Exception {
        ScenarioStats ui = parseCucumber(Paths.get(UI_JSON));
        ScenarioStats db = parseCucumber(Paths.get(DB_JSON));
        GatlingStats gat = parseGatling(Paths.get(GATLING_GLOBAL_STATS));

        Path out = Paths.get(OUT);
        Files.createDirectories(out.getParent());
        Files.writeString(out, buildOutput(ui, db, gat), StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);

        System.out.println("✔ Nested report generated: " + out);
    }
}