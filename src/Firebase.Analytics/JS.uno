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
            Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Analytics");

            Firebase.Core.Init();
            AddMember(new NativeFunction("logEvent", LogEvent));
        }

        static object LogEvent(Context context, object[] args)
        {
            var n = (string)args[0];
            var p = (Fuse.Scripting.Object)args[1];
            var keys = p.Keys;
            string[] objs = new string[keys.Length];
            for (int i=0; i < keys.Length; i++) {
                objs[i] = p[keys[i]].ToString();
            }
            AnalyticsService.LogEvent(n, keys, objs, keys.Length);
            return null;
        }
    }
}
