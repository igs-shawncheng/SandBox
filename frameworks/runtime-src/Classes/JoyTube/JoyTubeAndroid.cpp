#include "JoyTubeAndroid.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"


#if ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
extern std::string helloWorldFun();
extern unsigned char* Init(int width, int height);
extern void InputXY(int x, int y);


//#if (Target_NativeLib == NativeLib_Jap)
extern "C" {
    void set_debug_log_func(void (*debugLogFunc)(char* str));
    int native(int left, int top, int width, int height, bool local);
    void startTimer(bool atfirst);
    void checkTimer();
    bool passStartGame();
    int sendMessage(std::string system, std::string cmd, std::string jsonstring);
    int useItem(std::string jsonstring);
    int isUsedItem();
    void setCredit(double credit);
    double isCredit();
    bool isCreditEvent();
    int isGameStatus();
    int isPlayState();
    int isErrorDefine();
    void clearErrorDefine();
    int isPostMessage();
    int* getPostMessageString();
    void openGameInfo(bool isActive);
    int* getJsonString();
    void stringFromUnity(std::string str);
    int logout();
    int* CreateTextureFunc();
    int isTextureId();
    int isTextureWidth();
    int isTextureHeight();
    int isTextureWidthGl();
    int isTextureHeightGl();
    int* NativeStepFunc();
    int isRenderTextureId(int side);
    int isRenderTextureWidth(int side);
    int isRenderTextureHeight(int side);
    int isRenderTextureWidthGl(int side);
    int isRenderTextureHeightGl(int side);
    int isRenderTextureSide();
    bool isDrawRenderTexture();
    int isFinishInitialize();
    bool isArrivedUpdateTex();
    int isArrivedTextureId();
    int isArrivedTextureWidth();
    int isArrivedTextureHeight();
    int isArrivedTextureWidthGl();
    int isArrivedTextureHeightGl();
    int isArrivedTextureFormat();
    void PushButtons(int type);
    void PullButtons(int type);
    void toPause(bool pause);
    void GameDestroy();
    void setSoundMute(bool isMute);
    bool enteringSetting();
    void SetInputActive(bool bActive);
    void setAbort();
}
void JoyTubeAndroid::n_set_debug_log_func(DebugLogFunc func) {return set_debug_log_func(func); }
int JoyTubeAndroid::n_native(int left, int top, int width, int height, bool local) { return native( left, top, width, height, local); }
void JoyTubeAndroid::n_startTimer(bool atfirst) { return startTimer(atfirst); }
void JoyTubeAndroid::n_checkTimer() { return checkTimer(); }
bool JoyTubeAndroid::n_passStartGame() { return passStartGame();}
int JoyTubeAndroid::n_sendMessage(std::string system, std::string cmd, std::string jsonstring) { return sendMessage(system, cmd, jsonstring);}
int JoyTubeAndroid::n_useItem(std::string jsonstring) { return useItem(jsonstring);}
int JoyTubeAndroid::n_isUsedItem() { return isUsedItem();}
void JoyTubeAndroid::n_setCredit(double credit) { return setCredit(credit);}
double JoyTubeAndroid::n_isCredit() { return isCredit();}
bool JoyTubeAndroid::n_isCreditEvent() { return isCreditEvent();}
int JoyTubeAndroid::n_isGameStatus(){ return isGameStatus();}
int JoyTubeAndroid::n_isPlayState() { return isPlayState();}
int JoyTubeAndroid::n_isErrorDefine() { return isErrorDefine();}
void JoyTubeAndroid::n_clearErrorDefine() { return clearErrorDefine();}
int JoyTubeAndroid::n_isPostMessage() { return isPostMessage();}
int* JoyTubeAndroid::n_getPostMessageString() { return getPostMessageString();}
void JoyTubeAndroid::n_openGameInfo(bool isActive) { return openGameInfo(isActive);}
int* JoyTubeAndroid::n_getJsonString() { return getJsonString();}
void JoyTubeAndroid::n_stringFromUnity(std::string str) { return stringFromUnity(str);}
int JoyTubeAndroid::n_logout() { return logout();}
int* JoyTubeAndroid::n_CreateTextureFunc() { return CreateTextureFunc();}
int JoyTubeAndroid::n_isTextureId() { return isTextureId();}
int JoyTubeAndroid::n_isTextureWidth() { return isTextureWidth();}
int JoyTubeAndroid::n_isTextureHeight() { return isTextureHeight();}
int JoyTubeAndroid::n_isTextureWidthGl() { return isTextureWidthGl();}
int JoyTubeAndroid::n_isTextureHeightGl() { return isTextureHeightGl();}
int* JoyTubeAndroid::n_NativeStepFunc() { return NativeStepFunc();}
int JoyTubeAndroid::n_isRenderTextureId(int side) { return isRenderTextureId(side);}
int JoyTubeAndroid::n_isRenderTextureWidth(int side) { return isRenderTextureWidth(side);}
int JoyTubeAndroid::n_isRenderTextureHeight(int side) { return isRenderTextureHeight(side);}
int JoyTubeAndroid::n_isRenderTextureWidthGl(int side) { return isRenderTextureWidthGl(side);}
int JoyTubeAndroid::n_isRenderTextureHeightGl(int side) { return isRenderTextureHeightGl(side);}
int JoyTubeAndroid::n_isRenderTextureSide() { return isRenderTextureSide();}
bool JoyTubeAndroid::n_isDrawRenderTexture() { return isDrawRenderTexture();}
int JoyTubeAndroid::n_isFinishInitialize() { return isFinishInitialize();}
bool JoyTubeAndroid::n_isArrivedUpdateTex() { return isArrivedUpdateTex();}
int JoyTubeAndroid::n_isArrivedTextureId() { return isArrivedTextureId();}
int JoyTubeAndroid::n_isArrivedTextureWidth() { return isArrivedTextureWidth();}
int JoyTubeAndroid::n_isArrivedTextureHeight() { return isArrivedTextureHeight();}
int JoyTubeAndroid::n_isArrivedTextureWidthGl() { return isArrivedTextureWidthGl();}
int JoyTubeAndroid::n_isArrivedTextureHeightGl() { return isArrivedTextureHeightGl();}
int JoyTubeAndroid::n_isArrivedTextureFormat() { return isArrivedTextureFormat();}
void JoyTubeAndroid::n_PushButtons(int type) { return PushButtons(type);}
void JoyTubeAndroid::n_PullButtons(int type) { return PullButtons(type);}
void JoyTubeAndroid::n_toPause(bool pause) { return toPause(pause);}
void JoyTubeAndroid::n_GameDestroy() { return GameDestroy();}
void JoyTubeAndroid::n_setSoundMute(bool isMute) { return setSoundMute(isMute);}
bool JoyTubeAndroid::n_enteringSetting() { return enteringSetting();}
void JoyTubeAndroid::n_SetInputActive(bool bActive) { return SetInputActive(bActive);}
void JoyTubeAndroid::n_setAbort() { return setAbort();}



JoyTubeAndroid::JoyTubeAndroid(int width, int height)
{
    CCLOG("JoyTube::%s", helloWorldFun().c_str());
	m_width = width;
	m_height = height;
	InitLibrary();
    DebugLogFunc logFun = [](char* str) {
    };
    n_set_debug_log_func(logFun);
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

void JoyTubeAndroid::OnTouch(int x, int y)
{
	CCLOG("joyTube OnTouch x:%d y:%d", x, y);
	TestLibInputXY(x, y);
}

void JoyTubeAndroid::TestLibInputXY(int x, int y)
{
    InputXY(x, y);
}
#endif
