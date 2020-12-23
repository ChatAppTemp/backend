module backend.rest.users;

import vibe.d;

/++
 + api interface for the `/api/users` endpoint
 +/
@path("/api/users")
public interface IUsersAPI
{
    /++
     + GET /:user/servers
     +
     + gets the servers the specified user is in
     +/
    @path("/:user/servers")
    @method(HTTPMethod.GET)
    @headerParam("token", "Authorization")
    Json getUserServers(string token, string _user) @safe;
}

/++
 + api for the `/api/users` endpoint
 +/
public class UsersAPI : IUsersAPI
{
    /++
     + GET /:user/servers
     +
     + gets the servers the specified user is in
     +/
    public Json getUserServers(string token, string _user) @safe
    {
        import viva.io : println;
        import viva.mistflake : Mistflake, MistflakeParser;

        println(token, _user);

        Mistflake serverId = MistflakeParser().parse(_user);
        println(serverId.time.toUTC());

        return serializeToJson(["token": "todo"]);
    }
}