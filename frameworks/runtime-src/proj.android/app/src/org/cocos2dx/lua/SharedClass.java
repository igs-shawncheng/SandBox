//package org.cocos2dx.lua;
//
//import android.app.Activity;
//import android.content.Context;
//import android.content.Intent;
//
//
////import com.unity3d.player.IUnityPlayerSupport;
//import com.unity3d.player.UnityPlayer;
//
//public class SharedClass {
//
//    public static void showMainActivity(String setToColor) {
//        showMainActivity(UnityPlayer.currentActivity, setToColor);
//    }
//
//    public static void showMainActivity(Activity activity, String setToColor) {
//        Intent intent = new Intent((Context) activity, AppActivity.class);
//        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//        intent.putExtra("setColor", setToColor);
//        activity.startActivity(intent);
//    }
//}
