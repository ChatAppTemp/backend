module backend.rest.me;

import vibe.d;

/++
 + api interface for the `/api/me` endpoint
 +/
@path("/api/me")
public interface IMeAPI
{
    /++
     + PUT /friends
     +
     + sends a friend request to the given user
     +/
    @path("/friends")
    @method(HTTPMethod.PUT)
    @headerParam("token", "Authorization")
    @bodyParam("username", "username")
    Json addFriend(string token, string username) @safe;
}

/++
 + api for the `/api/me` endpoint
 +/
public class MeAPI : IMeAPI
{
    /++
     + PUT /friends
     +
     + sends a friend request to the given user
     +/
    public Json addFriend(string token, string username) @safe
    {
        import viva.io : println;

        println(token, username);

        return serializeToJson(["token": "todo"]);
    }
}