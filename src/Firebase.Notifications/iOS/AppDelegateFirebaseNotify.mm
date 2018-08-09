#include <Uno/Uno.h>
#include <uObjC.String.h>
#include "AppDelegateFirebaseNotify.h"
@{Fuse.Platform.Lifecycle:IncludeDirective}
@{Firebase.Notifications.iOSImpl:IncludeDirective}

@implementation uContext (FirebaseNotify)

- (void)application:(UIApplication *)application initializeFirebaseNotifications:(NSDictionary *)launchOptions {
	if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
		[self application:application dispatchPushNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] fromBar:YES];
	}
#if (!@(Project.iOS.PushNotifications.RegisterOnLaunch:IsSet)) || @(Project.iOS.PushNotifications.RegisterOnLaunch:Or(0))
	@{Firebase.Notifications.iOSImpl.RegisterForPushNotifications():Call()};
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	uAutoReleasePool pool;
	@{Fuse.Platform.ApplicationState} state = @{Fuse.Platform.Lifecycle.State:Get()};
	bool fromNotifBar = application.applicationState != UIApplicationStateActive;
	[self application:application dispatchPushNotification:userInfo fromBar:fromNotifBar];
}

- (void)application:(UIApplication *)application dispatchPushNotification:(NSDictionary *)userInfo fromBar:(BOOL)fromBar {
	uAutoReleasePool pool;
	NSError* err = NULL;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&err];
	if (jsonData)
	{
		NSString* nsJsonPayload = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		@{Firebase.Notifications.iOSImpl.OnReceivedNotification(string, bool):Call(nsJsonPayload, fromBar)};
	}
}

@end
