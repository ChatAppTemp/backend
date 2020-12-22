import vibe.d;
import viva.types.string;

/++
 + handles errors
 +/
void handleError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
	import std.conv : to;

	string errorDebug = "";
	debug errorDebug = error.debugMessage;

	res.contentType = "application/json";
	res.writeBody(str(
		`{"code": "`, error.code.to!string,
		`", "status": "`, error.message,
		`", "message": "`, error.debugMessage,
		`"}`
	));
}

public void main()
{
	import backend.rest : AccountsAPI;
	import backend.data : config;

	URLRouter router = new URLRouter();

	router.registerRestInterface(new AccountsAPI());

	HTTPServerSettings serverSettings = new HTTPServerSettings();
	serverSettings.bindAddresses = [config.hostIp];
	serverSettings.port = config.hostPort;
    serverSettings.sessionStore = new MemorySessionStore();
	serverSettings.errorPageHandler = toDelegate(&handleError);
	
	// connect to db

	listenHTTP(serverSettings, router);
	//listenTCP(config.socketPort, &handler, config.socketHost);

	runApplication();
}
