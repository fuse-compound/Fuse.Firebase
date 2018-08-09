using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Uno.Threading;
using Uno.Graphics;
using Fuse.Platform;

namespace Firebase.Notifications
{
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Messaging'")]
    [extern(iOS) Require("Source.Include", "iOSFirebaseNotificationCallbacks.h")]
    [extern(iOS) Require("Source.Include", "Firebase/Firebase.h")]
    [Require("uContext.SourceFile.DidFinishLaunching", "[self application:[notification object] initializeFirebaseNotifications:[notification userInfo]];")]
    [Require("uContext.SourceFile.Declaration", "#include <iOS/AppDelegateFirebaseNotify.h>")]

    [Require("Entity", "Firebase.Notifications.iOSImpl.OnNotificationRegistrationSucceeded(string)")]
    [Require("Entity", "Firebase.Notifications.iOSImpl.OnNotificationRegistrationFailed(string)")]
    [Require("Entity", "Firebase.Notifications.iOSImpl.OnReceivedNotification(string,bool)")]

    extern(iOS)
    public class iOSImpl
    {

        public static event EventHandler<KeyValuePair<string,bool>> ReceivedNotification;
        public static event EventHandler<string> NotificationRegistrationFailed;
        public static event EventHandler<string> NotificationRegistrationSucceeded;
        static List<KeyValuePair<string,bool>> DelayedNotifications = new List<KeyValuePair<string,bool>>();
    
        static bool _init = false;
        extern(ios) static internal ObjC.Object _iosDelegate;
    
        public static void Init()
        {
            if (!_init)
            {
                if defined(iOS)
                {
                    iOSInit();
                    _init = true;
                }
            }
        }
      
        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void iOSInit()
        @{
            FireNotificationCallbacks* fireCB = [[FireNotificationCallbacks alloc] init];
            @{_iosDelegate:Set(fireCB)};
            [FIRMessaging messaging].delegate = (id<FIRMessagingDelegate>)fireCB;
        @}

        internal static void OnReceivedNotification(string notification, bool fromNotificationBar)
        {
            if (Lifecycle.State == ApplicationState.Foreground ||
                Lifecycle.State == ApplicationState.Interactive)
            {
                var handler = ReceivedNotification;
                if (handler != null)
                    handler(null, new KeyValuePair<string,bool>(notification, fromNotificationBar));
            }
            else
            {
                DelayedNotifications.Add(new KeyValuePair<string,bool>(notification, fromNotificationBar));
                Lifecycle.EnteringForeground += DispatchDelayedNotifications;
            }
        }
        private static void DispatchDelayedNotifications(ApplicationState state)
        {
            var handler = ReceivedNotification;
            if (handler != null)
                foreach (var n in DelayedNotifications)
                {
                    handler(null, n);
                }
            DelayedNotifications.Clear();
            Lifecycle.EnteringForeground -= DispatchDelayedNotifications;
        }

        static string DelayedReason = "";
        internal static void OnNotificationRegistrationFailed(string reason)
        {
            if (Lifecycle.State == ApplicationState.Foreground ||
                Lifecycle.State == ApplicationState.Interactive)
            {
                EventHandler<string> handler = NotificationRegistrationFailed;
                if (handler != null)
                    handler(null, reason);
            }
            else
            {
                DelayedReason = reason;
                Lifecycle.EnteringForeground += DispatchDelayedReason;
            }
        }
        private static void DispatchDelayedReason(ApplicationState state)
        {
            EventHandler<string> handler = NotificationRegistrationFailed;
            if (handler != null)
                handler(null, DelayedReason);
            DelayedReason = "";
            Lifecycle.EnteringForeground -= DispatchDelayedReason;
        }

        static string DelayedRegToken = "";
        internal static void OnNotificationRegistrationSucceeded(string regID)
        {
            if (Lifecycle.State == ApplicationState.Foreground ||
                Lifecycle.State == ApplicationState.Interactive)
            {
                EventHandler<string> handler = NotificationRegistrationSucceeded;
                if (handler != null)
                    handler(null, regID);
            }
            else
            {
                DelayedRegToken = regID;
                Lifecycle.EnteringForeground += DispatchDelayedRegToken;
            }
        }
        private static void DispatchDelayedRegToken(ApplicationState state)
        {
            EventHandler<string> handler = NotificationRegistrationSucceeded;
            if (handler != null)
                handler(null, DelayedRegToken);
            DelayedRegToken = "";
            Lifecycle.EnteringForeground -= DispatchDelayedRegToken;
        }

        [Foreign(Language.ObjC)]
        internal static void RegisterForPushNotifications()
        @{
            UIApplication* application = [UIApplication sharedApplication];
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // use registerUserNotificationSettings
                [application registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound  | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)  categories:nil]];
                [application registerForRemoteNotifications];
            } else {
                // use registerForRemoteNotificationTypes:
                [application registerForRemoteNotificationTypes:
                 UIRemoteNotificationTypeBadge |
                 UIRemoteNotificationTypeSound |
                 UIRemoteNotificationTypeAlert];
            }
        @}
    }
}
