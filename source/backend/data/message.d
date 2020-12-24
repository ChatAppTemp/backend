module backend.data.message;

import vibe.d;
import viva.mistflake;

/++
 + the message object
 +/
public struct Message
{
    /// the id of the message
    @name("_id")
    public Mistflake id;

    /// the contents of the message
    public string contents;

    /// the id of the sender
    public Mistflake author;

    /// the id of the channel the message was sent in
    public Mistflake channel;
}