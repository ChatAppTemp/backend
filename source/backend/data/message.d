module backend.data.message;

import vibe.d;
import viva.mistflake;

/++
 +
 +/
public struct Message
{
    ///
    @name("_id")
    Mistflake id;

    ///
    string contents;

    ///
    Mistflake author;

    ///
    Mistflake channel;
}