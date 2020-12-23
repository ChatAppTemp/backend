module backend.util.id;

import backend.data;
import viva.mistflake;

/// user id mistflake generator
@property public MistflakeGenerator userIdGenerator() @safe { return _userIdGenerator; }
private MistflakeGenerator _userIdGenerator;

/// server id mistflake generator
@property public MistflakeGenerator serverIdGenerator() @safe { return _serverIdGenerator; }
private MistflakeGenerator _serverIdGenerator;

/// channel id mistflake generator
@property public MistflakeGenerator channelIdGenerator() @safe { return _channelIdGenerator; }
private MistflakeGenerator _channelIdGenerator;

/// message id mistflake generator
@property public MistflakeGenerator messageIdGenerator() @safe { return _messageIdGenerator; }
private MistflakeGenerator _messageIdGenerator;

/++
 + setups all the id generators by getting the collection counts from the db
 +/
public void setupIdGenerators()
{
    version (unittest)
    {
        return;
    }
    else
    {
        import backend.db : getCollectionCount;

        _userIdGenerator = MistflakeGenerator(getCollectionCount!User() + 1, 4023);
        _serverIdGenerator = MistflakeGenerator(getCollectionCount!Server() + 1, 4024);
        _channelIdGenerator = MistflakeGenerator(getCollectionCount!Channel() + 1, 4025);
        _messageIdGenerator = MistflakeGenerator(getCollectionCount!Message() + 1, 4026);
    }
}