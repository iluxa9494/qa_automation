package Actions;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import io.cucumber.datatable.DataTable;
import org.bson.Document;
import org.testng.Assert;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;

public class DatabaseUsageMongoDB {

    private MongoClient client;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    private static String envOrDefault(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.trim().isEmpty()) ? def : v.trim();
    }

    public void connectToMongoDB(String dbName) {
        // ✅ контейнер: mongodb://mongo:27017 (из env MONGO_URI)
        // ✅ локально:   mongodb://localhost:27017
        String mongoUri = envOrDefault("MONGO_URI", "mongodb://localhost:27017");
        client = MongoClients.create(mongoUri);
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

        // ✅ раньше было жестко "ID=1" — теперь читаем по id из feature
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