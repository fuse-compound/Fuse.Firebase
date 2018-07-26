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
using Firebase.Authentication;

namespace Firebase.Authentication.Email
{
    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    extern(iOS)
    class CreateUser : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public CreateUser(string email, string password)
        @{
           [[FIRAuth auth]
            createUserWithEmail:email
            password:password
            completion:^(FIRAuthDataResult * _Nullable authResult, NSError* error) {
                if (error)
                    @{CreateUser:Of(_this).Reject(int):Call(error.code)};
                else
                    @{CreateUser:Of(_this).Resolve(string):Call(@"success")};
            }];
        @}

        void Resolve(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Email);
            base.Resolve(message);
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.CreateUserWithEmailBaseErrorMessage(errorCode)));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    extern(iOS)
    class SignInUser : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public SignInUser(string email, string password)
        @{
           [[FIRAuth auth]
            signInWithEmail:email
            password:password
            completion:^(FIRAuthDataResult * _Nullable authResult, NSError* error) {
                if (error)
                    @{SignInUser:Of(_this).Reject(int):Call(error.code)};
                else
                    @{SignInUser:Of(_this).Resolve(string):Call(@"success")};
            }];
        @}

        void Resolve(string message)
        {
            AuthService.AnnounceSignIn(AuthProviderName.Email);
            base.Resolve(message);
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.SignInWithEmailBaseErrorMessage(errorCode)));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    [Require("Source.Include", "@{Firebase.Authentication.User:Include}")]
    extern(iOS)
    class ReAuthenticate : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public ReAuthenticate(string email, string password)
        @{
            if (email == NULL && password == NULL)
            {
                @{ReAuthenticate:Of(_this).Reject(string):Call(@"ReAuthenticate requires that at least one of email or password are provided")};
                return;
            }

            FIRUser* user = (FIRUser*)@{User.GetCurrent():Call()};

            FIRAuthCredential *credential =
                [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];

            [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
              if (error)
                  @{ReAuthenticate:Of(_this).Reject(int):Call(error.code)};
              else
                  @{ReAuthenticate:Of(_this).Resolve(string):Call(@"success")};
            }];

        @}

        void Reject(string reason)
        {
            Reject(new Exception(reason));
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.SignInWithEmailBaseErrorMessage(errorCode)));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    [Require("Source.Include", "@{Firebase.Authentication.User:Include}")]
    extern(iOS)
    internal class UpdateEmail : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public UpdateEmail(string email)
        @{
            [[FIRAuth auth].currentUser updateEmail:email completion:^(NSError *_Nullable error) {
                if (error)
                    @{UpdateEmail:Of(_this).Reject(int):Call(error.code)};
                else
                    @{UpdateEmail:Of(_this).Resolve(string):Call(@"Success")};
            }];
        @}

        void Reject(string reason)
        {
            Reject(new Exception(reason));
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.SignInWithEmailBaseErrorMessage(errorCode)));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    [Require("Source.Include", "@{Firebase.Authentication.User:Include}")]
    extern(iOS)
    internal class UpdatePassword : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public UpdatePassword(string password)
        @{
            [[FIRAuth auth].currentUser updatePassword:password completion:^(NSError *_Nullable error) {
                if (error)
                    @{UpdatePassword:Of(_this).Reject(int):Call(error.code)};
                else
                    @{UpdatePassword:Of(_this).Resolve(string):Call(@"Success")};
            }];
        @}

        void Reject(string reason)
        {
            Reject(new Exception(reason));
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.SignInWithEmailBaseErrorMessage(errorCode)));
        }
    }

    [Require("Source.Include", "Firebase/Firebase.h")]
    [Require("Source.Include", "FirebaseAuth/FirebaseAuth.h")]
    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/Auth'")]
    [Require("Source.Include", "@{Firebase.Authentication.User:Include}")]
    extern(iOS)
    internal class SendVerificationEmail : Promise<string>
    {
        [Foreign(Language.ObjC)]
        public SendVerificationEmail()
        @{
            [[FIRAuth auth].currentUser sendEmailVerificationWithCompletion:^(NSError *_Nullable error) {
                if (error)
                    @{SendVerificationEmail:Of(_this).Reject(int):Call(error.code)};
                else
                    @{SendVerificationEmail:Of(_this).Resolve(string):Call(@"Success")};
            }];
        @}

        void Reject(string reason)
        {
            Reject(new Exception(reason));
        }

        void Reject(int errorCode)
        {
            Reject(new Exception(Errors.SignInWithEmailBaseErrorMessage(errorCode)));
        }
    }
}
