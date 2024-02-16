/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2016 Chukong Technologies Inc.
Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.app.FragmentManager;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.nfc.Tag;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.AndroidException;
import android.util.Log;
import android.view.ViewGroup;

import com.unity3d.player.IUnityPlayerLifecycleEvents;
import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerForActivityOrService;

import org.cocos2dx.lib.Cocos2dxActivity;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.logging.Logger;

public class AppActivity extends Cocos2dxActivity implements IUnityPlayerLifecycleEvents {

    private static AppActivity appActivety = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.setEnableVirtualButton(false);
        super.onCreate(savedInstanceState);

        // Workaround in https://stackoverflow.com/questions/16283079/re-launch-of-activity-on-home-button-but-only-the-first-time/16447508
        if (!isTaskRoot()) {
            // Android launched another instance of the root activity into an existing task
            //  so just quietly finish and go away, dropping the user back into the activity
            //  at the top of the stack (ie: the last state of this task)
            // Don't need to finish it again since it's finished in super.onCreate .

            return;
        }
        appActivety = this;

        CallNative(true, 1, 2, 3, "HelloFromJava");

        //UnityActivityController.loadUnity(appActivety);
    }
    //native  public static  ClassLoader isGameStatus();
    //Java
    public static native void JavaCallCNative(String text);
    public static void CallNative(boolean b,int i,float f,double d, String s)
    {
        final String str = "bool:"+ b + " int:" + i + " float:" + f + " double:" + d + " String:" + s;
        appActivety.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                JavaCallCNative(str);
            }
        });
    }

    public static Object  NativeCallJava() throws AndroidException
    {
        return appActivety;
    }

    public void InvokeUnity(){
        UnityActivityController.loadUnity(appActivety);
//        LoadUnityUseFrameLayout();
    }

    public void LoadUnityUseFrameLayout()
    {
        Log.i("AppActivity", "InvokeUnity.cocosIndex:");
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                UnityPlayerForActivityOrService mUnityPlayer = new UnityPlayerForActivityOrService(appActivety, appActivety);
                setContentView(mUnityPlayer.getFrameLayout());
                mUnityPlayer.getFrameLayout().requestFocus();
                Log.i("AppActivity", "InvokeUnity.123:");
//                mUnityPlayer.newIntent(getIntent());
//                mUnityPlayer.disableStaticSplashScreen();
            }
        });
    }

    @Override
    public void onUnityPlayerUnloaded() {

    }

    @Override
    public void onUnityPlayerQuitted() {

    }
}
