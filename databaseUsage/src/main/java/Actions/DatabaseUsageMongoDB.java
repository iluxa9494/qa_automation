package Actions;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoClients;
import com.mongodb.client.model.Filters;
import io.cucumber.datatable.DataTable;
import org.bson.Document;
import org.testng.Assert;

import java.util.concurrent.TimeUnit;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;

public class DatabaseUsageMongoDB {

    private MongoClient client;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    private static String configOrDefault(String key, String def) {
        String v = System.getProperty(key);
        if (v == null || v.trim().isEmpty()) {
            v = System.getenv(key);
        }
        return (v == null || v.trim().isEmpty()) ? def : v.trim();
    }

    public void connectToMongoDB(String dbName) {
        // CI: avoid localhost and fail fast on missing DB to prevent 30s hangs per scenario.
        String mongoUri = configOrDefault("MONGO_URI", "mongodb://mongodb:27017");
        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(new ConnectionString(mongoUri))
                .applyToClusterSettings(builder -> builder.serverSelectionTimeout(5, TimeUnit.SECONDS))
                .applyToSocketSettings(builder -> builder.connectTimeout(3, TimeUnit.SECONDS))
                .build();
        client = MongoClients.create(settings);
        database = client.getDatabase(dbName);
        System.out.println("Connected to MongoDB: " + mongoUri + " db=" + dbName);
    }

    public void createMongoDBCollection(String name) {
        database.createCollection(name);
        System.out.println("PASSED");
    }

    public void deleteMongoDBCollection() {
        collection = database.getCollection("city");
        collection.drop();
        System.out.println("PASSED");
    }

    public void createDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        int populationCheck = Integer.parseInt(elements.get(9));

        Document document = new Document()
                .append(elements.get(0), idCheck)
                .append(elements.get(2), elements.get(3))
                .append(elements.get(4), elements.get(5))
                .append(elements.get(6), elements.get(7))
                .append(elements.get(8), populationCheck);

        collection = database.getCollection("city");
        collection.insertOne(document);
        System.out.println("PASSED");
    }

    public void readDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));
        int populationCheck = Integer.parseInt(elements.get(9));

        collection = database.getCollection("city");

        Document doc = collection.find(Filters.eq(elements.get(0), idCheck)).first();

        check(doc != null
                && doc.get(elements.get(0)).equals(idCheck)
                && doc.get(elements.get(2)).equals(elements.get(3))
                && doc.get(elements.get(4)).equals(elements.get(5))
                && doc.get(elements.get(6)).equals(elements.get(7))
                && doc.get(elements.get(8)).equals(populationCheck)
        );
    }

    public void updateDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));

        collection = database.getCollection("city");
        collection.updateOne(
                eq(elements.get(0), idCheck),
                combine(set(elements.get(6), elements.get(7)))
        );
        System.out.println("PASSED");
    }

    public void deleteDocument(DataTable table) {
        java.util.List<String> elements = table.asList();
        int idCheck = Integer.parseInt(elements.get(1));

        collection = database.getCollection("city");
        collection.deleteOne(eq(elements.get(0), idCheck));
        System.out.println("PASSED");
    }

    public void closeMongo() {
        if (client != null) client.close();
    }

    public void check(boolean ok) {
        if (ok) System.out.println("PASSED");
        else Assert.fail("FAILED");
    }
}
