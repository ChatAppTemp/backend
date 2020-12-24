module backend.db.db;

import vibe.d;
import backend.data;
import std.typecons;

/// a list of all of the collection names in the db
public const string[] collections = ["auth", "users", "members", "servers", "channels", "messages"];

private MongoDatabase mongo;

/++
 + opens the connection to the database
 +/
public void connectDB()
{
    connectMongo(config.mongoConnection, "chatapptemp");
    mongo[getCollectionName!User].createIndex(["username": "text"]);
}

private void connectMongo(string host, string db)
{
    mongo = connectMongoDB(host).getDatabase(db);
}

private string getCollectionName(T)() @safe
{
    static if (is(T == AuthUser))
    {
        return "auth";
    }
    else static if (is(T == User))
    {
        return "users";
    }
    else static if (is(T == Member))
    {
        return "members";
    }
    else static if (is(T == Server))
    {
        return "servers";
    }
    else static if (is(T == Channel))
    {
        return "channels";
    }
    else static if (is(T == Message))
    {
        return "messages";
    }
    else
    {
        static assert(false, "no collection for type " ~ T.stringof);
    }
}

/++
 + inserts an item into the db
 + Params:
 +      item = the item to be inserted. must be one of the collection types
 +/
public void insert(T)(T item)
{
    MongoCollection collection = mongo[getCollectionName!T()];
    collection.insert(serializeToJson(item));
}

/++
 + updates an item in the db
 + Params:
 +      selector = the selector
 +      update = the update
 +/
public void update(T, S, U)(S selector, U update)
{
    MongoCollection collection = mongo[getCollectionName!T()];
    collection.update(selector, update);
}

/++
 + get the amount of documents in a collection
 + Returns: the amount of documents in the collection
 +/
public ulong getCollectionCount(T)()
{
    MongoCollection collection = mongo[getCollectionName!T()];
    return collection.find().count();
}

/++
 + get all the elements in a collection
 + Returns: all the elements in the collection
 +/
public MongoCursor!T getAll(T)() @safe
{
    MongoCollection collection = mongo[getCollectionName!T()];
    return collection.find!T();
}

/++
 + finds all documents in the specified collection by a query
 + Params:
 +      query = the query used to find the document
 + Returns: the documents
 +/
public MongoCursor!T find(T, R)(R query) @safe
{
    MongoCollection collection = mongo[getCollectionName!T()];
    return collection.find!R(query);
}

/++
 + finds one document in the specified collection by a query
 + Params:
 +      query = the query used to find the document
 + Returns: the document
 +/
public Nullable!T findOne(T, R)(R query) @safe
{
    MongoCollection collection = mongo[getCollectionName!T()];
    return collection.findOne!T(query);
}

/++
 + finds a document by an id in the specified collection
 + Params:
 +      id = the id used to find the document
 + Returns: the document found
 +/
public Nullable!T findOneById(T, R)(R id) @safe
{
    return findOne!T(["_id": id]);
}

/++
 + finds a document by an id in the specified collection, wrapped in a try-catch
 + Params:
 +      id = the id used to find the document
 + Returns: the document found
 +/
public Nullable!T tryFindOneById(T, R)(R id) @safe
{
    try
    {
        return findOneById!T(id);
    }
    catch (Exception e)
    {
        return Nullable!T.init;
    }
}

/++
 + removes one or more documents from the collection by a query
 + Params:
 +      query = the query used to find the document(s)
 +/
public void remove(T, R)(R query) @safe
{
    MongoCollection collection = mongo[getCollectionName!T()];
    collection.remove(query);
}

/++
 + removes a document from the collection by an id
 + Params:
 +      id = the id used to find the document
 +/
public void removeOneById(T, R)(R id) @safe
{
    remove!T(["_id": id]);
}

@("db collection names are correct")
unittest
{
    assert(getCollectionName!User() == "users");
    assert(getCollectionName!Member() == "members");
    assert(getCollectionName!Server() == "servers");
    assert(getCollectionName!Channel() == "channels");
    assert(getCollectionName!Message() == "messages");
}