package Steps;

import Actions.DatabaseUsageMySQL;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import java.sql.SQLException;

public class DatabaseUsageStepsMySQL {
    DatabaseUsageMySQL databaseUsage = new DatabaseUsageMySQL();

    @Then("Connect to MySQL city database")
    public void connection() throws SQLException, ClassNotFoundException {
        databaseUsage.connectToMySQL();
    }

    @Then("Close db connection")
    public void closeDBConnection() throws SQLException, ClassNotFoundException {
        databaseUsage.closeConnection();
    }

    @Then("Create position in the db with data:")
    public void createCompareDBData(DataTable table) throws SQLException {
        databaseUsage.createCompareDBDataCheck(table);
    }

    @Then("Check position in the db has data:")
    public void getCompareDBData(DataTable table) throws SQLException {
        databaseUsage.getCompareDBDataCheck(table);
    }

    @Then("Change position in the db data:")
    public void updateCompareDBData(DataTable table) throws SQLException {
        databaseUsage.updateCompareDBDataCheck(table);
    }

    @Then("Delete position in the db data:")
    public void deleteCompareDBData(DataTable table) throws SQLException {
        databaseUsage.deleteCompareDBDataCheck(table);
    }
}