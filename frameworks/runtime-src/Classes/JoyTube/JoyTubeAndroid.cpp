#include "JoyTubeAndroid.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"


//#define JOYTUBE_TEST

#define NameSpace(x)   subNameSpace(mj4_, x)        //
#define subNameSpace(base, x)   base##x

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "platform/android/jni/JniHelper.h"
extern std::string helloWorldFun();
extern unsigned char* Init(int width, int height);
extern void setMouseEvent(int phase, int x, int y);


//#if (Target_NativeLib == NativeLib_Jap)
extern "C" {
    void NameSpace(set_debug_log_func)(void (*debugLogFunc)(char* str));
    int NameSpace(native)(int left, int top, int width, int height, bool local, bool master, unsigned int texID);
    void NameSpace(startTimer)(bool atfirst);
    void NameSpace(checkTimer)();
    bool NameSpace(passStartGame)();
    int NameSpace(sendMessage)(std::string system, std::string cmd, std::string jsonstring);
    int NameSpace(useItem)(std::string jsonstring);
    int NameSpace(isUsedItem)();
    void NameSpace(setCredit)(double credit);
    double NameSpace(isCredit)();
    bool NameSpace(isCreditEvent)();
    int NameSpace(isGameStatus)();
    int NameSpace(isPlayState)();
    int NameSpace(GetIsAutoPlay)();
    int NameSpace(isErrorDefine)();
    void NameSpace(clearErrorDefine)();
    int NameSpace(isPostMessage)();
    int* NameSpace(getPostMessageString)();
    void NameSpace(openGameInfo)(bool isActive);
    int* NameSpace(getJsonString)();
    void NameSpace(stringFromUnity)(const char* str);
    int NameSpace(logout)();
    int* NameSpace(CreateTextureFunc)();
    int NameSpace(isTextureId)();
    int NameSpace(isTextureWidth)();
    int NameSpace(isTextureHeight)();
    int NameSpace(isTextureWidthGl)();
    int NameSpace(isTextureHeightGl)();
    int* NameSpace(NativeStep)(int eventID);
    int NameSpace(isRenderTextureId)(int side);
    int NameSpace(isRenderTextureWidth)(int side);
    int NameSpace(isRenderTextureHeight)(int side);
    int NameSpace(isRenderTextureWidthGl)(int side);
    int NameSpace(isRenderTextureHeightGl)(int side);
    int NameSpace(isRenderTextureSide)();
    bool NameSpace(isDrawRenderTexture)();
    int NameSpace(isFinishInitialize)();
    bool NameSpace(isArrivedUpdateTex)();
    int NameSpace(isArrivedTextureId)();
    int NameSpace(isArrivedTextureWidth)();
    int NameSpace(isArrivedTextureHeight)();
    int NameSpace(isArrivedTextureWidthGl)();
    int NameSpace(isArrivedTextureHeightGl)();
    int NameSpace(isArrivedTextureFormat)();
    void NameSpace(PushButtons)(int type);
    void NameSpace(PullButtons)(int type);
    void NameSpace(setMouseEvent)(int phase, int x, int y);
    void NameSpace(setMouseEventf)(int phase, float x, float y);
    void NameSpace(toPause)(bool pause);
    void NameSpace(GameDestroy)();
    void NameSpace(setSoundMute)(bool isMute);
    bool NameSpace(enteringSetting)();
    void NameSpace(SetInputActive)(bool bActive);
    void NameSpace(setAbort)();
    void NameSpace(set_JavaVM)(jobject* object);
}
#if defined(JOYTUBE_TEST)
void JoyTubeAndroid::n_set_debug_log_func(DebugLogFunc func) {}
int JoyTubeAndroid::n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texID) { return 0; }
void JoyTubeAndroid::n_startTimer(bool atfirst) {}
void JoyTubeAndroid::n_checkTimer() {}
bool JoyTubeAndroid::n_passStartGame() { return false; }
int JoyTubeAndroid::n_sendMessage(std::string cmd, std::string jsonstring) { return 0; }
int JoyTubeAndroid::n_useItem(std::string jsonstring) { return 0; }
int JoyTubeAndroid::n_isUsedItem() { return 0; }
void JoyTubeAndroid::n_setCredit(double credit) {}
double JoyTubeAndroid::n_isCredit() { return 0; }
bool JoyTubeAndroid::n_isCreditEvent() { return false; }
int JoyTubeAndroid::n_isGameStatus() { return 0; }
int JoyTubeAndroid::n_isPlayState() { return 0; }
bool JoyTubeAndroid::n_isAutoPlay() { return false; }
int JoyTubeAndroid::n_isErrorDefine() { return 0; }
void JoyTubeAndroid::n_clearErrorDefine() {}
int JoyTubeAndroid::n_isPostMessage() { return 0; }
int* JoyTubeAndroid::n_getPostMessageString() { return nullptr; }
void JoyTubeAndroid::n_openGameInfo(bool isActive) {}
int* JoyTubeAndroid::n_getJsonString() { return nullptr; }
void JoyTubeAndroid::n_stringFromUnity(std::string str) {}
int JoyTubeAndroid::n_logout() { return 0; }
int* JoyTubeAndroid::n_CreateTextureFunc() { return nullptr; }
int JoyTubeAndroid::n_isTextureId() { return 0; }
int JoyTubeAndroid::n_isTextureWidth() { return 0; }
int JoyTubeAndroid::n_isTextureHeight() { return 0; }
int JoyTubeAndroid::n_isTextureWidthGl() { return 0; }
int JoyTubeAndroid::n_isTextureHeightGl() { return 0; }
int* JoyTubeAndroid::n_NativeStepFunc() { return nullptr; }
int JoyTubeAndroid::n_isRenderTextureId(int side) { return 0; }
int JoyTubeAndroid::n_isRenderTextureWidth(int side) { return 0; }
int JoyTubeAndroid::n_isRenderTextureHeight(int side) { return 0; }
int JoyTubeAndroid::n_isRenderTextureWidthGl(int side) { return 0; }
int JoyTubeAndroid::n_isRenderTextureHeightGl(int side) { return 0; }
int JoyTubeAndroid::n_isRenderTextureSide() { return 0; }
bool JoyTubeAndroid::n_isDrawRenderTexture() { return true; }
int JoyTubeAndroid::n_isFinishInitialize() { return 0; }
bool JoyTubeAndroid::n_isArrivedUpdateTex() { return true; }
int JoyTubeAndroid::n_isArrivedTextureId() { return 0; }
int JoyTubeAndroid::n_isArrivedTextureWidth() { return 0; }
int JoyTubeAndroid::n_isArrivedTextureHeight() { return 0; }
int JoyTubeAndroid::n_isArrivedTextureWidthGl() { return 0; }
int JoyTubeAndroid::n_isArrivedTextureHeightGl() { return 0; }
int JoyTubeAndroid::n_isArrivedTextureFormat() { return 0; }
// void JoyTubeAndroid::n_PushButtons(int type) {}
// void JoyTubeAndroid::n_PullButtons(int type) {}
void JoyTubeAndroid::n_setMouseEvent(int phase, int x, int y) {}
void JoyTubeAndroid::n_setMouseEventf(int phase, float x, float y){}
void JoyTubeAndroid::n_toPause(bool pause) {}
void JoyTubeAndroid::n_GameDestroy() {}
void JoyTubeAndroid::n_setSoundMute(bool isMute) {}
bool JoyTubeAndroid::n_enteringSetting() { return true; }
void JoyTubeAndroid::n_SetInputActive(bool bActive) {}
void JoyTubeAndroid::n_setAbort() {}
void JoyTubeAndroid::n_setJavaVM(jobject* object) {}
#else
void JoyTubeAndroid::n_set_debug_log_func(DebugLogFunc func) {return NameSpace(set_debug_log_func)(func); }
int JoyTubeAndroid::n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texID) { return NameSpace(native)( left, top, width, height, local, master, texID); }
void JoyTubeAndroid::n_startTimer(bool atfirst) { return NameSpace(startTimer)(atfirst); }
void JoyTubeAndroid::n_checkTimer() { return NameSpace(checkTimer)(); }
bool JoyTubeAndroid::n_passStartGame() { return NameSpace(passStartGame)();}
int JoyTubeAndroid::n_sendMessage(std::string cmd, std::string jsonstring) { return NameSpace(sendMessage)((char*)0, cmd, jsonstring);}
int JoyTubeAndroid::n_useItem(std::string jsonstring) { return NameSpace(useItem)(jsonstring);}
int JoyTubeAndroid::n_isUsedItem() { return NameSpace(isUsedItem)();}
void JoyTubeAndroid::n_setCredit(double credit) { return NameSpace(setCredit)(credit);}
double JoyTubeAndroid::n_isCredit() { return NameSpace(isCredit)();}
bool JoyTubeAndroid::n_isCreditEvent() { return NameSpace(isCreditEvent)();}
int JoyTubeAndroid::n_isGameStatus(){ return NameSpace(isGameStatus)();}
int JoyTubeAndroid::n_isPlayState() { return NameSpace(isPlayState)();}
bool JoyTubeAndroid::n_isAutoPlay() { return NameSpace(GetIsAutoPlay)(); }
int JoyTubeAndroid::n_isErrorDefine() { return NameSpace(isErrorDefine)();}
void JoyTubeAndroid::n_clearErrorDefine() { return NameSpace(clearErrorDefine)();}
int JoyTubeAndroid::n_isPostMessage() { return NameSpace(isPostMessage)();}
int* JoyTubeAndroid::n_getPostMessageString() { return NameSpace(getPostMessageString)();}
void JoyTubeAndroid::n_openGameInfo(bool isActive) { return NameSpace(openGameInfo)(isActive);}
int* JoyTubeAndroid::n_getJsonString() { return NameSpace(getJsonString)();}
void JoyTubeAndroid::n_stringFromUnity(std::string str) { return NameSpace(stringFromUnity)(str.c_str());}
int JoyTubeAndroid::n_logout() { return NameSpace(logout)();}
int* JoyTubeAndroid::n_CreateTextureFunc() { return NameSpace(CreateTextureFunc)();}
int JoyTubeAndroid::n_isTextureId() { return NameSpace(isTextureId)();}
int JoyTubeAndroid::n_isTextureWidth() { return NameSpace(isTextureWidth)();}
int JoyTubeAndroid::n_isTextureHeight() { return NameSpace(isTextureHeight)();}
int JoyTubeAndroid::n_isTextureWidthGl() { return NameSpace(isTextureWidthGl)();}
int JoyTubeAndroid::n_isTextureHeightGl() { return NameSpace(isTextureHeightGl)();}
int* JoyTubeAndroid::n_NativeStepFunc() { return NameSpace(NativeStep)(0);}
int JoyTubeAndroid::n_isRenderTextureId(int side) { return NameSpace(isRenderTextureId)(side);}
int JoyTubeAndroid::n_isRenderTextureWidth(int side) { return NameSpace(isRenderTextureWidth)(side);}
int JoyTubeAndroid::n_isRenderTextureHeight(int side) { return NameSpace(isRenderTextureHeight)(side);}
int JoyTubeAndroid::n_isRenderTextureWidthGl(int side) { return NameSpace(isRenderTextureWidthGl)(side);}
int JoyTubeAndroid::n_isRenderTextureHeightGl(int side) { return NameSpace(isRenderTextureHeightGl)(side);}
int JoyTubeAndroid::n_isRenderTextureSide() { return NameSpace(isRenderTextureSide)();}
bool JoyTubeAndroid::n_isDrawRenderTexture() { return NameSpace(isDrawRenderTexture)();}
int JoyTubeAndroid::n_isFinishInitialize() { return NameSpace(isFinishInitialize)();}
bool JoyTubeAndroid::n_isArrivedUpdateTex() { return NameSpace(isArrivedUpdateTex)();}
int JoyTubeAndroid::n_isArrivedTextureId() { return NameSpace(isArrivedTextureId)();}
int JoyTubeAndroid::n_isArrivedTextureWidth() { return NameSpace(isArrivedTextureWidth)();}
int JoyTubeAndroid::n_isArrivedTextureHeight() { return NameSpace(isArrivedTextureHeight)();}
int JoyTubeAndroid::n_isArrivedTextureWidthGl() { return NameSpace(isArrivedTextureWidthGl)();}
int JoyTubeAndroid::n_isArrivedTextureHeightGl() { return NameSpace(isArrivedTextureHeightGl)();}
int JoyTubeAndroid::n_isArrivedTextureFormat() { return NameSpace(isArrivedTextureFormat)();}
// void JoyTubeAndroid::n_PushButtons(int type) { return NameSpace(PushButtons)(type);}
// void JoyTubeAndroid::n_PullButtons(int type) { return NameSpace(PullButtons)(type);}
void JoyTubeAndroid::n_setMouseEvent(int phase, int x, int y) { return NameSpace(setMouseEvent)(phase, x, y); }
void JoyTubeAndroid::n_setMouseEventf(int phase, float x, float y)  { return NameSpace(setMouseEventf)(phase, x, y); }
void JoyTubeAndroid::n_toPause(bool pause) { return NameSpace(toPause)(pause);}
void JoyTubeAndroid::n_GameDestroy() { return NameSpace(GameDestroy)();}
void JoyTubeAndroid::n_setSoundMute(bool isMute) { return NameSpace(setSoundMute)(isMute);}
bool JoyTubeAndroid::n_enteringSetting() { return NameSpace(enteringSetting)();}
void JoyTubeAndroid::n_SetInputActive(bool bActive) { return NameSpace(SetInputActive)(bActive);}
void JoyTubeAndroid::n_setAbort() { return NameSpace(setAbort)();}
void JoyTubeAndroid::n_setJavaVM(jobject* object) { NameSpace(set_JavaVM)(object); }
#endif


JoyTubeAndroid::JoyTubeAndroid(int width, int height)
{
    CCLOG("JoyTube::%s", helloWorldFun().c_str());
	m_width = width;
	m_height = height;
	InitLibrary();
//    DebugLogFunc logFun = [](char* str) {
//    };
//    n_set_debug_log_func(logFun);
    n_setJavaVM((jobject*)cocos2d::JniHelper::getJavaVM());
}

JoyTubeAndroid::~JoyTubeAndroid()
{
	CCLOG("~JoyTubeAndroid");
	UnLoadLibrary();
}

void JoyTubeAndroid::InitLibrary()
{
	//cocos2d::log("GetGameStatus:%i", isGameStatus());
	m_textureData = Init(m_width, m_height);
    CCLOG("JoyTube::InitLibrary done");
}

void JoyTubeAndroid::UnLoadLibrary()
{
	
}

unsigned char* JoyTubeAndroid::GetTextureData()
{
	return m_textureData;
}

void JoyTubeAndroid::OnTouch(int phase, int x, int y)
{
	CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
	//TestLibInputXY(x, y);
    n_setMouseEvent(phase, x, y);
    //n_setMouseEvent(0, x, y);		// down
    //n_setMouseEvent(3, x, y);		// up
}

void JoyTubeAndroid::TestLibInputXY(int phase, int x, int y)
{
    //setMouseEvent(phase, x, y);
}
#endif
