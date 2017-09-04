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

namespace Firebase.Authentication
{
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal static class User
    {
        [Foreign(Language.ObjC)]
        internal static ObjC.Object GetCurrent()
        @{
            return [FIRAuth auth].currentUser;
        @}

        [Foreign(Language.ObjC)]
        internal static string GetUid(ObjC.Object obj)
        @{
            FIRUser* user = [FIRAuth auth].currentUser;
            NSString* name = user.uid;
            return name;
        @}

        [Foreign(Language.ObjC)]
        internal static string GetName(ObjC.Object obj)
        @{
            FIRUser* user = [FIRAuth auth].currentUser;
            NSString* name = user.displayName;
            return name;
        @}

        [Foreign(Language.ObjC)]
        internal static string GetEmail(ObjC.Object obj)
        @{
            FIRUser* user = [FIRAuth auth].currentUser;
            NSString* email = user.email;
            return email;
        @}

        [Foreign(Language.ObjC)]
        internal static string GetPhotoUrl(ObjC.Object obj)
        @{
            FIRUser* user = [FIRAuth auth].currentUser;
            NSURL* photoUrl = user.photoURL;
            return (photoUrl==NULL) ? NULL : photoUrl.absoluteString;
        @}
    }


    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal class GetToken : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public GetToken()
        @{
            NSLog(@"We are in obj-c trying to get token");
            FIRUser* user = [FIRAuth auth].currentUser;
            [user getTokenWithCompletion: ^(NSString *_Nullable token, NSError *_Nullable error) {
                    NSLog(@"%@", token);
                if (error) {
                    @{GetToken:Of(_this).Reject(string):Call(@"failed getting token for user")};
                } else {
                    @{GetToken:Of(_this).Resolve(string):Call(token)};
                }
            }];
        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal class UpdateProfile : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public UpdateProfile(string displayName, string photoUri)
        @{
            if (displayName == NULL && photoUri == NULL)
            {
                @{UpdateProfile:Of(_this).Reject(string):Call(@"UpdateProfile requires that at least one of displayName or photoUri are provided")};
                return;
            }

            FIRUser* user = (FIRUser*)[FIRAuth auth].currentUser;

            FIRUserProfileChangeRequest* changeRequest = [user profileChangeRequest];
            if (displayName!=NULL)
                changeRequest.displayName = displayName;
            if (photoUri!=NULL)
                changeRequest.photoURL = [NSURL URLWithString:photoUri];

            [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
              if (error) {
                  @{UpdateProfile:Of(_this).Reject(string):Call(@"failed")};
              } else {
                  @{UpdateProfile:Of(_this).Resolve(string):Call(@"success")};
              }
            }];
        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal class UpdateEmail : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public UpdateEmail(string email)
        @{
            if (email == NULL)
            {
                @{UpdateEmail:Of(_this).Reject(string):Call(@"UpdateEmail requires that an email address is provided")};
                return;
            }

            FIRUser* user = (FIRUser*)[FIRAuth auth].currentUser;

            [user updateEmail:email completion:^(NSError *_Nullable error) {
            if (error) {
                @{UpdateEmail:Of(_this).Reject(string):Call(@"failed")};
            } else {
                @{UpdateEmail:Of(_this).Resolve(string):Call(@"success")};
            }
            }];
        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal class DeleteUser : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public DeleteUser()
        @{
            FIRUser* user = (FIRUser*)[FIRAuth auth].currentUser;

            [user deleteWithCompletion:^(NSError *_Nullable error) {
            if (error) {
                @{DeleteUser:Of(_this).Reject(string):Call(@"failed")};
            } else {
                NSString* message = [NSString stringWithFormat:@"User with email %@ deleted", user.email];
                @{DeleteUser:Of(_this).Resolve(string):Call(message)};
            }
            }];

        @}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }

    // Helpers for generating meaningful error messages for given operations
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    extern(iOS)
    internal static class Errors
    {
        public static int FIRAuthErrorCodeCredentialAlreadyInUse;
        public static int FIRAuthErrorCodeCustomTokenMismatch;
        public static int FIRAuthErrorCodeEmailAlreadyInUse;
        public static int FIRAuthErrorCodeInvalidCredential;
        public static int FIRAuthErrorCodeInvalidCustomToken;
        public static int FIRAuthErrorCodeInvalidEmail;
        public static int FIRAuthErrorCodeInvalidUserToken;
        public static int FIRAuthErrorCodeKeychainError;
        public static int FIRAuthErrorCodeNoSuchProvider;
        public static int FIRAuthErrorCodeOperationNotAllowed;
        public static int FIRAuthErrorCodeProviderAlreadyLinked;
        public static int FIRAuthErrorCodeRequiresRecentLogin;
        public static int FIRAuthErrorCodeUserDisabled;
        public static int FIRAuthErrorCodeUserMismatch;
        public static int FIRAuthErrorCodeUserNotFound;
        public static int FIRAuthErrorCodeWeakPassword;
        public static int FIRAuthErrorCodeWrongPassword;
        public static int FIRAuthErrorCodeNetworkError;
        public static int FIRAuthErrorCodeUserTokenExpired;
        public static int FIRAuthErrorCodeTooManyRequests;
        public static int FIRAuthErrorCodeInvalidAPIKey;
        public static int FIRAuthErrorCodeAppNotAuthorized;
        public static int FIRAuthErrorCodeInternalError;

        [Foreign(Language.ObjC)]
        static Errors()
        @{
            @{FIRAuthErrorCodeCredentialAlreadyInUse:Set(FIRAuthErrorCodeCredentialAlreadyInUse)};
            @{FIRAuthErrorCodeCustomTokenMismatch:Set(FIRAuthErrorCodeCustomTokenMismatch)};
            @{FIRAuthErrorCodeEmailAlreadyInUse:Set(FIRAuthErrorCodeEmailAlreadyInUse)};
            @{FIRAuthErrorCodeInvalidCredential:Set(FIRAuthErrorCodeInvalidCredential)};
            @{FIRAuthErrorCodeInvalidCustomToken:Set(FIRAuthErrorCodeInvalidCustomToken)};
            @{FIRAuthErrorCodeInvalidEmail:Set(FIRAuthErrorCodeInvalidEmail)};
            @{FIRAuthErrorCodeInvalidUserToken:Set(FIRAuthErrorCodeInvalidUserToken)};
            @{FIRAuthErrorCodeKeychainError:Set(FIRAuthErrorCodeKeychainError)};
            @{FIRAuthErrorCodeNoSuchProvider:Set(FIRAuthErrorCodeNoSuchProvider)};
            @{FIRAuthErrorCodeOperationNotAllowed:Set(FIRAuthErrorCodeOperationNotAllowed)};
            @{FIRAuthErrorCodeProviderAlreadyLinked:Set(FIRAuthErrorCodeProviderAlreadyLinked)};
            @{FIRAuthErrorCodeRequiresRecentLogin:Set(FIRAuthErrorCodeRequiresRecentLogin)};
            @{FIRAuthErrorCodeUserDisabled:Set(FIRAuthErrorCodeUserDisabled)};
            @{FIRAuthErrorCodeUserMismatch:Set(FIRAuthErrorCodeUserMismatch)};
            @{FIRAuthErrorCodeUserNotFound:Set(FIRAuthErrorCodeUserNotFound)};
            @{FIRAuthErrorCodeWeakPassword:Set(FIRAuthErrorCodeWeakPassword)};
            @{FIRAuthErrorCodeWrongPassword:Set(FIRAuthErrorCodeWrongPassword)};
            @{FIRAuthErrorCodeNetworkError:Set(FIRAuthErrorCodeNetworkError)};
            @{FIRAuthErrorCodeUserTokenExpired:Set(FIRAuthErrorCodeUserTokenExpired)};
            @{FIRAuthErrorCodeTooManyRequests:Set(FIRAuthErrorCodeTooManyRequests)};
            @{FIRAuthErrorCodeInvalidAPIKey:Set(FIRAuthErrorCodeInvalidAPIKey)};
            @{FIRAuthErrorCodeAppNotAuthorized:Set(FIRAuthErrorCodeAppNotAuthorized)};
            @{FIRAuthErrorCodeInternalError:Set(FIRAuthErrorCodeInternalError)};
        @}

        [Foreign(Language.ObjC)]
        public static void ForceMM()
        @{
            // This is a cludge to work around a bug. Foreign static constructors are not causing the
            // resulting file to be .mm, this causes build issues so this is just here until that is
            // fixed. Sorry about the ugly
        @}

        public static string CommonBaseErrorMessage(int errorCode)
        {
            ForceMM();
            if (errorCode == FIRAuthErrorCodeNetworkError)
                return "A network error occurred during the operation.";
            if (errorCode == FIRAuthErrorCodeUserNotFound)
                return "The user account was not found. This could happen if the user account has been deleted.";
            if (errorCode == FIRAuthErrorCodeUserTokenExpired)
                return "The current user’s token has expired, for example, the user may have changed account password on another device. You must prompt the user to sign in again on this device.";
            if (errorCode == FIRAuthErrorCodeTooManyRequests)
                return "The request has been blocked after an abnormal number of requests have been made from the caller device to the Firebase Authentication servers. Retry again after some time.";
            if (errorCode == FIRAuthErrorCodeInvalidAPIKey)
                return "The application has been configured with an invalid API key.";
            if (errorCode == FIRAuthErrorCodeAppNotAuthorized)
                return "The App is not authorized to use Firebase Authentication with the provided API Key. go to the Google API Console and check under the credentials tab that the API key you are using has your application’s bundle ID whitelisted.";
            if (errorCode == FIRAuthErrorCodeKeychainError)
                return "An error occurred when accessing the keychain. The NSLocalizedFailureReasonErrorKey and NSUnderlyingErrorKey fields in the NSError.userInfo dictionary will contain more information about the error encountered.";
            if (errorCode == FIRAuthErrorCodeInternalError)
                return "An internal error occurred. Please report the error with the entire NSError object.";

            return null;
        }

        public static string FetchProvidersForEmailBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;
            if (errorCode==FIRAuthErrorCodeInvalidEmail)
                return "The email address is malformed";
            return null;
        }

        public static string SignInWithEmailBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.";
            if (errorCode == FIRAuthErrorCodeUserDisabled)
                return "The user's account is disabled.";
            if (errorCode == FIRAuthErrorCodeWrongPassword)
                return "The user attempted sign in with a wrong password.";

            return null;
        }

        public static string SignInWithCredentialBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeInvalidCredential)
                return "Indicates the supplied credential is invalid. This could happen if it has expired or it is malformed.";
            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Indicates that accounts with the identity provider represented by the credential are not enabled. Enable them in the Auth section of the Firebase console.";
            if (errorCode == FIRAuthErrorCodeEmailAlreadyInUse)
                return "Indicates the email asserted by the credential (e.g. the email in a Facebook access token) is already in use by an existing account, that cannot be authenticated with this sign-in method. Call fetchProvidersForEmail for this user’s email and then prompt them to sign in with any of the sign-in providers returned. This error will only be thrown if the \"One account per email address\" setting is enabled in the Firebase console, under Authentication settings.";
            if (errorCode == FIRAuthErrorCodeUserDisabled)
                return "Indicates the user's account is disabled.";
            if (errorCode == FIRAuthErrorCodeWrongPassword)
                return "Indicates the user attempted sign in with a wrong password, if credential is of the type EmailPasswordAuthCredential.";

            return null;
        }

        public static string SignInAnonymouslyBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;
            if (errorCode==FIRAuthErrorCodeOperationNotAllowed)
                return "Anonymous accounts are not enabled. Enable them in the Auth section of the Firebase console";
            return null;
        }

        public static string SignInWithCustomTokenBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeInvalidCustomToken)
                return "Indicates a validation error with the custom token.";
            if (errorCode == FIRAuthErrorCodeCustomTokenMismatch)
                return "Indicates the service account and the API key belong to different projects.";

            return null;
        }

        public static string CreateUserWithEmailBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeInvalidEmail)
                return "Indicates the email address is malformed.";
            if (errorCode == FIRAuthErrorCodeEmailAlreadyInUse)
                return "Indicates the email used to attempt sign up already exists. Call fetchProvidersForEmail to check which sign-in mechanisms such user used, and prompt the user to sign in with one of those.";
            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Indicates that email and password accounts are not enabled. Enable them in the Authentication section of the Firebase console.";
            if (errorCode == FIRAuthErrorCodeWeakPassword)
                return "Indicates an attempt to set a password that is considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo dictionary object will contain more detailed explanation that can be shown to the user.";

            return null;
        }

        public static string SignOutBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;
            if (errorCode==FIRAuthErrorCodeKeychainError)
                return "An error occurred when accessing the keychain. The NSLocalizedFailureReasonErrorKey and NSUnderlyingErrorKey fields in the NSError.userInfo dictionary will contain more information about the error encountered.";
            return null;
        }

        public static string FIRUserBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeInvalidUserToken)
                return "The signed-in user's refresh token, that holds session information, is invalid. You must prompt the user to sign in again on this device.";
            if (errorCode == FIRAuthErrorCodeUserDisabled)
                return "The user's account is disabled and can no longer be used until enabled again from within the Users panel in the Firebase console.";

            return null;
        }

        public static string ReauthenticateWithCredentialBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeInvalidCredential)
                return "Indicates the supplied credential is invalid. This could happen if it has expired or it is malformed.";
            if (errorCode == FIRAuthErrorCodeWrongPassword)
                return "Indicates the user attempted reauthentication with an incorrect password, if credential is of the type EmailPasswordAuthCredential.";
            if (errorCode == FIRAuthErrorCodeUserMismatch)
                return "Indicates that an attempt was made to reauthenticate with a user which is not the current user.";
            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Indicates that accounts with the identity provider represented by the credential are not enabled. Enable them in the Auth section of the Firebase console.";
            if (errorCode == FIRAuthErrorCodeEmailAlreadyInUse)
                return "Indicates the email asserted by the credential (e.g. the email in a Facebook access token) is already in use by an existing account, that cannot be reauthenticated with this sign-in method. Call fetchProvidersForEmail for this user’s email and then prompt them to sign in with any of the sign-in providers returned. This error will only be thrown if the \"One account per email address\" setting is enabled in the Firebase console, under Authentication settings.";
            if (errorCode == FIRAuthErrorCodeUserDisabled)
                return "Indicates the user's account is disabled.";

            return null;
        }

        public static string updateEmailBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeEmailAlreadyInUse)
                return "Indicates the email is already in use by another account.";
            if (errorCode == FIRAuthErrorCodeInvalidEmail)
                return "Indicates the email address is malformed.";
            if (errorCode == FIRAuthErrorCodeRequiresRecentLogin)
                return "Updating a user’s email is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.";

            return null;
        }

        public static string updatePasswordBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Indicates the administrator disabled sign in with the specified identity provider.";
            if (errorCode == FIRAuthErrorCodeRequiresRecentLogin)
                return "Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.";
            if (errorCode == FIRAuthErrorCodeWeakPassword)
                return "Indicates an attempt to set a password that is considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo dictionary object will contain more detailed explanation that can be shown to the user.";

            return null;
        }

        public static string linkWithCredentialBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeProviderAlreadyLinked)
                return "Indicates an attempt to link a provider of a type already linked to this account.";
            if (errorCode == FIRAuthErrorCodeCredentialAlreadyInUse)
                return "Indicates an attempt to link with a credential that has already been linked with a different Firebase account.";
            if (errorCode == FIRAuthErrorCodeOperationNotAllowed)
                return "Indicates that accounts with the identity provider represented by the credential are not enabled. Enable them in the Auth section of the Firebase console.";

            return null;
        }

        public static string unlinkFromProviderBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;

            if (errorCode == FIRAuthErrorCodeNoSuchProvider)
                return "Indicates an attempt to unlink a provider that is not linked to the account.";
            if (errorCode == FIRAuthErrorCodeRequiresRecentLogin)
                return "Updating email is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.";

            return null;
        }

        public static string sendEmailVerificationWithCompletionBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;
            if (errorCode==FIRAuthErrorCodeUserNotFound)
                return "Indicates the user account was not found.";
            return null;
        }

        public static string deleteWithCompletionBaseErrorMessage(int errorCode)
        {
            var common = CommonBaseErrorMessage(errorCode);
            if (common!=null) return common;
            if (errorCode==FIRAuthErrorCodeRequiresRecentLogin)
                return "Updating email is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.";
            return null;
        }
    }
}
