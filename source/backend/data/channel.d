module backend.data.channel;

import vibe.d;
import viva.mistflake;

/++
 + the user object
 +/
public struct Channel
{
    /// the id of the channel
    @name("_id")
    public Mistflake id;

    /// the id of the server the channel is in
    public Mistflake serverId;

    /// the display name of the channel
    public string channelName;
}