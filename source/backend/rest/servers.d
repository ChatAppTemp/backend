module backend.rest.servers;

import vibe.d;

/++
 + api interface for the `/api/servers` endpoint
 +/
@path("/api/servers")
public interface IServersAPI
{
    /++
     + GET /:server
     +
     + gets info about a server
     +/
    @path("/:server")
    @method(HTTPMethod.GET)
    @headerParam("token", "Authorization")
    Json getServerInfo(string token, string _server) @safe;

    /++
     + PUT /
     +
     + creates a new server
     +/
    @path("/")
    @method(HTTPMethod.PUT)
    @headerParam("token", "Authorization")
    @bodyParam("name", "name")
    // TODO: add more fields
    Json createServer(string token, string name) @safe;
}

/++
 + api for the `/api/servers` endpoint
 +/
public class ServersAPI : IServersAPI
{
    /++
     + GET /:server
     +
     + gets info about a server
     +/
    public Json getServerInfo(string token, string _server) @safe
    {
        import viva.io : println;
        import viva.mistflake : Mistflake, MistflakeParser;

        println(token, _server);

        Mistflake serverId = MistflakeParser().parse(_server);
        println(serverId.time.toUTC());

        return serializeToJson(["token": "todo"]);
    }

    /++
     + PUT /
     +
     + creates a new server
     +/
    public Json createServer(string token, string name) @safe
    {
        import viva.io : println;

        println(token, name);

        return serializeToJson(["token": "todo"]);
    }
}