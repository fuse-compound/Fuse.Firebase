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

namespace Firebase.Authentication.Google
{
    [Require("AppDelegate.SourceFile.Declaration", "#include <GoogleSignIn/GoogleSignIn.h>")]
    [Require("Source.Include", "GoogleSignIn/GoogleSignIn.h")]
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    [Require("Source.Include", "@{Firebase.Authentication.User:Include}")]
    [Require("Source.Include", "@{Firebase.Authentication.Google.iOSGoogleButton:Include}")]
    extern(iOS)
    class ReAuthenticate : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public ReAuthenticate()
        @{
            FIRUser *user = [FIRAuth auth].currentUser;
            GIDGoogleUser* guser = [GIDSignIn sharedInstance].currentUser;
            GIDAuthentication* authentication = guser.authentication;

            FIRAuthCredential* credential =
                [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                 accessToken:authentication.accessToken];

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

    [Require("AppDelegate.SourceFile.Declaration", "#include <GoogleSignIn/GoogleSignIn.h>")]
    [Require("AppDelegate.SourceFile.Declaration", "#include <@{Firebase.Authentication.Google.iOSGoogleButton:Include}>")]
    [Require("Source.Include", "GoogleSignIn/GoogleSignIn.h")]
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS) public class iOSGoogleButton : LeafView
	{
		public iOSGoogleButton() : base(Create()) { }


		[Foreign(Language.ObjC)]
		[Require("Entity","Firebase.Authentication.Google.JS.GoogleModule.Auth(string,string)")]

		static ObjC.Object Create()
		@{
            [[GIDSignIn sharedInstance] signInSilently];
			return [[GIDSignInButton alloc] init];
		@}

        [Foreign(Language.ObjC)]
        static void Callback(IntPtr usr, IntPtr err)
        @{
            GIDGoogleUser* user = (GIDGoogleUser*)usr;
            NSError* error = (NSError*)err;

            if (error == nil) {
                GIDAuthentication* authentication = user.authentication;

                FIRAuthCredential* credential =
                    [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                     accessToken:authentication.accessToken];

                // auth againsts firebase
                [[FIRAuth auth] signInWithCredential:credential
                    completion:^(FIRUser* fuser, NSError* ferror) {
                        if (ferror)
                            @{OnFirebaseFailure(int):Call(ferror.code)};
                        else
                            @{OnSuccess(string):Call(@"success")};

                    }];
            } else {
                @{OnGoogleFailure(int):Call(error.code)};
            }
        @}

        static void OnSuccess(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Google);
        }

        static void OnGoogleFailure(int code)
        {
            var message = "Google SignIn Failed";
            AuthService.SignalError(code, message);
        }

        static void OnFirebaseFailure(int code)
        {
            var message = Errors.SignInWithCredentialBaseErrorMessage(code);
            AuthService.SignalError(code, message);
        }
	}
}
