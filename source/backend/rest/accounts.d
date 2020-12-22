module backend.rest.accounts;

import vibe.d;

/++
 + api interface for the `/api/accounts` endpoint
 +/
@path("/api/accounts")
public interface IAccountsAPI
{
    /++
     + POST /accounts/signup
     +
     + creates a new user
     +/
    @path("/signup")
    @method(HTTPMethod.POST)
    @bodyParam("username", "username")
    @bodyParam("password", "password")
    Json signup(string username, string password) @safe;

    /++
     + POST /accounts/signin
     +
     + logs in an existing user
     +/
    @path("/signin")
    @method(HTTPMethod.POST)
    @bodyParam("username", "username")
    @bodyParam("password", "password")
    Json signin(string username, string password) @safe;
}

/++
 + api for the `/api/accounts` endpoint
 +/
public class AccountsAPI : IAccountsAPI
{
    /++
     + POST /accounts/signup
     +
     + creates a new user
     +/
    public Json signup(string username, string password) @safe
    {
        import viva.io : println;

        println(username, password);

        return serializeToJson(["token": "todo"]);
    }

    /++
     + POST /accounts/signin
     +
     + logs in an existing user
     +/
    public Json signin(string username, string password) @safe
    {
        import viva.io : println;

        println(username, password);

        return serializeToJson(["token": "todo"]);
    }
}