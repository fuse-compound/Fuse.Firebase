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

        [Foreign(Language.Java)]
        extern(android)
        public static void LogEvent(string name, string[] keys, string[] vals, int len)
        @{
            @{_handle:Set(FirebaseAnalytics.getInstance(com.fuse.Activity.getRootActivity()))};
            Bundle bundle = new Bundle();

            for (int i = 0; i < len; i++) {
                bundle.putString(keys.get(i), vals.get(i));
            }
            ((FirebaseAnalytics)@{_handle}).logEvent(name, bundle);
        @}


        [Require("Source.Import","FirebaseAnalytics/FirebaseAnalytics.h")]
        [Require("Xcode.Framework", "AdSupport.framework")]
        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void LogEvent(string name, string[] keys, string[] vals, int len)
        @{
            NSDictionary *param = [NSDictionary dictionaryWithObjects:[vals copyArray] forKeys:[keys copyArray]];
            [FIRAnalytics logEventWithName:name parameters:param];
        @}
    }

    extern(!mobile)
    internal static class AnalyticsService
    {
        public static void Init() {}
        public static void LogEvent(string name, string[] keys, string[] vals, int len) {
            debug_log "LogEvent: " + name;
        }
    }
}
