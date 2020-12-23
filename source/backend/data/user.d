module backend.data.user;

import vibe.d;
import viva.mistflake;

/++
 + the user object
 +/
public struct User
{
    /// the users id
    @name("_id")
    public Mistflake id;

    /// the users username
    public string username;

    /// the users discriminator
    public ulong discrim;

    /// the link to the users profile picture
    public string pfpLink;

    /// the users status
    public Status status;
}

/++
 + the user object, but in minimal form. used for sessions
 +/
public struct ServiceUser
{
    /// the users id
    public Mistflake id;

    /// the users username
    public string username;

    /// the link to the users profile picture
    public string pfpLink;
}

/++
 + user status object
 +/
public struct Status
{
    /// the type of the status
    public StatusType type;

    /// the custom message of the status
    public string message;
}

/++
 + the status type for user statuses
 +/
public enum StatusType
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
public struct Member
{
    /// the members id
    @name("_id")
    public Mistflake id;

    /// the id of the server
    public Mistflake server;

    /// bool representing whether or not the member is the server owner
    public bool isOwner;

    /// bool representing whether or not the member is muted
    public bool isMuted;

    /// the users nickname
    public string nickname;
}