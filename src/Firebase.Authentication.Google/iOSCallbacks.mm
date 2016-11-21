#import <iOSCallbacks.h>
#include <GoogleSignIn/GoogleSignIn.h>
#include <@{Firebase.Authentication.Google.iOSGoogleButton:Include}>
#include <@{Firebase.Authentication.AuthService:Include}>
#include <@{Firebase.Authentication.Google.JS.GoogleModule:Include}>

#include <uObjC.Foreign.h>

@implementation FireGoogCallbacks : NSObject

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	if (error == nil) {
		GIDAuthentication* authentication = user.authentication;
		@{Firebase.Authentication.Google.JS.GoogleModule.Auth(string,string):Call(authentication.idToken,authentication.accessToken)};
	}
    @{Firebase.Authentication.Google.iOSGoogleButton.Callback(Uno.IntPtr,Uno.IntPtr):Call((@{Uno.IntPtr})user, (@{Uno.IntPtr})error)};
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    @{Firebase.Authentication.AuthService.SignedOut():Call()};
}


- (void) signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
// If implemented, this method will be invoked when sign in needs to
// display a view controller. The view controller should be displayed
// modally (via UIViewController's presentViewController method, and
// not pushed unto a navigation controller's stack.
    UIViewController* vc = (UIViewController*)[UIApplication sharedApplication].delegate;
    [vc presentViewController:viewController animated:YES completion:nil];
}

- (void) signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
// If implemented, this method will be invoked when sign in needs to
// dismiss a view controller. Typically, this should be implemented
// by calling dismissViewController on the passed view controller.
    UIViewController* vc = (UIViewController*)[UIApplication sharedApplication].delegate;
    [vc dismissViewControllerAnimated:YES completion: NULL ];
}

@end
