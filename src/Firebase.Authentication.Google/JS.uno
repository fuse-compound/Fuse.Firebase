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

namespace Firebase.Authentication.Google.JS
{
    /**
    */
    [UXGlobalModule]
    public sealed class GoogleModule : NativeModule
    {
        static readonly GoogleModule _instance;
        static NativeEvent _onAuth;

        public GoogleModule()
        {
            if(_instance != null) return;
            Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/Google");

            _onAuth = new NativeEvent("onAuth");
            AddMember(_onAuth);
            Firebase.Authentication.Google.GoogleService.Init();
        }

        static void Auth(string idToken, string accessToken)
        {
            var worker = _onAuth.Context == null ? null : _onAuth.Context.ThreadWorker;
            _onAuth.RaiseAsync(worker, idToken, accessToken);
        }
    }
}
