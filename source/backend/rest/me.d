module backend.rest.me;

import vibe.d;

/++
 + api interface for the `/api/me` endpoint
 +/
@path("/api/me")
public interface IMeAPI
{
    // TODO: Should friend related stuff be handled like `/friends/:username` instead of having username in body?

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

    /++
     + DELETE /friends
     +
     + removes a friend from the users friend list
     +/
    @path("/friends")
    @method(HTTPMethod.DELETE)
    @headerParam("token", "Authorization")
    @bodyParam("username", "username")
    Json removeFriend(string token, string username) @safe;
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

    /++
     + DELETE /friends
     +
     + removes a friend from the users friend list
     +/
    public Json removeFriend(string token, string username) @safe
    {
        import viva.io : println;

        println(token, username);

        return serializeToJson(["token": "todo"]);
    }
}