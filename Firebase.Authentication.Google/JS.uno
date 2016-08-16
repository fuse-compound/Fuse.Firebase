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

		public GoogleModule()
		{
			if(_instance != null) return;
			Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/Google");

            Firebase.Authentication.Google.GoogleService.Init();
		}
	}
}
