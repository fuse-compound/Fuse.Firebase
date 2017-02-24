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
    [ForeignInclude(Language.Java, "com.facebook.FacebookSdk", "com.facebook.CallbackManager", "com.facebook.login.LoginManager")]
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'FBSDKCoreKit'")]
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'FBSDKShareKit'")]
    [extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'FBSDKLoginKit'")]
    [extern(iOS) Require("AppDelegate.SourceFile.Declaration", "#include <FBSDKCoreKit/FBSDKCoreKit.h>")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]
    [extern(iOS) Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [extern(iOS) Require("Source.Include", "FBSDKCoreKit/FBSDKCoreKit.h")]
    [extern(iOS) Require("Source.Include", "FBSDKLoginKit/FBSDKLoginKit.h")]
    public class FacebookService : Firebase.Authentication.AuthProvider
    {
        static bool _initd = false;
        extern(android) internal static Java.Object CallbackManager;
        extern(iOS) internal static ObjC.Object LoginManager;

        public override AuthProviderName Name { get { return AuthProviderName.Facebook; } }

        internal static void Init()
        {
            if (_initd) return;
            var fs = new FacebookService();
            Firebase.Authentication.AuthService.RegisterAuthProvider(fs);
            _initd = true;
        }

        extern(!mobile)
        public override void Start() {}

        extern(android)
        public override void Start()
        {
            Android.ActivityUtils.Results += ForwardActivityResults;
            StartGoogle();
        }

        [Foreign(Language.Java)]
        extern(android)
        public void StartGoogle()
        @{
            FacebookSdk.sdkInitialize(com.fuse.Activity.getRootActivity());
            @{CallbackManager:Set(CallbackManager.Factory.create())};
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public override void Start()
        @{
            FBSDKLoginManager* lm = [[FBSDKLoginManager alloc] init];
            @{LoginManager:Set(lm)};
        @}

        public override void SignOut()
        {
            if defined(mobile)
                SignOutInner();
        }

        [Foreign(Language.Java)]
        extern(android)
        public void SignOutInner()
        @{
            LoginManager lm = LoginManager.getInstance();
            if (lm!=null)
                lm.logOut();
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        public void SignOutInner()
        @{
            id lm = @{LoginManager:Get()};
            [lm logOut];
        @}

        public override Promise<string> ReAuthenticate(string ignored0, string ignored1)
        {
            return new ReAuthenticate();
        }

        [Foreign(Language.Java)]
        extern(android)
        void ForwardActivityResults(int requestCode, int resultCode, Java.Object data)
        @{
            ((CallbackManager)@{CallbackManager}).onActivityResult(requestCode, resultCode, (android.content.Intent)data);
        @}

        [Foreign(Language.ObjC)]
        extern(iOS)
        static void LogForeground()
        @{
            [FBSDKAppEvents activateApp];
        @}
    }

    extern(!mobile)
    class ReAuthenticate : Promise<string>
    {
        public void Reject(string reason) { }
        public void Resolve() { }
    }

    public class FacebookButton : Panel
	{
		protected override IView CreateNativeView()
		{
			if defined(Android)
            {
                return new AndroidFacebookButton();
            }
			else if defined(iOS)
            {
                return new iOSFacebookButton();
            }
			else
			{
				return base.CreateNativeView();
			}
		}
	}
}
