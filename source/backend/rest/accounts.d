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
    @bodyParam("email", "email")
    Json signup(string username, string password, string email = "") @safe;

    /++
     + POST /accounts/signin
     +
     + logs in an existing user
     +/
    @path("/signin")
    @method(HTTPMethod.POST)
    @bodyParam("login", "login")
    @bodyParam("password", "password")
    Json signin(string login, string password) @safe;
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
    public Json signup(string username, string password, string email) @safe
    {
        import viva.io : println;
        import viva.mistflake : Mistflake;
        import viva.scrypt : genScryptPasswordHash;
        import backend.util.id : userIdGenerator;
        import backend.data : User, AuthUser, Status;
        import backend.db : insert, findOne;

        enforceHTTP(username.length > 0, HTTPStatus.badRequest, "username cannot be empty");
        enforceHTTP(password.length > 0, HTTPStatus.badRequest, "password cannot be empty");

        const userCheck = findOne!AuthUser(["$or": [["username": username], ["email": email]]]);
        if (!userCheck.isNull)
        {
            throw new HTTPStatusException(HTTPStatus.badRequest, "username or email is already in use");
        }

        Mistflake id = userIdGenerator.next();

        string hashedPassword = genScryptPasswordHash(password);

        AuthUser auth = AuthUser(id, username, email, hashedPassword);
        insert(auth);

        User user = User(id, username, "https://some.link/default.png", Status());
        insert(user);

        return serializeToJson(["userid": id.asString]);
    }

    /++
     + POST /accounts/signin
     +
     + logs in an existing user
     +/
    public Json signin(string login, string password) @safe
    {
        import viva.io : println;
        import viva.scrypt : checkScryptPasswordHash;
        import backend.db : findOne;
        import backend.data : User, AuthUser;

        const auth = findOne!AuthUser(["$or": [["username": login], ["email": login]]]);

        enforceHTTP(!auth.isNull, HTTPStatus.notFound, "user with that email/username not found");

        const user = findOne!User(["_id": auth.get().id]);

        enforceHTTP(!user.isNull, HTTPStatus.notFound, "user not found");

        enforceHTTP(!checkScryptPasswordHash(auth.get().password, password), HTTPStatus.badRequest, "wrong password");

        return serializeToJson(user.get());
    }
}