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
        import backend.util : userIdGenerator, generateToken;
        import backend.data : User, AuthUser, Status, StatusType;
        import backend.db : insert, findOne;
        import backend.session : startSession;

        enforceHTTP(username.length > 0, HTTPStatus.badRequest, "username cannot be empty");
        enforceHTTP(password.length > 0, HTTPStatus.badRequest, "password cannot be empty");

        const userCheck = findOne!AuthUser(["$or": [["username": username], ["email": email]]]);
        if (!userCheck.isNull)
        {
            throw new HTTPStatusException(HTTPStatus.badRequest, "username or email is already in use");
        }

        Mistflake id = userIdGenerator.next();
        string token = generateToken();

        string hashedPassword = genScryptPasswordHash(password);

        AuthUser auth = AuthUser(id, token, username, email, hashedPassword);
        insert(auth);

        // TODO: technically we shouldnt really store the users status in the db, but then again the custom messages.
        // - but like it makes no sense to store in the db if the user status is online, because if it is then the user object will be in memory anyway
        // - so like should we store it as online here? or offline or like. it doesnt matter in the end, because when you login you become online unless you change status
        // - although discord does remember your last used status type, so perhaps thats what we could store? and then just have another user object (`ServiceUser`) that
        // - can tell you if the user is offline (if the user is in the sessions map and not invisible). idk yet about this hmm
        User user = User(id, username, "https://some.link/default.png", Status(StatusType.ONLINE));
        insert(user);

        startSession(token, user);

        return serializeToJson(["token": serializeToJson(token), "user": serializeToJson(user)]);
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
        import backend.data : User, AuthUser, Status, StatusType;
        import backend.session : startSession, sessionExists;

        const auth = findOne!AuthUser(["$or": [["username": login], ["email": login]]]);

        enforceHTTP(!auth.isNull, HTTPStatus.notFound, "user with that email/username not found");

        const user = findOne!User(["_id": auth.get().id.asString]);

        enforceHTTP(!user.isNull, HTTPStatus.notFound, "user not found");

        enforceHTTP(checkScryptPasswordHash(auth.get().password, password), HTTPStatus.badRequest, "wrong password");

        User userObj = user.get();
        userObj.status = Status(StatusType.ONLINE);

        println(sessionExists(auth.get().token));

        startSession(auth.get().token, userObj);

        println(sessionExists(auth.get().token));

        return serializeToJson(["token": serializeToJson(auth.get().token), "user": serializeToJson(userObj)]);
    }
}