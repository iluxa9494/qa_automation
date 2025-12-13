package tools;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

/**
 * Generates reports/nested/data.json for Jenkins "Nested Data Reporting" plugin.
 *
 * Output schema (plugin expects):
 * {
 *   "id": "...",
 *   "name": "...",
 *   "items": [
 *     {
 *       "id": "...",
 *       "name": "...",
 *       "result": { "passed": 10, "failed": 2, "total": 12 },
 *       "items": [ ... ]
 *     }
 *   ]
 * }
 *
 * No external deps: tiny JSON parser/writer included.
 */
public class NestedReportGenerator {

    // Inputs (defaults match your run_all_qa.sh outputs)
    private static final Path CUCUMBER_DB_JSON = Paths.get(env("CUCUMBER_DB_JSON", "reports/databaseUsage/cucumber.json"));
    private static final Path CUCUMBER_UI_JSON = Paths.get(env("CUCUMBER_UI_JSON", "reports/formy/cucumber.json"));
    private static final Path GATLING_GLOBAL_STATS_JSON = Paths.get(env("GATLING_GLOBAL_STATS_JSON", "reports/gatling/latest/js/global_stats.json"));

    // Output
    private static final Path OUT = Paths.get(env("NESTED_OUT_JSON", "reports/nested/data.json"));

    private static final Charset UTF8 = StandardCharsets.UTF_8;

    public static void main(String[] args) throws Exception {
        Map<String, Object> root = obj(
                "id", "qa-summary",
                "name", "QA Summary",
                "items", new ArrayList<Object>()
        );

        @SuppressWarnings("unchecked")
        List<Object> items = (List<Object>) root.get("items");

        // Cucumber projects
        addCucumberProject(items, "databaseUsage", "DB tests", CUCUMBER_DB_JSON);
        addCucumberProject(items, "formyProject", "UI tests", CUCUMBER_UI_JSON);

        // Gatling (optional)
        addGatling(items, "restfulBookerLoad", "Load tests (Gatling)", GATLING_GLOBAL_STATS_JSON);

        // Ensure output dir exists + write
        Files.createDirectories(OUT.getParent());
        writeUtf8(OUT, toJson(root));

        System.out.println("✅ Nested report generated: " + OUT.toAbsolutePath());
    }

    private static void addCucumberProject(List<Object> outItems, String projectId, String projectName, Path cucumberJsonPath) {
        if (!Files.exists(cucumberJsonPath)) {
            System.out.println("⚠ Cucumber JSON missing, skipping: " + cucumberJsonPath);
            return;
        }

        try {
            String json = readUtf8(cucumberJsonPath);
            Object parsed = Json.parse(json);

            if (!(parsed instanceof List)) {
                System.out.println("⚠ Unexpected cucumber.json root (expected array), skipping: " + cucumberJsonPath);
                return;
            }

            @SuppressWarnings("unchecked")
            List<Object> features = (List<Object>) parsed;

            List<Object> featureItems = new ArrayList<Object>();

            int passed = 0;
            int failed = 0;

            for (Object f : features) {
                if (!(f instanceof Map)) continue;
                @SuppressWarnings("unchecked")
                Map<String, Object> feature = (Map<String, Object>) f;

                String featureName = str(feature.get("name"), "Unnamed feature");
                String featureId = projectId + "::" + safeId(featureName);

                List<Object> scenarioItems = new ArrayList<Object>();
                int fPassed = 0;
                int fFailed = 0;

                Object elementsObj = feature.get("elements"); // cucumber v6 JSON uses "elements"
                if (elementsObj instanceof List) {
                    @SuppressWarnings("unchecked")
                    List<Object> elements = (List<Object>) elementsObj;

                    for (Object e : elements) {
                        if (!(e instanceof Map)) continue;
                        @SuppressWarnings("unchecked")
                        Map<String, Object> scenario = (Map<String, Object>) e;

                        String scenarioName = str(scenario.get("name"), "");
                        String scenarioId = featureId + "::" + safeId(scenarioName);

                        boolean isFailed = scenarioFailed(scenario);
                        if (isFailed) {
                            failed++;
                            fFailed++;
                        } else {
                            passed++;
                            fPassed++;
                        }

                        scenarioItems.add(obj(
                                "id", scenarioId,
                                "name", scenarioName.length() == 0 ? "(unnamed scenario)" : scenarioName,
                                "result", obj(
                                        "passed", isFailed ? 0 : 1,
                                        "failed", isFailed ? 1 : 0,
                                        "total", 1
                                )
                        ));
                    }
                }

                featureItems.add(obj(
                        "id", featureId,
                        "name", featureName,
                        "result", obj(
                                "passed", fPassed,
                                "failed", fFailed,
                                "total", fPassed + fFailed
                        ),
                        "items", scenarioItems
                ));
            }

            outItems.add(obj(
                    "id", projectId,
                    "name", projectName,
                    "result", obj(
                            "passed", passed,
                            "failed", failed,
                            "total", passed + failed
                    ),
                    "items", featureItems
            ));

        } catch (Exception ex) {
            System.out.println("❌ Failed to process cucumber JSON: " + cucumberJsonPath);
            ex.printStackTrace(System.out);
        }
    }

    private static boolean scenarioFailed(Map<String, Object> scenario) {
        Object stepsObj = scenario.get("steps");
        if (!(stepsObj instanceof List)) return false;

        @SuppressWarnings("unchecked")
        List<Object> steps = (List<Object>) stepsObj;

        for (Object s : steps) {
            if (!(s instanceof Map)) continue;
            @SuppressWarnings("unchecked")
            Map<String, Object> step = (Map<String, Object>) s;

            Object resultObj = step.get("result");
            if (!(resultObj instanceof Map)) continue;
            @SuppressWarnings("unchecked")
            Map<String, Object> result = (Map<String, Object>) resultObj;

            String status = str(result.get("status"), "");
            if ("failed".equalsIgnoreCase(status)) return true;
        }
        return false;
    }

    private static void addGatling(List<Object> outItems, String id, String name, Path globalStatsJsonPath) {
        if (!Files.exists(globalStatsJsonPath)) {
            System.out.println("⚠ Gatling global_stats.json missing, skipping: " + globalStatsJsonPath);
            return;
        }

        try {
            String json = readUtf8(globalStatsJsonPath);
            Object parsed = Json.parse(json);
            if (!(parsed instanceof Map)) return;

            @SuppressWarnings("unchecked")
            Map<String, Object> root = (Map<String, Object>) parsed;

            Object statsObj = root.get("stats");
            if (!(statsObj instanceof Map)) return;

            @SuppressWarnings("unchecked")
            Map<String, Object> stats = (Map<String, Object>) statsObj;

            int total = intPath(stats, "numberOfRequests", "total");
            int ok = intPath(stats, "numberOfRequests", "ok");
            int ko = intPath(stats, "numberOfRequests", "ko");

            outItems.add(obj(
                    "id", "gatling::" + id,
                    "name", name,
                    "result", obj(
                            "totalRequests", total,
                            "ok", ok,
                            "ko", ko
                    )
            ));

        } catch (Exception ex) {
            System.out.println("⚠ Failed to parse Gatling stats, skipping: " + globalStatsJsonPath);
            ex.printStackTrace(System.out);
        }
    }

    private static int intPath(Map<String, Object> obj, String key1, String key2) {
        Object level1 = obj.get(key1);
        if (!(level1 instanceof Map)) return 0;
        @SuppressWarnings("unchecked")
        Map<String, Object> m1 = (Map<String, Object>) level1;
        Object v = m1.get(key2);
        if (v instanceof Number) return ((Number) v).intValue();
        if (v instanceof String) {
            try { return Integer.parseInt((String) v); } catch (Exception ignored) {}
        }
        return 0;
    }

    // -----------------------------
    // Java 8 file helpers
    // -----------------------------

    private static String readUtf8(Path p) throws IOException {
        byte[] bytes = Files.readAllBytes(p);
        return new String(bytes, UTF8);
    }

    private static void writeUtf8(Path p, String content) throws IOException {
        byte[] bytes = content.getBytes(UTF8);
        Files.write(p, bytes, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    }

    // -----------------------------
    // Helpers: env / map builders
    // -----------------------------

    private static String env(String key, String def) {
        String v = System.getenv(key);
        if (v == null) return def;
        v = v.trim();
        return v.length() == 0 ? def : v;
    }

    private static Map<String, Object> obj(Object... kv) {
        Map<String, Object> m = new LinkedHashMap<String, Object>();
        for (int i = 0; i < kv.length; i += 2) {
            m.put(String.valueOf(kv[i]), kv[i + 1]);
        }
        return m;
    }

    private static String str(Object v, String def) {
        return v == null ? def : String.valueOf(v);
    }

    private static String safeId(String s) {
        if (s == null) return "null";
        String x = s.trim().toLowerCase(Locale.ROOT);
        x = x.replaceAll("[^a-z0-9\\-_.]+", "-");
        x = x.replaceAll("(^-+|-+$)", "");
        return x.length() == 0 ? "empty" : x;
    }

    // -----------------------------
    // JSON writer (minimal)
    // -----------------------------

    private static String toJson(Object v) {
        StringBuilder sb = new StringBuilder(16_384);
        writeJson(sb, v);
        return sb.toString();
    }

    @SuppressWarnings("unchecked")
    private static void writeJson(StringBuilder sb, Object v) {
        if (v == null) {
            sb.append("null");
        } else if (v instanceof String) {
            sb.append('"').append(escape((String) v)).append('"');
        } else if (v instanceof Number || v instanceof Boolean) {
            sb.append(v);
        } else if (v instanceof Map) {
            sb.append("{");
            boolean first = true;
            for (Map.Entry<String, Object> e : ((Map<String, Object>) v).entrySet()) {
                if (!first) sb.append(",");
                first = false;
                sb.append('"').append(escape(e.getKey())).append("\":");
                writeJson(sb, e.getValue());
            }
            sb.append("}");
        } else if (v instanceof List) {
            sb.append("[");
            boolean first = true;
            for (Object x : (List<Object>) v) {
                if (!first) sb.append(",");
                first = false;
                writeJson(sb, x);
            }
            sb.append("]");
        } else {
            sb.append('"').append(escape(String.valueOf(v))).append('"');
        }
    }

    private static String escape(String s) {
        StringBuilder out = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '\\': out.append("\\\\"); break;
                case '"':  out.append("\\\""); break;
                case '\b': out.append("\\b"); break;
                case '\f': out.append("\\f"); break;
                case '\n': out.append("\\n"); break;
                case '\r': out.append("\\r"); break;
                case '\t': out.append("\\t"); break;
                default:
                    if (c < 0x20) out.append(String.format("\\u%04x", (int) c));
                    else out.append(c);
            }
        }
        return out.toString();
    }

    // -----------------------------
    // Tiny JSON parser (enough for Cucumber + Gatling)
    // -----------------------------
    private static final class Json {
        static Object parse(String s) {
            return new Parser(s).parseValue();
        }

        private static final class Parser {
            private final String s;
            private int i = 0;

            Parser(String s) { this.s = s; }

            Object parseValue() {
                skipWs();
                if (i >= s.length()) throw err("Unexpected end");
                char c = s.charAt(i);
                if (c == '{') return parseObject();
                if (c == '[') return parseArray();
                if (c == '"') return parseString();
                if (c == 't' || c == 'f') return parseBoolean();
                if (c == 'n') return parseNull();
                if (c == '-' || (c >= '0' && c <= '9')) return parseNumber();
                throw err("Unexpected char: " + c);
            }

            Map<String, Object> parseObject() {
                expect('{');
                Map<String, Object> m = new LinkedHashMap<String, Object>();
                skipWs();
                if (peek('}')) { i++; return m; }

                while (true) {
                    skipWs();
                    String key = parseString();
                    skipWs();
                    expect(':');
                    Object val = parseValue();
                    m.put(key, val);
                    skipWs();
                    if (peek('}')) { i++; break; }
                    expect(',');
                }
                return m;
            }

            List<Object> parseArray() {
                expect('[');
                List<Object> a = new ArrayList<Object>();
                skipWs();
                if (peek(']')) { i++; return a; }

                while (true) {
                    Object val = parseValue();
                    a.add(val);
                    skipWs();
                    if (peek(']')) { i++; break; }
                    expect(',');
                }
                return a;
            }

            String parseString() {
                expect('"');
                StringBuilder out = new StringBuilder();
                while (i < s.length()) {
                    char c = s.charAt(i++);
                    if (c == '"') return out.toString();
                    if (c == '\\') {
                        if (i >= s.length()) throw err("Bad escape");
                        char e = s.charAt(i++);
                        switch (e) {
                            case '"': out.append('"'); break;
                            case '\\': out.append('\\'); break;
                            case '/': out.append('/'); break;
                            case 'b': out.append('\b'); break;
                            case 'f': out.append('\f'); break;
                            case 'n': out.append('\n'); break;
                            case 'r': out.append('\r'); break;
                            case 't': out.append('\t'); break;
                            case 'u':
                                if (i + 4 > s.length()) throw err("Bad unicode escape");
                                String hex = s.substring(i, i + 4);
                                i += 4;
                                out.append((char) Integer.parseInt(hex, 16));
                                break;
                            default:
                                throw err("Bad escape: \\" + e);
                        }
                    } else {
                        out.append(c);
                    }
                }
                throw err("Unterminated string");
            }

            Object parseNumber() {
                int start = i;
                if (peek('-')) i++;
                while (i < s.length() && Character.isDigit(s.charAt(i))) i++;
                boolean isFloat = false;
                if (peek('.')) {
                    isFloat = true;
                    i++;
                    while (i < s.length() && Character.isDigit(s.charAt(i))) i++;
                }
                if (peek('e') || peek('E')) {
                    isFloat = true;
                    i++;
                    if (peek('+') || peek('-')) i++;
                    while (i < s.length() && Character.isDigit(s.charAt(i))) i++;
                }
                String num = s.substring(start, i);
                try {
                    if (isFloat) return Double.parseDouble(num);
                    long v = Long.parseLong(num);
                    if (v >= Integer.MIN_VALUE && v <= Integer.MAX_VALUE) return (int) v;
                    return v;
                } catch (NumberFormatException e) {
                    throw err("Bad number: " + num);
                }
            }

            Boolean parseBoolean() {
                if (s.startsWith("true", i)) { i += 4; return Boolean.TRUE; }
                if (s.startsWith("false", i)) { i += 5; return Boolean.FALSE; }
                throw err("Bad boolean");
            }

            Object parseNull() {
                if (s.startsWith("null", i)) { i += 4; return null; }
                throw err("Bad null");
            }

            void skipWs() {
                while (i < s.length()) {
                    char c = s.charAt(i);
                    if (c == ' ' || c == '\n' || c == '\r' || c == '\t') i++;
                    else break;
                }
            }

            void expect(char c) {
                skipWs();
                if (i >= s.length() || s.charAt(i) != c) throw err("Expected '" + c + "'");
                i++;
            }

            boolean peek(char c) {
                return i < s.length() && s.charAt(i) == c;
            }

            RuntimeException err(String msg) {
                return new RuntimeException(msg + " at pos " + i);
            }
        }
    }
}