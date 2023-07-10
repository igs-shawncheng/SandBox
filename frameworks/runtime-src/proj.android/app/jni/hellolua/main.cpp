/****************************************************************************
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

#include <memory>

#include <android/log.h>
#include <jni.h>
#include "cocos2d.h"
#include "AppDelegate.h"
#include <dlfcn.h>

using namespace std;


#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

namespace {
std::unique_ptr<AppDelegate> appDelegate;
}

void cocos_android_app_init(JNIEnv* env) {
    LOGD("cocos_android_app_init");
    appDelegate.reset(new AppDelegate());

#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
//    NativeCallJava();
#endif
}


extern "C"
JNIEXPORT void JNICALL
Java_org_cocos2dx_lua_AppActivity_JavaCallCNative(JNIEnv *env, jclass clazz, jstring text) {
    const char *data = env->GetStringUTFChars(text, 0);
    cocos2d::log("1JNITest:%s", data);
    env->ReleaseStringUTFChars(text, data);

}

extern "C"
JNIEXPORT void JNICALL
Java_org_cocos2dx_lua_AppActivity_isGameStatus(JNIEnv *env, jclass clazz, jstring text) {
    const char *data = env->GetStringUTFChars(text, 0);
    cocos2d::log("2JNITest:%s", data);
    env->ReleaseStringUTFChars(text, data);
}
