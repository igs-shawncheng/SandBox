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

import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.nfc.Tag;
import android.os.Bundle;
import android.util.AndroidException;
import android.util.Log;

import org.cocos2dx.lib.Cocos2dxActivity;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.logging.Logger;

public class AppActivity extends Cocos2dxActivity{

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
        //SetOrientation(2);

        CallNative(true, 1, 2, 3, "HelloFromJava");

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

    public static String NativeCallJava() throws AndroidException
    {
        String returnStr = "JavaValue";
        return returnStr;
    }

    // 定義 Java 方法，接受文件路徑參數
    public static void javaMethodWithFilePath(String filePath) {
        // 在這裡處理接收到的文件路徑
        System.out.println("Java Method called from C++ with file path: " + filePath);
    }
//    public static boolean SetOrientation(int orientation)
//    {
//        Log.i("Debug", "SetOrientation：" +orientation);
//        if(orientation == 1 ) {
//            appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
//            appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
//        }else if (orientation == 2 ){
//            appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
//            //appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
//        }else if (orientation == 3 ) {
//            appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_USER);
//            appActivety.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
//        }
//        return true;
//    }
}
