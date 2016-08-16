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
    public class EmailService : Firebase.Authentication.AuthProvider
    {
        static bool _initd = false;

        internal static void Init()
        {
            if (_initd) return;
            var es = new EmailService();
            Firebase.Authentication.AuthService.RegisterAuthProvider(es);
            _initd = true;
        }

        public override AuthProviderName Name { get { return AuthProviderName.Email; } }

        public override void Start() {}

        public override void SignOut() {}

        public override Promise<string> ReAuthenticate(string email, string password)
        {
            return new ReAuthenticate(email, password);
        }
    }

    extern(!mobile)
    internal class ReAuthenticate : Promise<string>
    {
        public ReAuthenticate(string email, string password) {}
        public void Reject(string reason) { }
    }

    extern(!mobile)
    internal class CreateUser : Promise<string>
    {
        public CreateUser(string email, string password) { }
        public void Reject(string reason) { }
    }

    extern(!mobile)
    internal class SignInUser : Promise<string>
    {
        public SignInUser(string email, string password) { }
        public void Reject(string reason) { }
    }

    extern(!mobile)
    internal class UpdatePassword : Promise<string>
    {
        public UpdatePassword(string password) {}
        void Reject(string reason) { Reject(new Exception(reason)); }
    }
}
