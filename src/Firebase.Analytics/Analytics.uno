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

    [ForeignInclude(Language.Java, "android.os.Bundle", "com.google.firebase.analytics.FirebaseAnalytics")]
    [Require("Cocoapods.Podfile.Target", "pod 'FirebaseAnalytics'")]
    extern(mobile)
    internal static class AnalyticsService
    {
        static bool _initialized;
        extern(android) static Java.Object _handle;

        public static void Init()
        {
            if (!_initialized)
            {
                Firebase.Core.Init();
                if defined(android) AndroidInit();
                _initialized = true;
            }
        }

        [Foreign(Language.Java)]
        extern(android)
        public static void AndroidInit()
        @{
            @{_handle:Set(FirebaseAnalytics.getInstance(com.fuse.Activity.getRootActivity()))};
        @}


        [Foreign(Language.Java)]
        extern(android)
        public static void LogIt(string message)
        @{
            Bundle bundle = new Bundle();
            String name = "wip";
            bundle.putString(FirebaseAnalytics.Param.ITEM_ID, "1");
            bundle.putString(FirebaseAnalytics.Param.ITEM_NAME, name);
            bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "cont");
            ((FirebaseAnalytics)@{_handle}).logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle);
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
