#include "JoyTubeWin32.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"

#define JOYTUBE_TEST

struct HandleData {
	HMODULE m_hDll;
};

JoyTubeWin32::JoyTubeWin32(int width, int height)
{
	m_hData = new HandleData();
	m_width = width;
	m_height = height;

	InitLibrary();
}

JoyTubeWin32::~JoyTubeWin32()
{
	CCLOG("~JoyTubeWin32");
	UnLoadLibrary();
}

void JoyTubeWin32::InitLibrary()
{
	std::string path = "Win32Project.dll";
	m_hData->m_hDll = LoadLibraryA(path.c_str());
	CCLOG("JoyTube::InitLibrary m_hDll %X", m_hData->m_hDll);
	if (m_hData->m_hDll == NULL)
	{
		CCLOG("JoyTube::InitLibrary LoadLibraryA GetLastError %d", GetLastError());
		throw std::runtime_error("JoyTube::InitLibrary LoadLibraryA GetLastError");
	}
	else
	{
		libInitFun pInitFun = (libInitFun)GetProcAddress(m_hData->m_hDll, "Init");
		if (pInitFun)
		{
			m_textureData = pInitFun(m_width, m_height);
			CCLOG("JoyTube::InitLibrary done");
		}
	}
}

void JoyTubeWin32::UnLoadLibrary()
{
	if (!FreeLibrary(m_hData->m_hDll))
	{
		CCLOG("JoyTube Failed to unload DLL.");
	}
	else
	{
		CCLOG("JoyTube unload DLL.");
	}
}

unsigned char* JoyTubeWin32::GetTextureData()
{
	return m_textureData;
}

// void JoyTubeWin32::OnTouch(int phase, int x, int y)
// {
// 	CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
// 	TestLibInputXY(phase, x, y);
// }

// phase = 0 // down
// phase = 1 // move
// phase = 3 // up
void JoyTubeWin32::SetMouseEvent(int phase, int x, int y)
{
    CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
    n_setMouseEvent(phase, x, y);
    
}

void JoyTubeWin32::SetMouseEventf(int phase, float x, float y)
{
    CCLOG("joyTube OnTouch x:%f y:%f phase:%d", x, y, phase);
    n_setMouseEventf(phase, x, y);
}

// void JoyTubeWin32::TestLibInputXY(int phase, int x, int y)
// {
// 	libInputXYFun pInputXYFun = (libInputXYFun)GetProcAddress(m_hData->m_hDll, "InputXY");
// 	if (pInputXYFun)
// 	{
// 		pInputXYFun(phase, x, y);
// 	}
// }

#if defined(JOYTUBE_TEST)
void JoyTubeWin32::n_set_debug_log_func(DebugLogFunc func) {}
int JoyTubeWin32::n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texId) { return 0; }
void JoyTubeWin32::n_startTimer(bool atfirst){}
void JoyTubeWin32::n_checkTimer(){}
bool JoyTubeWin32::n_passStartGame() { return false; }
int JoyTubeWin32::n_sendMessage(const char* cmd, const char* jsonstring) { return 0; }
int JoyTubeWin32::n_useItem(const char* jsonstring) { return 0; }
int JoyTubeWin32::n_isUsedItem(){ return 0; }
void JoyTubeWin32::n_setCredit(double credit){}
double JoyTubeWin32::n_isCredit(){ return 0; }
bool JoyTubeWin32::n_isCreditEvent(){ return false; }
int JoyTubeWin32::n_isGameStatus(){ return 0; }
int JoyTubeWin32::n_isPlayState(){ return 0; }
bool JoyTubeWin32::n_isAutoPlay() { return false; }
int JoyTubeWin32::n_isErrorDefine(){ return 0; }
void JoyTubeWin32::n_clearErrorDefine(){}
int JoyTubeWin32::n_isPostMessage(){ return 0; }
int* JoyTubeWin32::n_getPostMessageString() { return (int*)"testString"; }
void JoyTubeWin32::n_openGameInfo(bool isActive){}
int* JoyTubeWin32::n_getJsonString(){ return nullptr; }
void JoyTubeWin32::n_stringFromUnity(std::string str){}
int JoyTubeWin32::n_logout(){ return 0; }
int* JoyTubeWin32::n_CreateTextureFunc(){ return nullptr; }
int JoyTubeWin32::n_isTextureId(){ return 0; }
int JoyTubeWin32::n_isTextureWidth(){ return 0; }
int JoyTubeWin32::n_isTextureHeight(){ return 0; }
int JoyTubeWin32::n_isTextureWidthGl(){ return 0; }
int JoyTubeWin32::n_isTextureHeightGl(){ return 0; }
void JoyTubeWin32::n_NativeStep(){}
int JoyTubeWin32::n_isRenderTextureId(int side){ return 0; }
int JoyTubeWin32::n_isRenderTextureWidth(int side){ return 0; }
int JoyTubeWin32::n_isRenderTextureHeight(int side){ return 0; }
int JoyTubeWin32::n_isRenderTextureWidthGl(int side){ return 0; }
int JoyTubeWin32::n_isRenderTextureHeightGl(int side){ return 0; }
int JoyTubeWin32::n_isRenderTextureSide(){ return 0; }
bool JoyTubeWin32::n_isDrawRenderTexture(){ return true; }
int JoyTubeWin32::n_isFinishInitialize(){ return 0; }
bool JoyTubeWin32::n_isArrivedUpdateTex(){ return true; }
int JoyTubeWin32::n_isArrivedTextureId(){ return 0; }
int JoyTubeWin32::n_isArrivedTextureWidth(){ return 0; }
int JoyTubeWin32::n_isArrivedTextureHeight(){ return 0; }
int JoyTubeWin32::n_isArrivedTextureWidthGl(){ return 0; }
int JoyTubeWin32::n_isArrivedTextureHeightGl(){ return 0; }
int JoyTubeWin32::n_isArrivedTextureFormat(){ return 0; }
// void JoyTubeWin32::n_PushButtons(int type){}
// void JoyTubeWin32::n_PullButtons(int type){}
void JoyTubeWin32::n_setMouseEvent(int phase, int x, int y){}
void JoyTubeWin32::n_setMouseEventf(int phase, float x, float y){}
void JoyTubeWin32::n_toPause(bool pause){}
void JoyTubeWin32::n_GameDestroy(){}
void JoyTubeWin32::n_setSoundMute(bool isMute){}
bool JoyTubeWin32::n_enteringSetting(){ return true; }
void JoyTubeWin32::n_SetInputActive(bool bActive){}
void JoyTubeWin32::n_setAbort(){}
#else
#endif