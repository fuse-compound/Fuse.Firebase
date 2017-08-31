using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;
using Uno.Threading;
using Firebase.Authentication;
using Firebase.Authentication;

namespace Firebase.Authentication.Google
{

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.content.Intent",
                    "com.google.android.gms.auth.api.Auth",
                    "com.google.android.gms.auth.api.signin.GoogleSignInAccount",
                    "com.google.android.gms.auth.api.signin.GoogleSignInOptions",
                    "com.google.android.gms.auth.api.signin.GoogleSignInResult",
                    "com.google.android.gms.common.ConnectionResult",
                    "com.google.android.gms.common.api.GoogleApiClient",
                    "com.google.android.gms.common.api.ResultCallback",
                    "com.google.android.gms.common.api.Status",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthCredential",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser",
                    "com.google.firebase.auth.GoogleAuthProvider")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-auth:9.8.0")]
    [Require("Gradle.Dependency.Compile", "com.google.android.gms:play-services-auth:9.8.0")]
    [Require("Cocoapods.Podfile.Target", "pod 'GoogleSignIn'")]
    [Require("AppDelegate.HeaderFile.Declaration", "#include <GoogleSignIn/GoogleSignIn.h>")]
    [Require("AppDelegate.SourceFile.Declaration", "#include <GoogleSignIn/GoogleSignIn.h>")]
    [extern(iOS) Require("Source.Include", "GoogleSignIn/GoogleSignIn.h")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]
    [extern(iOS) Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [extern(iOS) Require("Source.Include", "iOSCallbacks.h")]
    public class GoogleService : Firebase.Authentication.AuthProvider
    {
        static bool _initd = false;

        extern(mobile) static string _requestID = extern<string>"uString::Ansi(\"@(Project.Google.RequestID:Or(''))\")";

        extern(ios) static internal ObjC.Object _iosDelegate;
        extern(android) static internal Java.Object _mGoogleApiClient;
        extern(android) static Java.Object _gso;

        public override AuthProviderName Name { get { return AuthProviderName.Google; } }

        internal static void Init()
        {
            if (_initd) return;
            var gs = new GoogleService();
            Firebase.Authentication.AuthService.RegisterAuthProvider(gs);
            _initd = true;
        }

        extern(!mobile)
        public override void Start() {}

        extern(android)
        public override void Start()
        {
            _gso = MakeSignInOptions();
            _mGoogleApiClient = MakeClient(_gso);
        }

        public override void SignOut()
        {
            if defined(mobile)
                SignOutInner();
        }

        [Foreign(Language.Java)]
        extern(android)
        public void SignOutInner()
        @{
            Auth.GoogleSignInApi.signOut((GoogleApiClient)@{_mGoogleApiClient}).setResultCallback(
                new ResultCallback<Status>() {
                    public void onResult(Status status) {
                        // Left here for future expansion
                    }});
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public void SignOutInner()
        @{
            [[GIDSignIn sharedInstance] signOut];
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public override void Start()
        @{
            FireGoogCallbacks* fireCB = [[FireGoogCallbacks alloc] init];
            @{_iosDelegate:Set(fireCB)};
            [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
            [GIDSignIn sharedInstance].delegate = (id<GIDSignInDelegate>)fireCB;
            [GIDSignIn sharedInstance].uiDelegate = (id<GIDSignInUIDelegate>)fireCB;
        @}


        [Foreign(Language.Java)]
        extern(android)
        static Java.Object MakeSignInOptions()
        @{
            return new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken(@{_requestID})
                .requestEmail()
                .build();
        @}

        [Foreign(Language.Java)]
        extern(android)
        static Java.Object MakeClient(Java.Object gso)
        @{
            final GoogleSignInOptions signInOptions = (GoogleSignInOptions)gso;

            GoogleApiClient.OnConnectionFailedListener l = new GoogleApiClient.OnConnectionFailedListener() {
                public void onConnectionFailed(ConnectionResult connectionResult) {
                    String m = "An unresolvable error has occurred and Google APIs (including Sign-In) will not be available.";
                    @{ConnectionFailed(string):Call(m)};
                }
            };

            return new GoogleApiClient.Builder(com.fuse.Activity.getRootActivity())
                .enableAutoManage(com.fuse.Activity.getRootActivity(), l)
                .addApi(Auth.GOOGLE_SIGN_IN_API, signInOptions)
                .build();
        @}

        static void ConnectionFailed(string message)
        {
            throw new Exception(message);
        }

        public override Promise<string> ReAuthenticate(string email, string password)
        {
            return new ReAuthenticate();
        }
    }

    extern(!mobile)
    class SignInUser : Promise<string>
    {
        public void Reject(string reason) { }
    }

    extern(!mobile)
    class ReAuthenticate : Promise<string>
    {
        public ReAuthenticate() { }
        public void Reject(string reason) { }
    }

    public class GoogleButton : Panel
    {
        protected override IView CreateNativeView()
        {
            if defined(Android)
            {
                return new AndroidGoogleButton();
            }
            else if defined(iOS)
            {
                return new iOSGoogleButton();
            }
            else
            {
                return base.CreateNativeView();
            }
        }
    }
}
