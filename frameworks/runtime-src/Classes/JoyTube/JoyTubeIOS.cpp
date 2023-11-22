#include "JoyTubeIOS.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"

#define JOYTUBE_TEST

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
extern unsigned char* Init(int width, int height);
extern void InputXY(int x, int y);


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
#if defined(JOYTUBE_TEST)
void JoyTubeIOS::n_set_debug_log_func(DebugLogFunc func) {}
int JoyTubeIOS::n_native(int left, int top, int width, int height, bool local) { return 0; }
void JoyTubeIOS::n_startTimer(bool atfirst) {}
void JoyTubeIOS::n_checkTimer() {}
bool JoyTubeIOS::n_passStartGame() { return false; }
int JoyTubeIOS::n_sendMessage(std::string system, std::string cmd, std::string jsonstring) { return 0; }
int JoyTubeIOS::n_useItem(std::string jsonstring) { return 0; }
int JoyTubeIOS::n_isUsedItem() { return 0; }
void JoyTubeIOS::n_setCredit(double credit) {}
double JoyTubeIOS::n_isCredit() { return 0; }
bool JoyTubeIOS::n_isCreditEvent() { return false; }
int JoyTubeIOS::n_isGameStatus() { return 0; }
int JoyTubeIOS::n_isPlayState() { return 0; }
int JoyTubeIOS::n_isErrorDefine() { return 0; }
void JoyTubeIOS::n_clearErrorDefine() {}
int JoyTubeIOS::n_isPostMessage() { return 0; }
int* JoyTubeIOS::n_getPostMessageString() { return nullptr; }
void JoyTubeIOS::n_openGameInfo(bool isActive) {}
int* JoyTubeIOS::n_getJsonString() { return nullptr; }
void JoyTubeIOS::n_stringFromUnity(std::string str) {}
int JoyTubeIOS::n_logout() { return 0; }
int* JoyTubeIOS::n_CreateTextureFunc() { return nullptr; }
int JoyTubeIOS::n_isTextureId() { return 0; }
int JoyTubeIOS::n_isTextureWidth() { return 0; }
int JoyTubeIOS::n_isTextureHeight() { return 0; }
int JoyTubeIOS::n_isTextureWidthGl() { return 0; }
int JoyTubeIOS::n_isTextureHeightGl() { return 0; }
int* JoyTubeIOS::n_NativeStepFunc() { return nullptr; }
int JoyTubeIOS::n_isRenderTextureId(int side) { return 0; }
int JoyTubeIOS::n_isRenderTextureWidth(int side) { return 0; }
int JoyTubeIOS::n_isRenderTextureHeight(int side) { return 0; }
int JoyTubeIOS::n_isRenderTextureWidthGl(int side) { return 0; }
int JoyTubeIOS::n_isRenderTextureHeightGl(int side) { return 0; }
int JoyTubeIOS::n_isRenderTextureSide() { return 0; }
bool JoyTubeIOS::n_isDrawRenderTexture() { return true; }
int JoyTubeIOS::n_isFinishInitialize() { return 0; }
bool JoyTubeIOS::n_isArrivedUpdateTex() { return true; }
int JoyTubeIOS::n_isArrivedTextureId() { return 0; }
int JoyTubeIOS::n_isArrivedTextureWidth() { return 0; }
int JoyTubeIOS::n_isArrivedTextureHeight() { return 0; }
int JoyTubeIOS::n_isArrivedTextureWidthGl() { return 0; }
int JoyTubeIOS::n_isArrivedTextureHeightGl() { return 0; }
int JoyTubeIOS::n_isArrivedTextureFormat() { return 0; }
void JoyTubeIOS::n_PushButtons(int type) {}
void JoyTubeIOS::n_PullButtons(int type) {}
void JoyTubeIOS::n_toPause(bool pause) {}
void JoyTubeIOS::n_GameDestroy() {}
void JoyTubeIOS::n_setSoundMute(bool isMute) {}
bool JoyTubeIOS::n_enteringSetting() { return true; }
void JoyTubeIOS::n_SetInputActive(bool bActive) {}
void JoyTubeIOS::n_setAbort() {}
#else
void JoyTubeIOS::n_set_debug_log_func(DebugLogFunc func) {return set_debug_log_func(func); }
int JoyTubeIOS::n_native(int left, int top, int width, int height, bool local) { return native( left, top, width, height, local); }
void JoyTubeIOS::n_startTimer(bool atfirst) { return startTimer(atfirst); }
void JoyTubeIOS::n_checkTimer() { return checkTimer(); }
bool JoyTubeIOS::n_passStartGame() { return passStartGame();}
int JoyTubeIOS::n_sendMessage(std::string system, std::string cmd, std::string jsonstring) { return sendMessage(system, cmd, jsonstring);}
int JoyTubeIOS::n_useItem(std::string jsonstring) { return useItem(jsonstring);}
int JoyTubeIOS::n_isUsedItem() { return isUsedItem();}
void JoyTubeIOS::n_setCredit(double credit) { return setCredit(credit);}
double JoyTubeIOS::n_isCredit() { return isCredit();}
bool JoyTubeIOS::n_isCreditEvent() { return isCreditEvent();}
int JoyTubeIOS::n_isGameStatus(){ return isGameStatus();}
int JoyTubeIOS::n_isPlayState() { return isPlayState();}
bool JoyTubeIOS::n_isGetIsAutoPlay() { return isAutoPlay(); }
int JoyTubeIOS::n_isErrorDefine() { return isErrorDefine();}
void JoyTubeIOS::n_clearErrorDefine() { return clearErrorDefine();}
int JoyTubeIOS::n_isPostMessage() { return isPostMessage();}
int* JoyTubeIOS::n_getPostMessageString() { return getPostMessageString();}
void JoyTubeIOS::n_openGameInfo(bool isActive) { return openGameInfo(isActive);}
int* JoyTubeIOS::n_getJsonString() { return getJsonString();}
void JoyTubeIOS::n_stringFromUnity(std::string str) { return stringFromUnity(str);}
int JoyTubeIOS::n_logout() { return logout();}
int* JoyTubeIOS::n_CreateTextureFunc() { return CreateTextureFunc();}
int JoyTubeIOS::n_isTextureId() { return isTextureId();}
int JoyTubeIOS::n_isTextureWidth() { return isTextureWidth();}
int JoyTubeIOS::n_isTextureHeight() { return isTextureHeight();}
int JoyTubeIOS::n_isTextureWidthGl() { return isTextureWidthGl();}
int JoyTubeIOS::n_isTextureHeightGl() { return isTextureHeightGl();}
int* JoyTubeIOS::n_NativeStepFunc() { return NativeStepFunc();}
int JoyTubeIOS::n_isRenderTextureId(int side) { return isRenderTextureId(side);}
int JoyTubeIOS::n_isRenderTextureWidth(int side) { return isRenderTextureWidth(side);}
int JoyTubeIOS::n_isRenderTextureHeight(int side) { return isRenderTextureHeight(side);}
int JoyTubeIOS::n_isRenderTextureWidthGl(int side) { return isRenderTextureWidthGl(side);}
int JoyTubeIOS::n_isRenderTextureHeightGl(int side) { return isRenderTextureHeightGl(side);}
int JoyTubeIOS::n_isRenderTextureSide() { return isRenderTextureSide();}
bool JoyTubeIOS::n_isDrawRenderTexture() { return isDrawRenderTexture();}
int JoyTubeIOS::n_isFinishInitialize() { return isFinishInitialize();}
bool JoyTubeIOS::n_isArrivedUpdateTex() { return isArrivedUpdateTex();}
int JoyTubeIOS::n_isArrivedTextureId() { return isArrivedTextureId();}
int JoyTubeIOS::n_isArrivedTextureWidth() { return isArrivedTextureWidth();}
int JoyTubeIOS::n_isArrivedTextureHeight() { return isArrivedTextureHeight();}
int JoyTubeIOS::n_isArrivedTextureWidthGl() { return isArrivedTextureWidthGl();}
int JoyTubeIOS::n_isArrivedTextureHeightGl() { return isArrivedTextureHeightGl();}
int JoyTubeIOS::n_isArrivedTextureFormat() { return isArrivedTextureFormat();}
void JoyTubeIOS::n_PushButtons(int type) { return PushButtons(type);}
void JoyTubeIOS::n_PullButtons(int type) { return PullButtons(type);}
void JoyTubeIOS::n_toPause(bool pause) { return toPause(pause);}
void JoyTubeIOS::n_GameDestroy() { return GameDestroy();}
void JoyTubeIOS::n_setSoundMute(bool isMute) { return setSoundMute(isMute);}
bool JoyTubeIOS::n_enteringSetting() { return enteringSetting();}
void JoyTubeIOS::n_SetInputActive(bool bActive) { return SetInputActive(bActive);}
void JoyTubeIOS::n_setAbort() { return setAbort();}
#endif


JoyTubeIOS::JoyTubeIOS(int width, int height)
{
	m_width = width;
	m_height = height;
	InitLibrary();
    DebugLogFunc logFun = [](char* str) {
    };
    n_set_debug_log_func(logFun);
}

JoyTubeIOS::~JoyTubeIOS()
{
	CCLOG("~JoyTubeIOS");
	UnLoadLibrary();
}

void JoyTubeIOS::InitLibrary()
{
	//cocos2d::log("GetGameStatus:%i", isGameStatus());
    m_textureData = Init(m_width, m_height);
    
    CCLOG("JoyTube::InitLibrary done");
}

void JoyTubeIOS::UnLoadLibrary()
{
	
}

unsigned char* JoyTubeIOS::GetTextureData()
{
	return m_textureData;
}

void JoyTubeIOS::OnTouch(int x, int y)
{
	CCLOG("joyTube OnTouch x:%d y:%d", x, y);
	TestLibInputXY(x, y);
}

void JoyTubeIOS::TestLibInputXY(int x, int y)
{
    InputXY(x, y);
}
#endif
