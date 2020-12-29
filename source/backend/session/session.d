module backend.session.session;

import backend.data;

///
public struct Session
{
    ///
    ServiceUser user;

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
public void startSession(string token, User user)
{
    sessions[token] = Session(ServiceUser(user.id, user.username, user.pfpLink));
}

/++
 +
 +/
public Session getSession(string token)
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
public void endSession(string token)
{

}