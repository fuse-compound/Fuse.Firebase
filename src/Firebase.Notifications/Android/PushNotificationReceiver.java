package com.fuse.firebase.Notifications;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.support.v4.app.NotificationCompat;
import android.content.res.AssetManager;
import android.media.RingtoneManager;
import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Arrays;
import java.util.Map;
import java.util.Set;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import org.json.JSONObject;
import org.json.JSONException;

public class PushNotificationReceiver extends FirebaseMessagingService
{
    public static ArrayList<RemoteMessage> _cachedBundles = new ArrayList<RemoteMessage>();
    public static boolean InForeground = false;
    public static String ACTION = "fuseFirebaseBackgroundNotify";
    public static String EXTRA_KEY = "FirebaseRemoteNotification";
    static int _notificationID = -1;
    public static int nextID() { return _notificationID += 1; }
    private static Object lock = new Object();
    private static final Set<String> GOOGLE_KEYS =
        new HashSet<String>(Arrays.asList(new String[] {"google.collapse_key",
                                                        "google.from",
                                                        "google.message_id",
                                                        "google.message_type",
                                                        "google.sent_time",
                                                        "google.to",
                                                        "google.ttl",
                                                        "collapse_key"}));

    public static String ToJsonString(Intent newIntent)
    {
        Bundle map = newIntent.getExtras();
        JSONObject jmessage = new JSONObject();
        JSONObject data = new JSONObject();
        if (newIntent.getExtras() != null) {
            for (String key : newIntent.getExtras().keySet())
            {
                if (GOOGLE_KEYS.contains(key))
                {
                    try { jmessage.putOpt(key, map.getString(key)); } catch (Exception e) {}
                }
                else
                {
                    try
                    {
                        data.put(key, new JSONObject(map.getString(key)));
                    }
                    catch (Exception e)
                    {
                        String val = map.getString(key);
                        try { data.put(key, val); } catch (JSONException e1) {}
                    }
                }
            }
            if (data.length() > 0)
            {
                try { jmessage.putOpt("data", data); } catch (Exception e) {}
            }
        }
        return jmessage.toString();
    }

    public static String ToJsonString(RemoteMessage message)
    {
        Map<String,String> map = message.getData();
        JSONObject jmessage = new JSONObject();
        try { jmessage.putOpt("google.collapse_key", message.getCollapseKey()); } catch (Exception e) {}
        try { jmessage.putOpt("google.from", message.getFrom()); } catch (Exception e) {}
        try { jmessage.putOpt("google.message_id", message.getMessageId()); } catch (Exception e) {}
        try { jmessage.putOpt("google.message_type", message.getMessageType()); } catch (Exception e) {}
        try { jmessage.putOpt("google.sent_time", Long.toString(message.getSentTime())); } catch (Exception e) {}
        try { jmessage.putOpt("google.to", message.getTo()); } catch (Exception e) {}
        try { jmessage.putOpt("google.ttl", Long.toString(message.getTtl())); } catch (Exception e) {}

        // extract data
        JSONObject data = new JSONObject();
        for (String key : map.keySet())
        {
            try
            {
                data.put(key, new JSONObject(map.get(key)));
            }
            catch (Exception e)
            {
                String val = map.get(key);
                try
                {
                    data.put(key, val);
                }
                catch (JSONException e1)
                {
                    e1.printStackTrace();
                }
            }
        }
        if (map.keySet().size()>0)
        {
            try {
                jmessage.put("data", data);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        // extract notification
        RemoteMessage.Notification notif = message.getNotification();
        if (notif!=null)
        {
            JSONObject jnotif = new JSONObject();
            try { jnotif.putOpt("title", notif.getTitle()); } catch (Exception e) {}
            try { jnotif.putOpt("body", notif.getBody()); } catch (Exception e) {}
            try { jnotif.putOpt("icon", notif.getIcon()); } catch (Exception e) {}
            try { jnotif.putOpt("sound", notif.getSound()); } catch (Exception e) {}
            try { jnotif.putOpt("tag", notif.getTag()); } catch (Exception e) {}
            try { jnotif.putOpt("color", notif.getColor()); } catch (Exception e) {}
            try { jnotif.putOpt("click_action", notif.getClickAction()); } catch (Exception e) {}
            try { jnotif.putOpt("body_loc_key", notif.getBodyLocalizationKey()); } catch (Exception e) {}
            try { jnotif.putOpt("body_loc_args", notif.getBodyLocalizationArgs()); } catch (Exception e) {}
            try { jnotif.putOpt("title_loc_key", notif.getTitleLocalizationKey()); } catch (Exception e) {}
            try { jnotif.putOpt("title_loc_args", notif.getTitleLocalizationArgs()); } catch (Exception e) {}
            try {
                jmessage.put("notification", jnotif);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return jmessage.toString();
    }

    static void cacheBundle(RemoteMessage message)
    {
        PushNotificationReceiver._cachedBundles.add(message);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage)
    {
        synchronized (lock)
        {
            DoIt(remoteMessage);
        }
    }

    // OnNotificationRecieved(this, remoteMessage.getFrom(), data);
    // static void OnNotificationRecieved(Java.Object listener, String from, String data)
    public void DoIt(RemoteMessage remoteMessage)
    {
        Map<String,String> map = remoteMessage.getData();
        if (!PushNotificationReceiver.InForeground)
        {
            if (map.containsKey("title") || map.containsKey("body"))
            {
                SpitOutNotification(remoteMessage);
            }
            else
            {
                cacheBundle(remoteMessage);
            }
        }
        else
        {
            com.foreign.Firebase.Notifications.AndroidImpl.OnRecieve2(ToJsonString(remoteMessage), false);
        }
    }

    void SpitOutNotification(RemoteMessage remoteMessage)
    {
        Context context = this;
        int id = PushNotificationReceiver.nextID();
        Map<String,String> map = remoteMessage.getData();
        String title = map.get("title");
        String body = map.get("body");
        String sound = map.get("sound");
        String icon = map.get("icon");
        
        String jsonStr = ToJsonString(remoteMessage);
        Intent intent = new Intent(context, @(Activity.Package).@(Activity.Name).class); 

        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.setAction(PushNotificationReceiver.ACTION);
        intent.putExtra(PushNotificationReceiver.EXTRA_KEY, jsonStr);

        android.app.PendingIntent pendingIntent =
            android.app.PendingIntent.getActivity(context, 0, intent, android.app.PendingIntent.FLAG_UPDATE_CURRENT);
       
        NotificationManager  notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);

        String channel_name = "my_package_channel";
        String channel_id = "my_package_channel_1";
        String channel_description = "my_package_first_channel";

        int importance = NotificationManager.IMPORTANCE_HIGH;
        NotificationCompat.Builder notificationBuilder = null;
        if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
        {
            NotificationChannel mChannel = notificationManager.getNotificationChannel(channel_id);
            if (mChannel == null) 
            {
                mChannel = new NotificationChannel(channel_id, channel_name, importance);
                notificationManager.createNotificationChannel(mChannel);
            }
            // Android > 8 support for Channels because it not supported on previous versions
            notificationBuilder = new NotificationCompat.Builder(this, channel_id);
        }
        else{
            // Android < 7 Notification Builder init
            notificationBuilder = new NotificationCompat.Builder(this);
        }

        notificationBuilder = new NotificationCompat.Builder(context)
            .setSmallIcon(@(Activity.Package).R.mipmap.notif)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent);

        if (sound=="default")
        {
            android.net.Uri defaultSoundUri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            notificationBuilder.setSound(defaultSoundUri);
        }

        if (icon != null && !icon.isEmpty())
        {
            int iconResourceID = com.fuse.R.get(icon);
            if (iconResourceID!=-1)
            {
                android.graphics.Bitmap bm = android.graphics.BitmapFactory.decodeResource(context.getResources(), iconResourceID);
                notificationBuilder .setLargeIcon(bm);
            }
            else
            {
                String packageName = "@(Project.Name)";
                java.io.InputStream afs = com.fuse.firebase.BundleFiles.OpenBundledFile(context, packageName, icon);
                if (afs!=null)
                {
                    android.graphics.Bitmap bm = android.graphics.BitmapFactory.decodeStream(afs);
                    try
                    {
                       afs.close();
                    }
                    catch (IOException e)
                    {
                        Log.d("@(Project.Name)", "Could close the notification icon '" + icon);
                        e.printStackTrace();
                        return;
                    }
                    notificationBuilder .setLargeIcon(bm);
                }
                else
                {
                    Log.d("@(Project.Name)", "Could not the load icon '" + icon + "' as either a bundled file or android resource");
                }
            }
        }

        Notification n = notificationBuilder .build();
        if (sound!="")
            n.defaults |= Notification.DEFAULT_SOUND;
        n.defaults |= Notification.DEFAULT_LIGHTS;
        n.defaults |= Notification.DEFAULT_VIBRATE;

        notificationManager.notify(id, n);
    }
}
