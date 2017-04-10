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
using Firebase.Authentication;

namespace Firebase.Authentication.JS
{
	/**
	*/
	[UXGlobalModule]
	public sealed class AuthModule : NativeModule
	{
		static readonly AuthModule _instance;
        static NativeEvent _onSignInChanged;
        static NativeEvent _onError;

		public AuthModule()
		{
			if(_instance != null) return;

			Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/User");

            AuthService.Init();

            // properties
            AddMember(new NativeProperty<bool, bool>("isSignedIn", GetSignedIn));
            AddMember(new NativeProperty<string, string>("name", GetName));
            AddMember(new NativeProperty<string, string>("email", GetEmail));
            AddMember(new NativeProperty<string, string>("photoUrl", GetPhotoUrl));

            // events
            _onSignInChanged = new NativeEvent("signedInStateChanged");
            _onError = new NativeEvent("onError");
            AddMember(_onSignInChanged);
            AddMember(_onError);

            // functions/promises
            AddMember(new NativeFunction("signOut", SignOut));

            AddMember(new NativePromise<string, string>("updateProfile", UpdateProfile, null));
            AddMember(new NativePromise<string, string>("updateEmail", UpdateEmail, null));

            AddMember(new NativePromise<string, string>("delete", DeleteUser, null));
            AddMember(new NativePromise<string, string>("reauthenticate", ReAuthenticate, null));

            AuthService.UserChanged += OnUser;
            AuthService.OnError += OnError;
		}

        // properties
        static bool GetSignedIn()
        {
            return Firebase.Authentication.User.GetCurrent()!=null;
        }

        static string GetName()
		{
            if (GetSignedIn())
                return User.GetName(User.GetCurrent());
            else
                return "";
		}

        static string GetEmail()
		{
            if (GetSignedIn())
                return User.GetEmail(User.GetCurrent());
            else
                return "";
		}

        static string GetPhotoUrl()
		{
            if (GetSignedIn())
                return User.GetPhotoUrl(User.GetCurrent());
            else
                return "";
		}

        // events
        static void OnUser()
		{
		    _onSignInChanged.RaiseAsync(GetSignedIn());
		}

        static void OnError(int errorCode, string message)
		{
		    _onError.RaiseAsync(message, errorCode);
		}



        // functions
        static Future<string> UpdateProfile(object[] args)
        {
            var displayName = (string)args[0];
            var photoUri = (string)args[1];
            return new UpdateProfile(displayName, photoUri);
        }

		// static object UpdateUser(Context context, object[] args)
        // {
        //     return null;
        // }

        static Future<string> UpdateEmail(object[] args)
        {
            var email = (string)args[0];
            return new UpdateEmail(email);
        }

        static Future<string> DeleteUser(object[] args)
        {
            return new DeleteUser();
        }

		static object SignOut(Context context, object[] args)
        {
            AuthService.SignOut();
            return null;
        }

        Future<string> ReAuthenticate(object[] args)
        {
            var email = (args.Length>0) ? (string)args[0] : null;
            var password = (args.Length>1) ? (string)args[1] : null;
            return AuthService.ReAuthenticate(email, password);
        }
	}
}
