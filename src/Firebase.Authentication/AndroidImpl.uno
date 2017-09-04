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

namespace Firebase.Authentication
{
    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.net.Uri",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    extern(android)
    internal static class User
    {
        [Foreign(Language.Java)]
        internal static Java.Object GetCurrent()
        @{
            return FirebaseAuth.getInstance().getCurrentUser();
        @}

        [Foreign(Language.Java)]
        internal static string GetUid(Java.Object obj)
        @{
            FirebaseUser user = (FirebaseUser)obj;
            String r = user.getUid();
            return r;
        @}

        [Foreign(Language.Java)]
        internal static string GetName(Java.Object obj)
        @{
            FirebaseUser user = (FirebaseUser)obj;
            String r = user.getDisplayName();
            return r;
        @}

        [Foreign(Language.Java)]
        internal static string GetEmail(Java.Object obj)
        @{
            FirebaseUser user = (FirebaseUser)obj;
            String r = user.getEmail();
            return r;
        @}

        [Foreign(Language.Java)]
        internal static string GetPhotoUrl(Java.Object obj)
        @{
            FirebaseUser user = (FirebaseUser)obj;
            Uri uri = user.getPhotoUrl();
            return (uri==null) ? null : uri.toString();
        @}
    }


    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.net.Uri",
                "com.google.android.gms.tasks.OnCompleteListener",
                "com.google.android.gms.tasks.Task",
                "com.google.firebase.auth.AuthResult",
                "com.google.firebase.auth.GetTokenResult",
                "com.google.firebase.auth.FirebaseAuth",
                "com.google.firebase.auth.FirebaseUser",
                "com.google.firebase.auth.UserProfileChangeRequest")]
    extern(android)
    internal class GetToken : Promise<string>
    {
        [Foreign(Language.Java)]
        public GetToken()
        @{
            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};
            user.getToken(true).addOnCompleteListener(new OnCompleteListener<GetTokenResult>() {
                    public void onComplete(Task<GetTokenResult> task)
                    {
                        if (task.isSuccessful()) {
                            String token = task.getResult().getToken();
                            @{UpdateProfile:Of(_this).Resolve(string):Call(token)};
                        } else {
                            @{UpdateProfile:Of(_this).Reject(string):Call("failed getting token for user")};
                        }
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
                    "com.google.firebase.auth.FirebaseUser",
                    "com.google.firebase.auth.UserProfileChangeRequest")]
    extern(android)
    internal class UpdateProfile : Promise<string>
    {
        [Foreign(Language.Java)]
        public UpdateProfile(string displayName, string photoUri)
        @{
            if (displayName == null && photoUri == null)
            {
                @{UpdateProfile:Of(_this).Reject(string):Call("UpdateProfile requires that at least one of displayName or photoUri are provided")};
                return;
            }

            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};

            UserProfileChangeRequest.Builder builder = new UserProfileChangeRequest.Builder();
            if (displayName!=null)
                builder.setDisplayName(displayName);
            if (photoUri!=null)
                builder.setPhotoUri(Uri.parse(photoUri));
            UserProfileChangeRequest profileUpdates = builder.build();

            user.updateProfile(profileUpdates)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                        public void onComplete(Task<Void> task)
                        {
                            if (task.isSuccessful())
                                @{UpdateProfile:Of(_this).Resolve(string):Call("success")};
                            else
                                @{UpdateProfile:Of(_this).Reject(string):Call("Firebase failed to update profile")};
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
    internal class UpdateEmail : Promise<string>
    {
        [Foreign(Language.Java)]
        public UpdateEmail(string email)
        @{
            if (email == null)
            {
                @{UpdateEmail:Of(_this).Reject(string):Call("UpdateEmail requires that an email address is provided")};
                return;
            }

            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};

            user.updateEmail(email)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                        public void onComplete(Task<Void> task) {
                            if (task.isSuccessful())
                                @{UpdateEmail:Of(_this).Resolve(string):Call("success")};
                            else
                                @{UpdateEmail:Of(_this).Reject(string):Call("Firebase failed to update email user's address")};
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
    internal class DeleteUser : Promise<string>
    {

        [Foreign(Language.Java)]
        public DeleteUser()
        @{
            final FirebaseUser user = (FirebaseUser)@{User.GetCurrent():Call()};
            final String email = user.getEmail();

            user.delete()
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                        public void onComplete(Task<Void> task) {
                            if (task.isSuccessful())
                                @{DeleteUser:Of(_this).Resolve(string):Call("User with email " + email + " deleted")};
                            else
                                @{DeleteUser:Of(_this).Reject(string):Call("Firebase failed to delete user")};
                        }
                    });
        @}

        void Reject(string reason) { Reject(new Exception(reason)); }
    }
}
