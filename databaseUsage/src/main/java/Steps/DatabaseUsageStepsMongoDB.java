package Steps;

import Actions.DatabaseUsageMongoDB;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;

public class DatabaseUsageStepsMongoDB {
    DatabaseUsageMongoDB databaseUsageMongoDB = new DatabaseUsageMongoDB();

    @Then("Connect to MongoDB {string} database")
    public void connection(String arg1) {
        databaseUsageMongoDB.connectToMongoDB(arg1);
    }

    @Then("Create {string} collection in mongoDB")
    public void createCollection(String arg1) {
        databaseUsageMongoDB.createMongoDBCollection(arg1);
    }

    @Then("Delete collection in mongoDB")
    public void deleteCollection() {
        databaseUsageMongoDB.deleteMongoDBCollection();
    }

    @Then("Create document in the collection with data:")
    public void createDocumentMongoDB(DataTable table){
        databaseUsageMongoDB.createDocument(table);
    }

    @Then("Read data from document and compare it has:")
    public void readDocumentMongoDB(DataTable table){
        databaseUsageMongoDB.readDocument(table);
    }

    @Then("Update District on Vladivostok value from document and compare it has:")
    public void updateDocumentMongoDB(DataTable table){
        databaseUsageMongoDB.updateDocument(table);
    }

    @Then("Delete document in the MongoDB data:")
    public void deleteDocumentMongoDB(DataTable table){
        databaseUsageMongoDB.deleteDocument(table);
    }
}