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
    internal class UpdateUser : Promise<string>
    {
        UpdateProfile _pendingProfile;
        UpdateEmail _pendingEmail;
        bool _emailSucceeded = true;
        bool _profileSucceeded = true;
        List<string> _failReasons = new List<string>();

        public UpdateUser(string displayName, string email, string photoUrl)
        {
            if (email != null)
            {
                _pendingEmail = new UpdateEmail(email);
                _pendingEmail.Then(EmailSuccess, EmailFailed);
            }

            if (displayName!=null || photoUrl!=null)
            {
                _pendingProfile = new UpdateProfile((displayName==null ? User.GetName(User.GetCurrent()) : displayName),
                                                    (photoUrl==null ? User.GetPhotoUrl(User.GetCurrent()) : photoUrl));
                _pendingProfile.Then(ProfileSuccess, ProfileFailed);
            }
        }

        void Continue()
        {
            if (_pendingProfile == null && _pendingEmail == null)
            {
                if (_emailSucceeded && _profileSucceeded)
                {
                    Resolve("succeeded");
                    return;
                }

                var message = "Update failed with the following issues:";

                Reject(new Exception(message));
            }
        }

        void EmailSuccess(string message)
        {
            _pendingEmail = null;
            Continue();
        }

        void EmailFailed(Exception e)
        {
            _pendingEmail = null;
            _emailSucceeded = false;
            Continue();
        }

        void ProfileSuccess(string message)
        {
            _pendingProfile = null;
            Continue();
        }

        void ProfileFailed(Exception e)
        {
            _pendingProfile = null;
            _profileSucceeded = false;
            Continue();
        }
    }
}
