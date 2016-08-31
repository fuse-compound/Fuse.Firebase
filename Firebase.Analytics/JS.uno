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
using Firebase.Analytics;

namespace Firebase.Analytics.JS
{
	/**
	*/
	[UXGlobalModule]
	public sealed class AnalyticsModule : NativeModule
	{
		static readonly AnalyticsModule _instance;

		public AnalyticsModule()
		{
			if(_instance != null) return;
			Resource.SetGlobalKey(_instance = this, "Firebase/Analytics");

            AnalyticsService.Init();
            AddMember(new NativeFunction("logIt", LogIt));
		}

        static object LogIt(Context context, object[] args)
        {
            var message = (string)args[0];
            AnalyticsService.LogIt(message);
            return null;
        }
	}
}
