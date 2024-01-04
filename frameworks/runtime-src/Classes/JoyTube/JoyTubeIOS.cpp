#include "JoyTubeIOS.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"

#define NameSpace(x)   subNameSpace(mj4_, x)        //
#define subNameSpace(base, x)   base##x

#define JOYTUBE_TEST

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
extern unsigned char* Init(int width, int height);
extern void InputXY(int phase, int x, int y);


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
    int* NameSpace(NativeStepFunc)();
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
}
#if defined(JOYTUBE_TEST)
void JoyTubeIOS::n_set_debug_log_func(DebugLogFunc func) {}
int JoyTubeIOS::n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texId) { return 0; }
void JoyTubeIOS::n_startTimer(bool atfirst) {}
void JoyTubeIOS::n_checkTimer() {}
bool JoyTubeIOS::n_passStartGame() { return false; }
int JoyTubeIOS::n_sendMessage(std::string cmd, std::string jsonstring) { return 0; }
int JoyTubeIOS::n_useItem(std::string jsonstring) { return 0; }
int JoyTubeIOS::n_isUsedItem() { return 0; }
void JoyTubeIOS::n_setCredit(double credit) {}
double JoyTubeIOS::n_isCredit() { return 0; }
bool JoyTubeIOS::n_isCreditEvent() { return false; }
int JoyTubeIOS::n_isGameStatus() { return 0; }
int JoyTubeIOS::n_isPlayState() { return 0; }
bool JoyTubeIOS::n_isAutoPlay() { return false; }
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
void JoyTubeIOS::n_setMouseEvent(int phase, int x, int y) {}
void JoyTubeIOS::n_setMouseEventf(int phase, float x, float y)  {}
void JoyTubeIOS::n_toPause(bool pause) {}
void JoyTubeIOS::n_GameDestroy() {}
void JoyTubeIOS::n_setSoundMute(bool isMute) {}
bool JoyTubeIOS::n_enteringSetting() { return true; }
void JoyTubeIOS::n_SetInputActive(bool bActive) {}
void JoyTubeIOS::n_setAbort() {}
#else
void JoyTubeIOS::n_set_debug_log_func(DebugLogFunc func) {return NameSpace(set_debug_log_func)(func); }
int JoyTubeIOS::n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texId) { return NameSpace(native)( left, top, width, height, local, master, texId); }
void JoyTubeIOS::n_startTimer(bool atfirst) { return NameSpace(startTimer)(atfirst); }
void JoyTubeIOS::n_checkTimer() { return NameSpace(checkTimer)(); }
bool JoyTubeIOS::n_passStartGame() { return NameSpace(passStartGame)();}
int JoyTubeIOS::n_sendMessage(std::string cmd, std::string jsonstring) { return NameSpace(sendMessage)(system, cmd, jsonstring);}
int JoyTubeIOS::n_useItem(std::string jsonstring) { return NameSpace(useItem)(jsonstring);}
int JoyTubeIOS::n_isUsedItem() { return NameSpace(isUsedItem)();}
void JoyTubeIOS::n_setCredit(double credit) { return NameSpace(setCredit)(credit);}
double JoyTubeIOS::n_isCredit() { return NameSpace(isCredit)();}
bool JoyTubeIOS::n_isCreditEvent() { return NameSpace(isCreditEvent)();}
int JoyTubeIOS::n_isGameStatus(){ return NameSpace(isGameStatus)();}
int JoyTubeIOS::n_isPlayState() { return NameSpace(isPlayState)();}
bool JoyTubeIOS::n_isAutoPlay() { return NameSpace(isAutoPlay)(); }
int JoyTubeIOS::n_isErrorDefine() { return NameSpace(isErrorDefine)();}
void JoyTubeIOS::n_clearErrorDefine() { return NameSpace(clearErrorDefine)();}
int JoyTubeIOS::n_isPostMessage() { return NameSpace(isPostMessage)();}
int* JoyTubeIOS::n_getPostMessageString() { return NameSpace(getPostMessageString)();}
void JoyTubeIOS::n_openGameInfo(bool isActive) { return NameSpace(openGameInfo)(isActive);}
int* JoyTubeIOS::n_getJsonString() { return NameSpace(getJsonString)();}
void JoyTubeIOS::n_stringFromUnity(std::string str) { return NameSpace(stringFromUnity)(str);}
int JoyTubeIOS::n_logout() { return NameSpace(logout)();}
int* JoyTubeIOS::n_CreateTextureFunc() { return NameSpace(CreateTextureFunc)();}
int JoyTubeIOS::n_isTextureId() { return NameSpace(isTextureId)();}
int JoyTubeIOS::n_isTextureWidth() { return NameSpace(isTextureWidth)();}
int JoyTubeIOS::n_isTextureHeight() { return NameSpace(isTextureHeight)();}
int JoyTubeIOS::n_isTextureWidthGl() { return NameSpace(isTextureWidthGl)();}
int JoyTubeIOS::n_isTextureHeightGl() { return NameSpace(isTextureHeightGl)();}
int* JoyTubeIOS::n_NativeStepFunc() { return NameSpace(NativeStepFunc)();}
int JoyTubeIOS::n_isRenderTextureId(int side) { return NameSpace(isRenderTextureId)(side);}
int JoyTubeIOS::n_isRenderTextureWidth(int side) { return NameSpace(isRenderTextureWidth)(side);}
int JoyTubeIOS::n_isRenderTextureHeight(int side) { return NameSpace(isRenderTextureHeight)(side);}
int JoyTubeIOS::n_isRenderTextureWidthGl(int side) { return NameSpace(isRenderTextureWidthGl)(side);}
int JoyTubeIOS::n_isRenderTextureHeightGl(int side) { return NameSpace(isRenderTextureHeightGl)(side);}
int JoyTubeIOS::n_isRenderTextureSide() { return NameSpace(isRenderTextureSide)();}
bool JoyTubeIOS::n_isDrawRenderTexture() { return NameSpace(isDrawRenderTexture)();}
int JoyTubeIOS::n_isFinishInitialize() { return NameSpace(isFinishInitialize)();}
bool JoyTubeIOS::n_isArrivedUpdateTex() { return NameSpace(isArrivedUpdateTex)();}
int JoyTubeIOS::n_isArrivedTextureId() { return NameSpace(isArrivedTextureId)();}
int JoyTubeIOS::n_isArrivedTextureWidth() { return NameSpace(isArrivedTextureWidth)();}
int JoyTubeIOS::n_isArrivedTextureHeight() { return NameSpace(isArrivedTextureHeight)();}
int JoyTubeIOS::n_isArrivedTextureWidthGl() { return NameSpace(isArrivedTextureWidthGl)();}
int JoyTubeIOS::n_isArrivedTextureHeightGl() { return NameSpace(isArrivedTextureHeightGl)();}
int JoyTubeIOS::n_isArrivedTextureFormat() { return NameSpace(isArrivedTextureFormat)();}
void JoyTubeIOS::n_PushButtons(int type) { return NameSpace(PushButtons)(type);}
void JoyTubeIOS::n_PullButtons(int type) { return NameSpace(PullButtons)(type);}
void JoyTubeIOS::n_setMouseEvent(int phase, int x, int y) { return NameSpace(setMouseEvent)(phase, x, y); }
void JoyTubeIOS::n_setMouseEventf(int phase, float x, float y)  { return NameSpace(setMouseEventf)(phase, x, y); }
void JoyTubeIOS::n_toPause(bool pause) { return NameSpace(toPause)(pause);}
void JoyTubeIOS::n_GameDestroy() { return NameSpace(GameDestroy)();}
void JoyTubeIOS::n_setSoundMute(bool isMute) { return NameSpace(setSoundMute)(isMute);}
bool JoyTubeIOS::n_enteringSetting() { return NameSpace(enteringSetting)();}
void JoyTubeIOS::n_SetInputActive(bool bActive) { return NameSpace(SetInputActive)(bActive);}
void JoyTubeIOS::n_setAbort() { return NameSpace(setAbort)();}
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

void JoyTubeIOS::OnTouch(int phase, int x, int y)
{
    CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
    //TestLibInputXY(x, y);
    n_setMouseEvent(phase, x, y)
    //n_setMouseEvent(0, x, y);        // down
    //n_setMouseEvent(3, x, y);        // up
}

void JoyTubeIOS::TestLibInputXY(int phase, int x, int y)
{
    setMouseEvent(phase, x, y);
}
#endif
