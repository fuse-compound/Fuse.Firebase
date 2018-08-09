#import <iOSFirebaseNotificationCallbacks.h>
#include <@{Firebase.Notifications.NotificationModule:Include}>
#include <@{ObjC.Object:Include}>
#include <uObjC.Foreign.h>
@{Firebase.Notifications.iOSImpl:IncludeDirective}

@implementation FireNotificationCallbacks : NSObject


- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    @{Firebase.Notifications.iOSImpl.OnNotificationRegistrationSucceeded(string):Call(fcmToken)};
}
- (void)messaging:(nonnull FIRMessaging *)messaging
    didReceiveMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{
}

@end
