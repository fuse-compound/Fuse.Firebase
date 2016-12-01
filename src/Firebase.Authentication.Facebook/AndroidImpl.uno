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

namespace Firebase.Authentication.Facebook
{

    [ForeignInclude(Language.Java,
                    "com.facebook.AccessToken",
                    "com.facebook.CallbackManager",
                    "com.facebook.FacebookCallback",
                    "com.facebook.FacebookException",
                    "com.facebook.FacebookSdk",
                    "com.facebook.login.LoginManager",
                    "com.facebook.login.LoginResult",
                    "com.facebook.login.widget.LoginButton",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthCredential",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FacebookAuthProvider",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    extern(android)
    class ReAuthenticate : Promise<string>
    {
        static ReAuthenticate()
        {
            FacebookService.Init();
        }

        [Foreign(Language.Java)]
        public ReAuthenticate()
        @{
            final FirebaseUser user = (FirebaseUser)@{Firebase.Authentication.User.GetCurrent():Call()};
            AccessToken token = AccessToken.getCurrentAccessToken();

            AuthCredential credential = FacebookAuthProvider.getCredential(token.getToken());
            FirebaseAuth.getInstance().signInWithCredential(credential)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                        public void onComplete(Task<AuthResult> task) {
                            if (!task.isSuccessful())
                                @{ReAuthenticate:Of(_this).Resolve(string):Call("success")};
                            else
                                @{ReAuthenticate:Of(_this).Reject(string):Call("failed reauthentication")};
                        }});
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [Require("Gradle.Dependency.Compile", "com.facebook.android:facebook-android-sdk:4.16.+")]
    [Require("Android.ResStrings.Declaration", "<string name=\"facebook_app_id\">@(Project.Facebook.AppID)</string>")]
    [Require("AndroidManifest.ApplicationElement", "<meta-data android:name=\"com.facebook.sdk.ApplicationId\" android:value=\"@string/facebook_app_id\"/>")]
    [ForeignInclude(Language.Java,
                    "com.facebook.AccessToken",
                    "com.facebook.CallbackManager",
                    "com.facebook.FacebookCallback",
                    "com.facebook.FacebookException",
                    "com.facebook.FacebookSdk",
                    "com.facebook.login.LoginManager",
                    "com.facebook.login.LoginResult",
                    "com.facebook.login.widget.LoginButton",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthCredential",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FacebookAuthProvider",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser",
                    "android.os.Handler")]
    extern(android)
    public class AndroidFacebookButton : LeafView
	{
        static AndroidFacebookButton()
        {
            FacebookService.Init();
        }

		public AndroidFacebookButton() : base(Create())
        {
            EncueAutoSignIn();
        }

        [Foreign(Language.Java)]
        void EncueAutoSignIn()
        @{
            // if the button has retained credentials use them to log in
            // at startup. The delay is as firebase is known to pull these
            // detail asyncronously so as not to block the ui thread.
            // This wait is cludgy but was recommended on a StackOverflow
            // thread. cest la vie
            final Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                public void run() {
                    AccessToken token = AccessToken.getCurrentAccessToken();
                    if (token!=null)
                    {
                        @{OnAuth(Java.Object):Call(token)};
                    }
                }}, 500);
        @}

		[Foreign(Language.Java)]
		static Java.Object Create()
        @{
            LoginButton loginButton = new LoginButton(com.fuse.Activity.getRootActivity());
            loginButton.setReadPermissions("email", "public_profile");
            loginButton.registerCallback(
                (CallbackManager)@{FacebookService.CallbackManager},
                new FacebookCallback<LoginResult>() {
                    public void onSuccess(LoginResult loginResult) {
                        @{OnAuth(Java.Object):Call(loginResult.getAccessToken())};
                    }

                    public void onCancel() {
                        @{OnFailure(string):Call("Facebook Auth Stage Cancelled")};
                    }

                    public void onError(FacebookException error) {
                        String reason = "Facebook Auth Stage Errored (" + error.getClass().getName() + "):\n" + error.getMessage();
                        @{OnFailure(string):Call(reason)};
                    }
                });
            return loginButton;
		@}

        [Foreign(Language.Java)]
        static void OnAuth(Java.Object loginToken)
        @{
            final AccessToken token = (AccessToken)loginToken;
            AuthCredential credential = FacebookAuthProvider.getCredential(token.getToken());
            FirebaseAuth.getInstance().signInWithCredential(credential)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                        public void onComplete(Task<AuthResult> task) {
                            if (task.isSuccessful())
                                @{OnSuccess(string):Call("Success")};
                            else
                                @{OnFailure(string):Call("Authentication against Firebase failed")};
                        }});
        @}

        static void OnSuccess(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Facebook);
        }

        static void OnFailure(string reason)
        {
            AuthService.SignalError(-1, reason);
        }
	}
}
