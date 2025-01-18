package Actions;

import io.cucumber.datatable.DataTable;
import org.testng.Assert;

import java.sql.*;

public class DatabaseUsageMySQL {
    public static Connection con;

    public void connectToMySQL() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        System.out.println("Driver loaded");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/world", "root", "11111111");
        System.out.println("Connected to MySQL DB");
    }

    public void closeConnection() throws SQLException {
        con.close();
        System.out.println("Connection has closed");
    }

    public void createCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> elements = table.asList();
        Statement statement = con.createStatement();
        int id = Integer.parseInt(elements.get(1));
        int population = Integer.parseInt(elements.get(9));
        statement.executeUpdate("insert into city values (" + id + ",'" + elements.get(3) + "'," +
                " '" + elements.get(5) + "', '" + elements.get(7) + "', " + population + ")");
        System.out.println("PASSED");
    }

    public void getCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        int populationCheck = Integer.parseInt(elements.get(9));
        Statement statement = con.createStatement();
        ResultSet resultSet = statement.executeQuery("select * from city where " + elements.get(0) + " = " + idCheck + "");
        while (resultSet.next()) {
            int id = resultSet.getInt("ID");
            String name = resultSet.getString("Name");
            String countryCode = resultSet.getString("CountryCode");
            String district = resultSet.getString("District");
            int population = resultSet.getInt("Population");
            check(id == idCheck && name.equals(elements.get(3)) && countryCode.equals(elements.get(5)) &&
                    district.equals(elements.get(7)) && population == populationCheck);
        }
    }

    public void updateCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        Statement statement = con.createStatement();
        statement.executeUpdate("update city set " + elements.get(6) + " = '" + elements.get(7) + "' where " +
                elements.get(0) + " = " + idCheck + "");
        System.out.println("PASSED");
    }

    public void deleteCompareDBDataCheck(DataTable table) throws SQLException {
        java.util.List<String> elements = table.asList();
        int id = Integer.parseInt(elements.get(1));
        Statement statement = con.createStatement();
        statement.execute("delete from city where " + elements.get(0) + " = " + id + "");
        System.out.println("PASSED");
    }

    public void check(boolean arg1) {
        if (arg1) {
            System.out.println("PASSED");
        } else {
            Assert.fail("FAILED");
        }
    }
}