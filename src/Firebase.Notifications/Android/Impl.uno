using Uno;
using Uno.Graphics;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers;
using Fuse.Resources;

using Fuse.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Compiler.ExportTargetInterop.Android;

namespace Firebase.Notifications
{
    [ForeignInclude(Language.Java,
                    "java.io.IOException",
                    "android.app.Activity",
                    "android.content.Intent",
                    "android.os.AsyncTask",
                    "android.content.res.Resources",
                    "android.content.res.AssetManager",
                    "android.content.res.AssetFileDescriptor",
                    "android.os.Bundle",
                    "com.fuse.firebase.Notifications.PushNotificationReceiver",
                    "com.google.firebase.messaging.RemoteMessage")]
    [Require("Gradle.Dependency.Compile", "com.google.firebase:firebase-messaging:12.0.1")]
    extern(Android)
    internal class AndroidImpl
    {
        public static event EventHandler<string> RegistrationSucceeded;
        public static event EventHandler<string> RegistrationFailed;
        public static event EventHandler<KeyValuePair<string,bool>> ReceivedNotification;

        static bool _init = false;
        static List<string> _cachedMessages = new List<string>();

        internal static void Init()
        {
            if (!_init)
            {
                JInit();
                _init = true;
                Lifecycle.EnteringInteractive += OnEnteringInteractive;
                Lifecycle.ExitedInteractive += OnExitedInteractive;
            }
        }

        [Foreign(Language.Java)]
        static void JInit()
        @{
            // Set up vars and hook into fuse intent listeners
            com.fuse.Activity.subscribeToIntents(
                new com.fuse.Activity.IntentListener() {
                    public void onIntent (Intent newIntent) {
                        String jsonStr = com.fuse.firebase.Notifications.PushNotificationReceiver.ToJsonString(newIntent);
                        if( jsonStr != "{}")
                        {
                            @{OnRecieve(string,bool):Call(jsonStr, false)};
                        }
                    }
                },
                "android.intent.action.MAIN");
            String id = com.google.firebase.iid.FirebaseInstanceId.getInstance().getToken();
            @{getRegistrationIdSuccess(string):Call(id)};
        @}


        [Foreign(Language.Java), ForeignFixedName]
        static void RegistrationIDUpdated(string regid)
        @{
            @{getRegistrationIdSuccess(string):Call(regid)};
        @}

        static void getRegistrationIdSuccess(string regid)
        {
            var x = RegistrationSucceeded;
            if (x!=null)
                x(null, regid);
        }

        static void getRegistrationIdError(string message)
        {
            var x = RegistrationFailed;
            if (x!=null)
                x(null, message);
        }

        //----------------------------------------------------------------------

        static void OnEnteringInteractive(ApplicationState newState)
        {
            NoteInteractivity(true);
            var x = ReceivedNotification;
            if (x!=null)
            {
                foreach (var message in _cachedMessages)
                    x(null, new KeyValuePair<string,bool>(message, true));
            }
            _cachedMessages.Clear();
        }


        static void OnExitedInteractive(ApplicationState newState)
        {
            NoteInteractivity(false);
        }

        //----------------------------------------------------------------------

        [Foreign(Language.Java), ForeignFixedName]
        static void OnRecieve2(string message, bool fromNotificationBar)
        @{
            @{OnRecieve(string,bool):Call(message, fromNotificationBar)};
        @}

        static void OnRecieve(string message, bool fromNotificationBar)
        {
            if (Lifecycle.State == ApplicationState.Interactive)
            {
                var x = ReceivedNotification;
                if (x!=null)
                    x(null, new KeyValuePair<string,bool>(message, fromNotificationBar));
            }
            else
            {
                _cachedMessages.Add(message);
            }
        }

        //----------------------------------------------------------------------

        [Foreign(Language.Java)]
        static void NoteInteractivity(bool isItInteractive)
        @{
            PushNotificationReceiver.InForeground = isItInteractive;
            java.util.ArrayList<RemoteMessage> maps = PushNotificationReceiver._cachedBundles;
            if (isItInteractive && maps!=null && maps.size()>0) {
                for (RemoteMessage remoteMessage : maps)
                    @{OnRecieve(string,bool):Call(PushNotificationReceiver.ToJsonString(remoteMessage), true)};
                maps.clear();
            }
        @}
    }
}
