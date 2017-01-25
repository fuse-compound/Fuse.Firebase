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
    // this enum is a shame but we want to talk about the backend even when it isnt included
    public enum AuthProviderName { None, Email, Facebook, Google }

    [ForeignInclude(Language.Java, "java.util.ArrayList", "java.util.List", "android.graphics.Color",
                    "com.google.android.gms.tasks.OnCompleteListener",
                    "com.google.android.gms.tasks.Task",
                    "com.google.firebase.auth.AuthResult",
                    "com.google.firebase.auth.FirebaseAuth",
                    "com.google.firebase.auth.FirebaseUser")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-auth:9.2.0")]
    [Require("AppDelegate.SourceFile.Declaration", "#include <@{Firebase.Authentication.AuthService:Include}>")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]
    [extern(iOS) Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    extern(mobile)
    internal static class AuthService
    {
        internal static event Action UserChanged;
        internal static event Action<int, string> OnError;

        static Dictionary<AuthProviderName, AuthProvider> AuthProviders = new Dictionary<AuthProviderName, AuthProvider>();
        static AuthProviderName CurrentProvider { public get; private set; }

        static Firebase.Core _core;
        static object Inst { internal get; private set; }
        static bool _isSignedIn;

        extern(Android) static Java.Object _listener;
        extern(iOS) static ObjC.Object _listener;

        static public void Init()
        {
            if (Inst == null)
            {
                CurrentProvider = AuthProviderName.None;
                Firebase.Core.Init();
                Inst = ForeignInit();
                _listener = MakeListener();
                StartListener(_listener);
            }
        }

		[Foreign(Language.Java)]
        extern(Android)
		internal static Java.Object ForeignInit()
		@{
            return FirebaseAuth.getInstance();
		@}

		[Foreign(Language.ObjC)]
        extern(iOS)
		static ObjC.Object ForeignInit()
		@{
            return [FIRAuth auth];
		@}


        public static void RegisterAuthProvider(AuthProvider provider)
        {
            AuthProviders.Add(provider.Name, provider);
            provider.Start();
        }


        [Foreign(Language.Java)]
        extern(Android)
        static Java.Object MakeListener()
        @{
            FirebaseAuth.AuthStateListener l = new FirebaseAuth.AuthStateListener() {
                @Override
                public void onAuthStateChanged(FirebaseAuth firebaseAuth) {
                    @{AuthStateChanged():Call()};
                }
            };
            return l;
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        static ObjC.Object MakeListener()
        @{
            void (^_f)(FIRAuth*, FIRUser*) = ^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user)
            {
                @{AuthStateChanged():Call()};
            };
            return (id)Block_copy(_f);
        @}


        [Foreign(Language.Java)]
        extern(Android)
        static void StartListener(Java.Object listener)
        @{
            FirebaseAuth.AuthStateListener l = (FirebaseAuth.AuthStateListener)listener;
            FirebaseAuth.getInstance().addAuthStateListener(l);
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        static void StartListener(ObjC.Object listener)
        @{
            void (^l)(FIRAuth*, FIRUser*) = (void (^)(FIRAuth*, FIRUser*))listener;
            [[FIRAuth auth] addAuthStateDidChangeListener: l];
        @}



        [Foreign(Language.Java)]
        extern(Android)
        static void StopListener(Java.Object listener)
        @{
            FirebaseAuth.AuthStateListener l = (FirebaseAuth.AuthStateListener)listener;
            FirebaseAuth.getInstance().removeAuthStateListener(l);
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        static void StopListener(ObjC.Object listener)
        @{
            void (^l)(FIRAuth*, FIRUser*) = (void (^)(FIRAuth*, FIRUser*))listener;
            [[FIRAuth auth] removeAuthStateDidChangeListener: l];
        @}


        static void AuthStateChanged()
        {
            var signedIn = (User.GetCurrent() != null);
            if (_isSignedIn == signedIn)
                return;

            _isSignedIn = signedIn;

            var handler = UserChanged;
            if (handler != null)
                handler();
        }


        public static Promise<string> ReAuthenticate(string email, string password)
        {
            if (CurrentProvider == AuthProviderName.None)
                return NewFailedPromise("Firebase.Authentication: No user is currently signed in/signin provider is not known");
            else
                return AuthProviders[CurrentProvider].ReAuthenticate(email, password);
        }

        internal class InstaFail : Promise<string>
        {
            public InstaFail() {}
            public void Reject(string reason) { Reject(new Exception(reason)); }
        }

        static Promise<string> NewFailedPromise(string message)
        {
            var result = new InstaFail();
            result.Reject(message);
            return result;
        }

        internal static void SignedOut()
        {
            // may not be needed as authstate would change
        }


        internal static void SignalError(int code, string message)
        {
            var handler = OnError;
            if (handler!=null)
                handler(code, message);
        }

        internal static void SignOut()
        {
            SignOutFirebase();
            SignOutCurrentProvider();
        }

        static void SignOutCurrentProvider()
        {
            if (CurrentProvider == AuthProviderName.None)
                return;
            AuthProviders[CurrentProvider].SignOut();
            CurrentProvider = AuthProviderName.None;
        }

        [Foreign(Language.Java)]
        extern(android)
        internal static void SignOutFirebase()
        @{
            FirebaseAuth.getInstance().signOut();
        @}


        [Foreign(Language.ObjC)]
        extern(iOS)
        internal static void SignOutFirebase()
        @{
            NSError *error;
            [[FIRAuth auth] signOut:&error];
            if (!error) {
                // Sign-out succeeded
            }
        @}

        internal static void AnnounceSignIn(AuthProviderName newCurrent)
        {
            SignOutCurrentProvider();
            CurrentProvider = newCurrent;
        }
	}



    public abstract class AuthProvider
    {
        public object Credential { public get; protected set; }

        public abstract AuthProviderName Name { get; }
        public abstract void Start();
        public abstract void SignOut();
        public abstract Promise<string> ReAuthenticate(string email, string password);
    }


    //----------------------------------------------------------------------

    extern(!mobile)
    static internal class AuthService
    {
        internal static object Credential;
        internal static event Action UserChanged;
        internal static event Action<int, string> OnError;
        public static void Init() { }
        internal static void SignOut() { }
        public static Promise<string> ReAuthenticate(string email, string password) { return null; }
        public static void RegisterAuthProvider(AuthProvider provider) { }
    }

    extern(!mobile)
    static internal class User
    {
        internal static object GetCurrent() { return null; }
        internal static string GetName(object obj) { return null; }
        internal static string GetEmail(object obj) { return null; }
        internal static string GetPhotoUrl(object obj) { return null; }
    }

    extern(!mobile)
    internal class UpdateProfile : Promise<string>
    {
        public UpdateProfile(string displayName, string photoUri) {}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    extern(!mobile)
    internal class UpdateEmail : Promise<string>
    {
        public UpdateEmail(string email) {}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    extern(!mobile)
    internal class DeleteUser : Promise<string>
    {
        public DeleteUser() {}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }
}
