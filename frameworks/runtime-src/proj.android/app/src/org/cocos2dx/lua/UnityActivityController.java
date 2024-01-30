package org.cocos2dx.lua;

import android.app.Activity;
import android.content.Intent;
import android.widget.Toast;

public class UnityActivityController{
    static boolean isUnityLoaded = false;

    public static void loadUnity(Activity activity){
        isUnityLoaded = true;
        Intent intent = new Intent(activity, getMainUnityGameActivityClass());
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        activity.startActivityForResult(intent, 1);
    }

    public static void unloadUnity(Activity activity, Boolean doShowToast) {
        if (isUnityLoaded) {
            Intent intent = new Intent(activity, getMainUnityGameActivityClass());

            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.putExtra("doQuit", true);
            activity.startActivity(intent);
            isUnityLoaded = false;
        } else if (doShowToast) {
            showToast(activity, "Show Unity First");
        }
    }

    private static void showToast(Activity activity, String message) {
        CharSequence text = message;
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(activity.getApplicationContext(), text, duration);
        toast.show();
    }

    private static Class getMainUnityGameActivityClass() {
        return findClassUsingReflection("org.cocos2dx.lua.MainUnityActivity");
    }

    private static Class findClassUsingReflection(String className) {
        try {
            return Class.forName(className);
        } catch (final ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
}
