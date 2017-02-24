#import <iOSFacebookCallbacks.h>
#include <FBSDKLoginKit/FBSDKLoginKit.h>
#include <@{Firebase.Authentication.Facebook.iOSFacebookButton:Include}>
#include <@{ObjC.Object:Include}>

@implementation FireFacebookCallbacks : NSObject

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    @{Firebase.Authentication.Facebook.iOSFacebookButton.OnFBAuth(ObjC.Object):Call(error)};
}
- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}

@end
