module backend.session.session;

import backend.data;

///
public struct Session
{
    ///
    User user;

    /++
     +
     +/
    public bool loggedIn() const @safe
    {
        return this != Session.init;
    }
}

private Session[string] sessions;

/++
 +
 +/
public void startSession(string token, User user) @safe
{
    sessions[token] = Session(user);
}

/++
 +
 +/
public bool sessionExists(string token) @safe
{
    if (token in sessions)
    {
        return true;
    }

    return false;
}

/++
 +
 +/
public Session getSession(string token) @safe
{
    if (token in sessions)
    {
        return sessions[token];
    }

    return Session.init;
}

/++
 +
 +/
public void endSession(string token) @safe
{

}