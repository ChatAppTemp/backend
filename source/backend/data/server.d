module backend.data.server;

import vibe.d;
import viva.mistflake;

/++
 + the server object
 +/
public struct Server
{
    /// the id of the server
    @name("_id")
    public Mistflake id;

    /// the display name of the server
    string serverName;
}