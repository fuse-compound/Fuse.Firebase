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

		public FacebookModule()
		{
			if(_instance != null) return;
			Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/Facebook");

            Firebase.Authentication.Facebook.FacebookService.Init();
		}
	}

}
