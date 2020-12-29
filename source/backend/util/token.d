module backend.util.token;

/++
 + generates a user token
 +/
public string generateToken() @trusted
{
    import backend.db : find;
    import backend.data : AuthUser;
    import csprng.system : CSPRNG;
    import std.base64 : Base64;

    auto rng = new CSPRNG();

    ubyte[32] bytes;
    string key;

    do
    {
        bytes = cast(ubyte[]) rng.getBytes(32);
        key = Base64.encode(bytes);
    } while (!find!AuthUser(["token": key]).empty);

    return key;
}