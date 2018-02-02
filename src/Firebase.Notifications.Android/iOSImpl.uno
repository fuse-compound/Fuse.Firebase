using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Uno.Threading;

namespace Firebase.Notifications
{
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Messaging'")]
    [extern(iOS) Require("Source.Include", "iOSFirebaseNotificationCallbacks.h")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]

    public class iOSImpl
    {
        extern(ios) static internal ObjC.Object _iosDelegate;

        public iOSImpl() {
            Start();
        }

        extern(!iOS)
        public void Start() { }

        [Foreign(Language.ObjC)]
        extern(iOS)
        public void Start()
        @{
            FireNotificationCallbacks* fireCB = [[FireNotificationCallbacks alloc] init];
            @{_iosDelegate:Set(fireCB)};
            [FIRMessaging messaging].delegate = (id<FIRMessagingDelegate>)fireCB;
        @}
    }
}
