package Actions;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import io.cucumber.datatable.DataTable;
import org.bson.Document;
import org.testng.Assert;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Updates.*;

public class DatabaseUsageMongoDB {
    MongoClient client;
    MongoDatabase database;
    MongoCollection<Document> collection;

    public void connectToMongoDB(String arg1) {
        client = MongoClients.create("mongodb://localhost:27017");
        database = client.getDatabase(arg1);
    }

    public void createMongoDBCollection(String arg1) {
        database.createCollection(arg1);
    }

    public void deleteMongoDBCollection() {
        collection = database.getCollection("city");
        collection.drop();
    }

    public void createDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        int populationCheck = Integer.parseInt(elements.get(9));
        Document document = new Document()
                .append(elements.get(0), idCheck)
                .append("" + elements.get(2) + "", "" + elements.get(3) + "")
                .append("" + elements.get(4) + "", "" + elements.get(5) + "")
                .append("" + elements.get(6) + "", "" + elements.get(7) + "")
                .append("" + elements.get(8) + "", populationCheck);
        collection = database.getCollection("city");
        collection.insertOne(document);
        System.out.println("PASSED");
    }

    public void readDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        int populationCheck = Integer.parseInt(elements.get(9));
        collection = database.getCollection("city");
        Document doc = collection.find(Filters.eq("ID", 1)).first();
        check(doc.get("ID").equals(idCheck) && doc.get("Name").equals(elements.get(3)) &&
                doc.get("CountryCode").equals(elements.get(5)) && doc.get("District").equals(elements.get(7)) &&
                doc.get("Population").equals(populationCheck));
    }

    public void updateDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        collection = database.getCollection("city");
        collection.updateOne(
                eq("" + elements.get(0) + "", idCheck),
                combine(set("" + elements.get(6) + "", "" + elements.get(7) + "")));
        System.out.println("PASSED");
    }

    public void deleteDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        collection = database.getCollection("city");
        collection.deleteOne(eq("" + elements.get(0) + "", idCheck));
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