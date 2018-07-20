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

namespace Firebase.Authentication.Email
{
    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.graphics.Color",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-auth:11.8.0")]
    extern(android)
    internal class CreateUser : Promise<string>
    {
        public CreateUser(string email, string password)
        {
            Init(email, password);
        }

        [Foreign(Language.Java)]
        public void Init(string email, string password)
        @{
            FirebaseAuth.getInstance().createUserWithEmailAndPassword(email, password)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                    public void onComplete(Task<AuthResult> task)
                    {
                        if (task.isSuccessful())
                            @{CreateUser:Of(_this).Resolve(string):Call("success")};
                        else
                            @{CreateUser:Of(_this).Reject(string):Call("Firebase failed to create user")};
                    }
                });
        @}

        void Resolve(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Email);
            base.Resolve(message);
        }

        void Reject(string reason)
        {
            Reject(new Exception(reason));
        }
    }

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.graphics.Color",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-auth:11.8.0")]
    extern(android)
    internal class SignInUser : Promise<string>
    {
        public SignInUser(string email, string password)
        {
            Init(email, password);
        }

        [Foreign(Language.Java)]
        void Init(string email, string password)
        @{
            FirebaseAuth.getInstance().signInWithEmailAndPassword(email, password)
                .addOnCompleteListener(com.fuse.Activity.getRootActivity(), new OnCompleteListener<AuthResult>() {
                        public void onComplete(Task<AuthResult> task)
                        {
                        if (task.isSuccessful())
                            @{SignInUser:Of(_this).Resolve(string):Call("success")};
                        else
                            @{SignInUser:Of(_this).Reject(string):Call("Firebase failed to signin user")};
                        }
                    });
        @}

        void Resolve(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Email);
            base.Resolve(message);
        }

        void Reject(string reason) { Reject(new Exception(reason)); }
    }


    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.net.Uri",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser",
                    "com.google.firebase.auth.EmailAuthProvider",
                    "com.google.firebase.auth.AuthCredential",
                    "com.google.firebase.auth.UserProfileChangeRequest")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-auth:11.8.0")]
    extern(android)
    internal class ReAuthenticate : Promise<string>
    {
        [Foreign(Language.Java)]
        public ReAuthenticate(string email, string password)
        @{
            if (email == null)
            {
                @{ReAuthenticate:Of(_this).Reject(string):Call("ReAuthenticate requires that email is provided")};
                return;
            }
            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};

            AuthCredential credential = EmailAuthProvider.getCredential(email, password);

            user.reauthenticate(credential)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                        public void onComplete(Task<Void> task)
                        {
                            if (task.isSuccessful())
                                @{ReAuthenticate:Of(_this).Resolve(string):Call("success")};
                            else
                                @{ReAuthenticate:Of(_this).Reject(string):Call("Firebase failed to reautheticate user")};
                        }
                    });
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.net.Uri",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    extern(android)
    internal class UpdatePassword : Promise<string>
    {
        [Foreign(Language.Java)]
        public UpdatePassword(string password)
        @{
            if (password == null)
            {
                @{UpdatePassword:Of(_this).Reject(string):Call("UpdatePassword requires that a password is provided")};
                return;
            }

            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};

            user.updatePassword(password)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                        public void onComplete(Task<Void> task) {
                            if (task.isSuccessful())
                                @{UpdatePassword:Of(_this).Resolve(string):Call("success")};
                            else
                                @{UpdatePassword:Of(_this).Reject(string):Call("Firebase failed to update user's password")};
                        }
                    });
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.net.Uri",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    extern(android)
    internal class SendVerificationEmail : Promise<string>
    {
        [Foreign(Language.Java)]
        public SendVerificationEmail()
        @{
            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};

            user.sendEmailVerification()
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    public void onComplete(@NonNull Task<Void> task) {
                            if (task.isSuccessful())
                                @{SendVerificationEmail:Of(_this).Resolve(string):Call("Success")};
                            else
                                @{SendVerificationEmail:Of(_this).Reject(string):Call("Firebase failed to send verification email")};
                        }
                    });
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }
}
