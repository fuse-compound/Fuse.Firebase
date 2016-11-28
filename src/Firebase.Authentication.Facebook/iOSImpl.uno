using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.iOS;
using Uno.Threading;
using Firebase.Authentication;

namespace Firebase.Authentication.Facebook
{
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Source.Include", "FBSDKCoreKit/FBSDKCoreKit.h")]
    [Require("Source.Include", "FBSDKLoginKit/FBSDKLoginKit.h")]
    [Require("Source.Include", "@{FacebookService:Include}")]
    extern(iOS)
    class ReAuthenticate : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public ReAuthenticate()
        @{
            FIRUser *user = [FIRAuth auth].currentUser;

            FIRAuthCredential* credential =
                [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];

            [user reauthenticateWithCredential:credential completion:^(NSError* _Nullable error) {
                if (error)
                    @{ReAuthenticate:Of(_this).Reject(int):Call(error.code)};
                else
                    @{ReAuthenticate:Of(_this).Resolve(string):Call(@"success")};
            }];
        @}

        void Reject(int errorCode)
        {
            var reason = Errors.ReauthenticateWithCredentialBaseErrorMessage(errorCode);
            Reject(new Exception(reason));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Source.Include", "FBSDKCoreKit/FBSDKCoreKit.h")]
    [Require("Source.Include", "FBSDKLoginKit/FBSDKLoginKit.h")]
    [Require("Source.Include", "@{Firebase.Authentication.Facebook.JS.FacebookModule:Include}")]
    [Require("Source.Include", "@{FacebookService:Include}")]
    [Require("Source.Include", "iOSFacebookCallbacks.h")]

    extern(iOS)
    public class iOSFacebookButton : LeafView
	{
        static internal ObjC.Object _iosDelegate;
        static bool _initd = false;

        static iOSFacebookButton()
        {
            FacebookService.Init();
        }

		public iOSFacebookButton() : base(Create()) { }

		[Foreign(Language.ObjC)]
		static ObjC.Object Create()
        @{
            FireFacebookCallbacks* fireCB;
            if (!@{_initd:Get()})
            {
                fireCB = [[FireFacebookCallbacks alloc] init];
                @{_iosDelegate:Set(fireCB)};
                @{_initd:Set(true)};
            } else {
                fireCB = @{_iosDelegate:Get()};
            }

            FBSDKLoginButton* loginButton = [[FBSDKLoginButton alloc] init];
            loginButton.delegate = (id<FBSDKLoginButtonDelegate>)fireCB;
            loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];

            if ([FBSDKAccessToken currentAccessToken].tokenString != nil)
                @{OnFBAuth(IntPtr):Call((@{IntPtr})0)};

            return loginButton;
		@}

        [Foreign(Language.ObjC)]
        static void OnFBAuth(IntPtr err)
        @{
            NSError* error = (NSError*)err;

            if (error == nil) {
                NSString* tokenStr = [FBSDKAccessToken currentAccessToken].tokenString;

                if (tokenStr==NULL)
                {
                    @{OnAborted():Call()};
                    return;
                }

                @{Firebase.Authentication.Facebook.JS.FacebookModule.Auth(string):Call(tokenStr)};
                FIRAuthCredential* credential = [FIRFacebookAuthProvider credentialWithAccessToken:tokenStr];

                // auth againsts firebase
                [[FIRAuth auth] signInWithCredential:credential
                    completion:^(FIRUser* fuser, NSError* ferror) {
                        if (ferror)
                            @{OnFirebaseFailure(int):Call(ferror.code)};
                        else
                            @{OnSuccess(string):Call(@"success")};

                    }];
            } else {
                @{OnFacebookFailure(int):Call(error.code)};
            }
        @}

        static void OnSuccess(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Facebook);
        }

        static void OnAborted()
        {
            var message = "Facebook signin aborted";
            AuthService.SignalError(-1, message);
        }

        static void OnFacebookFailure(int code)
        {
            var message = "Facebook SignIn Failed";
            AuthService.SignalError(code, message);
        }

        static void OnFirebaseFailure(int code)
        {
            var message = Errors.SignInWithCredentialBaseErrorMessage(code);
            AuthService.SignalError(code, message);
        }
	}
}
