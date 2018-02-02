#import <iOSFirebaseNotificationCallbacks.h>
#include <@{Firebase.Notifications.NotificationModule:Include}>
#include <@{ObjC.Object:Include}>
#include <uObjC.Foreign.h>

@implementation FireNotificationCallbacks : NSObject


- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);

    @{Firebase.Notifications.NotificationModule.OnRegistrationSucceedediOS(string):Call(fcmToken)};
}

@end
