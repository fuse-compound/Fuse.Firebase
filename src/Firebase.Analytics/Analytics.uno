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

namespace Firebase.Analytics
{

    // Only need ios here as android is included in core
    [Require("Cocoapods.Podfile.Target", "pod 'FirebaseAnalytics'")]
    extern(mobile)
    internal static class AnalyticsService
    {
        static AnalyticsService Inst;

        public static void Init()
        {
            if (Inst == null)
            {
                Firebase.Core.Init();
            }
        }

        [Foreign(Language.Java)]
        extern(android)
        public static void LogIt(string message)
        @{
        @}


        [Require("Source.Import","FirebaseAnalytics/FIRApp.h")]
        [Require("Source.Import","FirebaseAnalytics/FirebaseAnalytics.h")]
        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void LogIt(string message)
        @{
            [FIRAnalytics logEventWithName:kFIREventSelectContent parameters:@{
                kFIRParameterContentType:@"cont", kFIRParameterItemID:@"1"}];
        @}
	}
}
