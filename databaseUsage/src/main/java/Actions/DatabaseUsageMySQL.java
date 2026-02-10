package Actions;

import io.cucumber.datatable.DataTable;
import org.testng.Assert;

import java.sql.*;

public class DatabaseUsageMySQL {

    public static Connection con;

    private static String configOrDefault(String key, String def) {
        String v = System.getProperty(key);
        if (v == null || v.trim().isEmpty()) {
            v = System.getenv(key);
        }
        return (v == null || v.trim().isEmpty()) ? def : v.trim();
    }

    private static String ensureParam(String url, String key, String value) {
        String marker = key + "=";
        if (url.contains(marker)) {
            return url;
        }
        return url + (url.contains("?") ? "&" : "?") + key + "=" + value;
    }

    public void connectToMySQL() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        System.out.println("Driver loaded");

        // CI: avoid localhost and fail fast on missing DB to prevent long hangs.
        String url  = configOrDefault("MYSQL_URL", "jdbc:mysql://mysql:3306/test");
        String user = configOrDefault("MYSQL_USER", "test");
        String pass = configOrDefault("MYSQL_PASS", null);
        if (pass == null || pass.trim().isEmpty()) {
            pass = configOrDefault("MYSQL_PASSWORD", "test");
        }

        if (!url.contains("?")) {
            url = url + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }
        // Fail-fast timeouts for CI stability.
        url = ensureParam(url, "connectTimeout", "3000");
        url = ensureParam(url, "socketTimeout", "5000");

        con = DriverManager.getConnection(url, user, pass);
        System.out.println("Connected to MySQL DB: " + url);
    }

    public void closeConnection() throws SQLException {
        if (con != null) con.close();
        System.out.println("Connection has closed");
    }

    public void createCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> e = table.asList();
        int id = Integer.parseInt(e.get(1));
        int population = Integer.parseInt(e.get(9));

        String sql = "INSERT INTO city (ID, Name, CountryCode, District, Population) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, e.get(3));
            ps.setString(3, e.get(5));
            ps.setString(4, e.get(7));
            ps.setInt(5, population);
            ps.executeUpdate();
        }
        System.out.println("PASSED");
    }

    public void getCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> e = table.asList();
        int idCheck = Integer.parseInt(e.get(1));
        int populationCheck = Integer.parseInt(e.get(9));

        String idFieldName = e.get(0); // обычно "ID"

        String sql = "SELECT ID, Name, CountryCode, District, Population FROM city WHERE " + idFieldName + " = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCheck);

            try (ResultSet rs = ps.executeQuery()) {
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    int id = rs.getInt("ID");
                    String name = rs.getString("Name");
                    String countryCode = rs.getString("CountryCode");
                    String district = rs.getString("District");
                    int population = rs.getInt("Population");

                    check(id == idCheck
                            && name.equals(e.get(3))
                            && countryCode.equals(e.get(5))
                            && district.equals(e.get(7))
                            && population == populationCheck
                    );
                }
                check(found);
            }
        }
    }

    public void updateCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> e = table.asList();
        int idCheck = Integer.parseInt(e.get(1));

        String idFieldName = e.get(0);    // ID
        String updateField = e.get(6);    // например District
        String updateValue = e.get(7);    // новое значение

        String sql = "UPDATE city SET " + updateField + " = ? WHERE " + idFieldName + " = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, updateValue);
            ps.setInt(2, idCheck);
            ps.executeUpdate();
        }
        System.out.println("PASSED");
    }

    public void deleteCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> e = table.asList();
        int id = Integer.parseInt(e.get(1));
        String idFieldName = e.get(0);

        String sql = "DELETE FROM city WHERE " + idFieldName + " = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
        System.out.println("PASSED");
    }

    public void check(boolean ok) {
        if (ok) System.out.println("PASSED");
        else Assert.fail("FAILED");
    }
}
