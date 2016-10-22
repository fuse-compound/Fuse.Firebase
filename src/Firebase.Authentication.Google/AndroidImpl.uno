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
    extern(android)
    class ReAuthenticate : Promise<string>
    {
        static ReAuthenticate()
        {
            GoogleService.Init();
        }

        public ReAuthenticate()
        {
            var intent = MakeIntent();
            Android.ActivityUtils.StartActivity(intent, onResult);
        }

        [Foreign(Language.Java)]
        Java.Object MakeIntent()
        @{
            final GoogleApiClient client = (GoogleApiClient)@{GoogleService._mGoogleApiClient};
            return Auth.GoogleSignInApi.getSignInIntent(client);
        @}

        [Foreign(Language.Java)]
        void onResult(int resultCode, Java.Object intent, object info)
        @{
            final Intent data = (Intent)intent;
            GoogleSignInResult result = Auth.GoogleSignInApi.getSignInResultFromIntent(data);
            if (!result.isSuccess()) {
                @{ReAuthenticate:Of(_this).Reject(string):Call("SignIn Failed: Google re-authentication failed")};
                return;
            }
            // kick off next step
            GoogleSignInAccount account = result.getSignInAccount();
            AuthCredential credential = GoogleAuthProvider.getCredential(account.getIdToken(), null);
            @{Firebase.Authentication.Google.JS.GoogleModule.Auth(string,string):Call(account.getIdToken(),null)};
            FirebaseAuth.getInstance().signInWithCredential(credential)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                        public void onComplete(Task<AuthResult> task) {
                            if (task.isSuccessful())
                                @{ReAuthenticate:Of(_this).Resolve(string):Call("success")};
                            else
                                @{ReAuthenticate:Of(_this).Reject(string):Call("SignIn Failed: GoogleSignIn re-authentication succeeded however the re-authentication against firebase failed.")};
                        }});
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }

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
                    "com.google.firebase.auth.GoogleAuthProvider",
                    "com.google.android.gms.common.SignInButton")]
    extern(android) public class AndroidGoogleButton : LeafView
	{

        static AndroidGoogleButton()
        {
            GoogleService.Init();
        }

		public AndroidGoogleButton() : base(Create()) { }


		[Foreign(Language.Java)]
		static Java.Object Create()
		@{
             SignInButton button = new SignInButton(com.fuse.Activity.getRootActivity());
             button.setOnClickListener(new android.view.View.OnClickListener() {
                 public void onClick(android.view.View v) {
                     @{SignInUser():Call()};
                 }
             });
             return button;
		@}

        static void SignInUser()
        {
            var intent = MakeIntent();
            Android.ActivityUtils.StartActivity(intent, onResult);
        }

        [Foreign(Language.Java)]
        static Java.Object MakeIntent()
        @{
            final GoogleApiClient client = (GoogleApiClient)@{GoogleService._mGoogleApiClient};
            return Auth.GoogleSignInApi.getSignInIntent(client);
        @}

        [Foreign(Language.Java)]
        static void onResult(int resultCode, Java.Object intent, object info)
        @{
            final Intent data = (Intent)intent;
            GoogleSignInResult result = Auth.GoogleSignInApi.getSignInResultFromIntent(data);
            if (!result.isSuccess()) {
                @{OnFailure(string):Call("SignIn Failed: GoogleSignIn failed")};
                return;
            }
            // kick off next step
            GoogleSignInAccount account = result.getSignInAccount();
            AuthCredential credential = GoogleAuthProvider.getCredential(account.getIdToken(), null);
            @{Firebase.Authentication.Google.JS.GoogleModule.Auth(string,string):Call(account.getIdToken(),null)};
            FirebaseAuth.getInstance().signInWithCredential(credential)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                        public void onComplete(Task<AuthResult> task) {
                            if (task.isSuccessful())
                                @{OnSuccess(string):Call("success")};
                            else
                                @{OnFailure(string):Call("SignIn Failed: GoogleSignIn succeeded however following authenticate against firebase failed.")};
                        }});
        @}

        static void OnSuccess(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Google);
        }

        static void OnFailure(string reason)
        {
            AuthService.SignalError(-1, reason);
        }
	}
}
