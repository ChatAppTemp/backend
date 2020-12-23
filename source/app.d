import vibe.d;
import viva.types.string;

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
    /*
    res.writeBody(str(
        `{"code": "`, error.code.to!string,
        `", "status": "`, error.message,
        `", "message": "`, error.debugMessage,
        `"}`
    ));
    */
}

public void main()
{
    import backend.rest : AccountsAPI, ServersAPI, UsersAPI, MeAPI;
    import backend.data : config;
    import backend.db : connectDB;

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

    listenHTTP(serverSettings, router);
    //listenTCP(config.socketPort, &handler, config.socketHost);

    runApplication();
}
