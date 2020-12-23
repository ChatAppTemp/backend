module backend.data.user;

import vibe.d;
import viva.mistflake;

/++
 + the user object
 +/
struct User
{
    /// the users id
    @name("_id")
    Mistflake id;

    /// the users username
    string username;

    /// the users discriminator
    ulong discrim;

    /// the link to the users profile picture
    string pfpLink;

    /// the users status
    Status status;
}

/++
 + user status object
 +/
struct Status
{
    /// the type of the status
    StatusType type;

    /// the custom message of the status
    string message;
}

/++
 + the status type for user statuses
 +/
enum StatusType
{
    OFFLINE = 1,
    INVISIBLE,
    INACTIVE,
    ONLINE,
    DND
}

/++
 + member object. represents users in servers
 +/
struct Member
{
    /// the members id
    @name("_id")
    Mistflake id;

    /// the id of the server
    Mistflake server;

    /// bool representing whether or not the member is the server owner
    bool isOwner;

    /// bool representing whether or not the member is muted
    bool isMuted;

    /// the users nickname
    string nickname;
}