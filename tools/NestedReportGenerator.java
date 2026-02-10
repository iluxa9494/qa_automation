package tools;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Generates reports/nested/data.json for compatibility dashboards.
 *
 * Output schema (values updated only; structure preserved if file already exists):
 * {
 *   "runId": "...",
 *   "generatedAt": "2026-01-27T02:46:00Z",
 *   "ui": { "passed": 10, "failed": 2, "broken": 1, "skipped": 0, "unknown": 0, "total": 13 },
 *   "db": { "passed": 8, "failed": 0, "broken": 0, "skipped": 1, "unknown": 0, "total": 9 }
 * }
 *
 * No external deps: tiny JSON parser/writer included.
 */
public class NestedReportGenerator {

    // Inputs (defaults match run layout)
    private static final Path ALLURE_UI_DIR = Paths.get(env("ALLURE_UI_RESULTS_DIR", "reports/allure-results/formy"));
    private static final Path ALLURE_DB_DIR = Paths.get(env("ALLURE_DB_RESULTS_DIR", "reports/allure-results/databaseUsage"));
    private static final String RUN_ID = env("RUN_ID", "");

    // Output
    private static final Path OUT = Paths.get(env("NESTED_OUT_JSON", "reports/nested/data.json"));

    private static final Charset UTF8 = StandardCharsets.UTF_8;

    public static void main(String[] args) throws Exception {
        StatusCounts ui = countAllureResults("UI", ALLURE_UI_DIR);
        StatusCounts db = countAllureResults("DB", ALLURE_DB_DIR);

        String runId = RUN_ID;
        if (runId == null || runId.trim().isEmpty()) runId = "unknown";
        String generatedAt = DateTimeFormatter.ISO_INSTANT.format(Instant.now());

        Map<String, Object> root = readExistingRootOrInit(runId, generatedAt);
        root.put("runId", runId);
        root.put("generatedAt", generatedAt);
        putCounts(root, "ui", ui);
        putCounts(root, "db", db);

        Files.createDirectories(OUT.getParent());
        writeUtf8(OUT, toJson(root));

        System.out.println("✅ Nested report generated: " + OUT.toAbsolutePath());
    }

    private static StatusCounts countAllureResults(String label, Path dir) {
        StatusCounts counts = new StatusCounts();
        if (!Files.exists(dir)) {
            System.out.println("⚠ Allure results dir missing for " + label + ": " + dir);
            return counts;
        }

        List<String> samples = new ArrayList<String>();
        int files = 0;

        try {
            try (java.util.stream.Stream<Path> stream = Files.walk(dir)) {
                Iterator<Path> it = stream.iterator();
                while (it.hasNext()) {
                    Path p = it.next();
                    String name = p.getFileName().toString();
                    if (!name.endsWith("-result.json")) continue;
                    files++;
                    try {
                        Object parsed = Json.parse(readUtf8(p));
                        if (!(parsed instanceof Map)) {
                            counts.unknown++;
                            continue;
                        }
                        @SuppressWarnings("unchecked")
                        Map<String, Object> m = (Map<String, Object>) parsed;
                        String status = str(m.get("status"), "").toLowerCase(Locale.ROOT);
                        if (status.length() == 0) status = "unknown";
                        if ("passed".equals(status)) counts.passed++;
                        else if ("failed".equals(status)) counts.failed++;
                        else if ("broken".equals(status)) counts.broken++;
                        else if ("skipped".equals(status)) counts.skipped++;
                        else counts.unknown++;

                        if (samples.size() < 2) {
                            samples.add(status);
                        }
                    } catch (Exception ex) {
                        counts.unknown++;
                        System.out.println("⚠ Failed to parse Allure result: " + p);
                    }
                }
            }
        } catch (IOException ex) {
            System.out.println("⚠ Failed to walk Allure results: " + dir);
        }

        System.out.println("▶ " + label + " *-result.json count: " + files);
        if (samples.isEmpty()) {
            System.out.println("▶ " + label + " sample statuses: <none>");
        } else {
            System.out.println("▶ " + label + " sample statuses: " + String.join(", ", samples));
        }

        return counts;
    }

    @SuppressWarnings("unchecked")
    private static Map<String, Object> readExistingRootOrInit(String runId, String generatedAt) {
        if (Files.exists(OUT)) {
            try {
                Object parsed = Json.parse(readUtf8(OUT));
                if (parsed instanceof Map) {
                    return (Map<String, Object>) parsed;
                }
            } catch (Exception ex) {
                System.out.println("⚠ Failed to parse existing nested JSON, regenerating: " + OUT);
            }
        }
        Map<String, Object> root = obj(
                "runId", runId,
                "generatedAt", generatedAt,
                "ui", obj(),
                "db", obj()
        );
        return root;
    }

    @SuppressWarnings("unchecked")
    private static void putCounts(Map<String, Object> root, String key, StatusCounts counts) {
        Object existing = root.get(key);
        Map<String, Object> target;
        if (existing instanceof Map) {
            target = (Map<String, Object>) existing;
        } else {
            target = obj();
            root.put(key, target);
        }
        target.put("passed", counts.passed);
        target.put("failed", counts.failed);
        target.put("broken", counts.broken);
        target.put("skipped", counts.skipped);
        target.put("unknown", counts.unknown);
        target.put("total", counts.total());
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
    // Tiny JSON parser (enough for Allure results)
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

    private static final class StatusCounts {
        int passed = 0;
        int failed = 0;
        int broken = 0;
        int skipped = 0;
        int unknown = 0;

        int total() {
            return passed + failed + broken + skipped + unknown;
        }
    }
}
