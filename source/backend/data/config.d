module backend.data.config;

// Stolen from https://github.com/CodeMyst/pastemyst/blob/main/source/pastemyst/data/config.d
// thanks code :)

import dyaml;

/++
 + struct holding the whole config file
 +/
public struct Config
{
    /++
     + ip on where to host the server
     +/
    public string hostIp;

    /++
     + on which port to host the server
     +/
    public ushort hostPort;

    /++
     + ip on where to host the socket server
     +/
    public string socketHost;

    /++
     + on which port to host the socket server
     +/
    public ushort socketPort;

    /++
     + mongodb connection string
     +/
    public string mongoConnection;
}

/// app config
@property public Config config() @safe { return _config; }
private Config _config;

static this()
{
    version (unittest)
    {
        return;
    }
    else
    {
        import std.file : exists;
        import std.exception : enforce;
        import std.format : format;

        // default configuration file
        string configName = "config.yaml";

        if(!exists(configName))
        {
            // if doesn't exists, fallback to .yml
            configName = "config.yml";
            enforce(exists(configName), format!"missing %s"(configName));
        }

        Node cfg;

        try
        {
            cfg = Loader.fromFile(configName).load();
        }
        catch (YAMLException e)
        {
        	e.msg = format!"%s: invalid or empty"(configName);
        	throw e;
        }

        enforce(cfg.isValid(), format!"%s: invalid"(configName));

        // hostIp
        enforce(cfg.containsKey("host_ip"), format!"%s: missing host_ip"(configName));
        _config.hostIp = cfg["host_ip"].as!string();

        // hostPort
        enforce(cfg.containsKey("host_port"), format!"%s: missing host_port"(configName));
        _config.hostPort = cfg["host_port"].as!ushort();

        // socketHost
        enforce(cfg.containsKey("socket_host"), format!"%s: missing socket_host"(configName));
        _config.socketHost = cfg["socket_host"].as!string();

        // socketPort
        enforce(cfg.containsKey("socket_port"), format!"%s: missing socket_port"(configName));
        _config.socketPort = cfg["socket_port"].as!ushort();

        // mongoConnection
        enforce(cfg.containsKey("mongo_connection"), format!"%s: missing mongo_connection"(configName));
        _config.mongoConnection = cfg["mongo_connection"].as!string();
    }
}