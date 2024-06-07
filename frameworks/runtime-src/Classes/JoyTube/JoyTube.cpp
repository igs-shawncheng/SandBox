#include "JoyTube.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"
#include "base/CCEventDispatcher.h"
#include "platform/CCFileUtils.h"
#include "platform/android/jni/JniHelper.h"


JoyTube *JoyTube::_instance = nullptr;

JoyTube *JoyTube::getInstance()
{
	if (!_instance)
	{
		_instance = new JoyTube();
	}
	return _instance;
}

JoyTube::JoyTube()
{
}

JoyTube::~JoyTube()
{
	CCLOG("~JoyTube");
}

void JoyTube::RegisterLua()
{
	luabridge::getGlobalNamespace(LuaEngine::getInstance()->getLuaStack()->getLuaState())
		.beginNamespace("Inanna")
		.addFunction("GetJoyTube", &JoyTube::getInstance)
		.beginClass<JoyTube>("JoyTube")
		.addConstructor<void(*) ()>()
		.addFunction("LoadUnity", &JoyTube::LoadUnity)
		.endClass()
		.endNamespace();
}


void JoyTube::Process(float tick)
{
	//CCLOG("JoyTube::Process tick %f", tick);
}

void JoyTube::LoadUnity()
{
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	CCLOG("cocos_android_app_LoadUnity");
	JniMethodInfo minfo;
	jobject jObj;

	if(JniHelper::getStaticMethodInfo(minfo, "org/cocos2dx/lua/AppActivity", "NativeCallJava", "()Ljava/lang/Object;"))
	{
		jObj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
        minfo.env->DeleteLocalRef(minfo.classID);  // 釋放
	}

    if(jObj && JniHelper::getMethodInfo(minfo, "org/cocos2dx/lua/AppActivity", "InvokeUnity", "(Ljava/lang/String;)V"))
    {
        jstring jstr = minfo.env->NewStringUTF("StringFromC++");  // 創建 Java 字符串
		minfo.env->CallVoidMethod(jObj, minfo.methodID, jstr);
        CCLOG("cocos_android_app_LoadUnity Call");
        // 釋放
        minfo.env->DeleteLocalRef(jObj);
        minfo.env->DeleteLocalRef(jstr);
        minfo.env->DeleteLocalRef(minfo.classID);
    }
    else
	{
		CCLOG("jni:InvokeUnity doesn't exist!");
	}
#endif
}
