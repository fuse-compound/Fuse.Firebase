package com.fuse.firebase.Notifications;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

public class PushNotificationIDService extends FirebaseInstanceIdService
{
    @Override
    public void onTokenRefresh()
    {
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        com.foreign.Firebase.Notifications.AndroidImpl.RegistrationIDUpdated(refreshedToken);
    }
}
