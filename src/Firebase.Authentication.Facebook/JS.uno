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

namespace Firebase.Authentication.Facebook.JS
{
    /**
    */
    [UXGlobalModule]
    public sealed class FacebookModule : NativeModule
    {
        static readonly FacebookModule _instance;
        static NativeEvent _onAuth, _onError;
        readonly FacebookAuthentication _facebookAuthentication;

        public FacebookModule()
        {
            if(_instance != null) return;
            Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/Facebook");
            _facebookAuthentication = new FacebookAuthentication();
            _onAuth = new NativeEvent("onAuth");
            AddMember(_onAuth);
             _onError = new NativeEvent("onFailed");
            AddMember(_onError);
            AddMember(new NativeFunction("doFacebookLogin", (NativeCallback)DoFacebookLogin));
            Firebase.Authentication.Facebook.FacebookService.Init();
        }

        static void Auth(string token)
        {
            var worker = _onAuth.Context == null ? null : _onAuth.Context.ThreadWorker;
            _onAuth.RaiseAsync(worker, token);
        }

        static void OnFailed(string err)
        {
            _onError.RaiseAsync(err);
        }

        object DoFacebookLogin(Context context, object[] args)
        {
            if defined(iOS || Android)
            {
                _facebookAuthentication.Login();
            }
            else{ }
            return null;
        }
    }

}