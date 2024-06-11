package org.cocos2dx.lua;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.unity3d.player.UnityPlayerForActivityOrService;

public class UnityActivityController{
    static boolean isUnityLoaded = false;

    protected UnityPlayerForActivityOrService mUnityPlayer; // don't change the name of this variable; referenced from native code

    // Override this in your custom UnityPlayerActivity to tweak the command line arguments passed to the Unity Android Player
    // The command line arguments are passed as a string, separated by spaces
    // UnityPlayerActivity calls this from 'onCreate'
    // Supported: -force-gles20, -force-gles30, -force-gles31, -force-gles31aep, -force-gles32, -force-gles, -force-vulkan
    // See https://docs.unity3d.com/Manual/CommandLineArguments.html
    // @param cmdLine the current command line arguments, may be null
    // @return the modified command line string or null
    protected String updateUnityCommandLineArguments(String cmdLine)
    {
        return cmdLine;
    }

    public static void loadUnity(Activity activity, String params){
        isUnityLoaded = true;
        Intent intent = new Intent(activity, getMainUnityGameActivityClass());
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        intent.putExtra("setParams", params);
        activity.startActivityForResult(intent, 1);
        Log.d("UnityActivityController", "loadUnity" + isUnityLoaded);
    }

    public static void unloadUnity(boolean doShowToast) {
        Log.d("UnityActivityController", "unloadUnity" + doShowToast);
//        if (isUnityLoaded) {
            Intent intent = new Intent(UnityPlayerForActivityOrService.currentActivity, getMainUnityGameActivityClass());

            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.putExtra("doQuit", true);
            UnityPlayerForActivityOrService.currentActivity.startActivity(intent);
            isUnityLoaded = false;
//        } else if (doShowToast) {
//            showToast(UnityPlayerForActivityOrService.currentActivity, "Show Unity First");
//        }
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
