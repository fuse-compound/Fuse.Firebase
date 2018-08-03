using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;

namespace Firebase.Authentication.Email.JS
{
    /**
    */
    [UXGlobalModule]
    public sealed class EmailModule : NativeModule
    {
        // static NativeEvent _onReceivedMessage;
        static readonly EmailModule _instance;

        public EmailModule()
        {
            if(_instance != null) return;
            Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Authentication/Email");

            Firebase.Authentication.Email.EmailService.Init();

            AddMember(new NativePromise<string, string>("createWithEmailAndPassword", CreateWithEmailAndPassword));
            AddMember(new NativePromise<string, string>("signInWithEmailAndPassword", SignInWithEmailAndPassword));
            AddMember(new NativePromise<string, string>("updateEmail", UpdateEmail));
            AddMember(new NativePromise<string, string>("updatePassword", UpdatePassword));
            AddMember(new NativePromise<string, string>("sendVerificationEmail", SendVerificationEmail));
            AddMember(new NativePromise<string, string>("sendPasswordResetEmail", SendPasswordResetEmail));
            
        }

        Future<string> CreateWithEmailAndPassword(object[] args)
        {
            var email = (string)args[0];
            var password = (string)args[1];
            return new Firebase.Authentication.Email.CreateUser(email, password);
        }

        Future<string> SignInWithEmailAndPassword(object[] args)
        {
            var email = (string)args[0];
            var password = (string)args[1];
            return new Firebase.Authentication.Email.SignInUser(email, password);
        }

        Future<string> UpdateEmail(object[] args)
        {
            var email = (string)args[0];
            return new Firebase.Authentication.Email.UpdateEmail(email);
        }

        Future<string> UpdatePassword(object[] args)
        {
            var password = (string)args[0];
            return new Firebase.Authentication.Email.UpdatePassword(password);
        }

        Future<string> SendVerificationEmail(object[] args)
        {
            return new Firebase.Authentication.Email.SendVerificationEmail();
        }

        Future<string> SendPasswordResetEmail(object[] args)
        {
            var email = (string)args[0];
            return new Firebase.Authentication.Email.SendPasswordResetEmail(email);
        }
        
    }
}
