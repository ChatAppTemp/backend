import vibe.d;
import viva.types.string;

// TODO: we need a way for frontend to tell backend that a user is "quitting" so we can terminate the session
// TODO: maybe also start working on socket system so we can lay it all out better?

private void handleError(HTTPServerRequest _, HTTPServerResponse res, HTTPServerErrorInfo error)
{
    import std.conv : to;

    string errorDebug = "";
    debug errorDebug = error.debugMessage;

    struct Error
    {
        string code;
        string status;
        string message;
    }

    res.contentType = "application/json";
    res.writeBody(serializeToJsonString(["error": Error(
        error.code.to!string,
        error.message,
        error.debugMessage
    )]));
}

public void main()
{
    import backend.rest : AccountsAPI, ServersAPI, UsersAPI, MeAPI;
    import backend.data : config;
    import backend.db : connectDB;
    import backend.util : setupIdGenerators;

    URLRouter router = new URLRouter();

    router.registerRestInterface(new AccountsAPI());
    router.registerRestInterface(new ServersAPI());
    router.registerRestInterface(new UsersAPI());
    router.registerRestInterface(new MeAPI());

    HTTPServerSettings serverSettings = new HTTPServerSettings();
    serverSettings.bindAddresses = [config.hostIp];
    serverSettings.port = config.hostPort;
    serverSettings.sessionStore = new MemorySessionStore();
    serverSettings.errorPageHandler = toDelegate(&handleError);

    connectDB();
    setupIdGenerators();

    listenHTTP(serverSettings, router);
    //listenTCP(config.socketPort, &handler, config.socketHost);

    runApplication();
}
