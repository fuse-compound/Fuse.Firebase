using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;

[UXGlobalModule]
public class TokenModule : NativeModule
{
    static readonly TokenModule _instance;
    public TokenModule()
    {
        if (_instance != null) return;

        _instance = this;
        Resource.SetGlobalKey(_instance, "TokenModule");
        AddMember(new NativePromise<string, string>("GetFBToken", GetFBToken, null));
    }

    static string GetFBToken(object[] args)
    {
        InitForeign.Init();
        return InitForeign.Token;
    }
}

class InitForeign
{
    public static string Token = "";

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Foreign(Language.ObjC)]
    public static extern(iOS) void Init()
    @{
        [NSThread sleepForTimeInterval:1];
        NSString *fcmToken = [[FIRInstanceID instanceID] token];
        @{Token:Set(fcmToken)};
    @}

    [Foreign(Language.Java)]
    public static extern(Android) void Init()
    @{
        String id = com.google.firebase.iid.FirebaseInstanceId.getInstance().getToken();
        @{Token:Set(id)};
    @}

    public static extern(!mobile) void Init()
    {
        debug_log("Not Implemented for Desktop");
    }
}
