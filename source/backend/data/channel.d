module backend.data.channel;

import vibe.d;
import viva.mistflake;

/++
 +
 +/
public struct Channel
{
    ///
    @name("_id")
    Mistflake id;

    ///
    Mistflake serverId;

    ///
    string channelName;
}