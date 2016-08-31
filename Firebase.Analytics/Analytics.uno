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

namespace Firebase.Analytic
{

    // Only need ios here as android is included in core
    [Require("Cocoapods.Podfile.Target", "pod 'FirebaseAnalytics'")]
    extern(mobile)
    internal static class AnalyticsService
    {
        static public void Init()
        {
            if (Inst == null)
            {
                Firebase.Core.Init();
            }
        }

        [Foreign(Language.Java)]
        extern(android)
        internal static void LogIt()
        @{
        @}


        [Foreign(Language.ObjC)]
        extern(iOS)
        internal static void LogIt()
        @{
        @}
	}
}
