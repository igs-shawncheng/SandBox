#include "JoyTubeWin32.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"

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

void JoyTubeWin32::OnTouch(int x, int y)
{
	CCLOG("joyTube OnTouch x:%d y:%d", x, y);
	TestLibInputXY(x, y);
}

void JoyTubeWin32::TestLibInputXY(int x, int y)
{
	libInputXYFun pInputXYFun = (libInputXYFun)GetProcAddress(m_hData->m_hDll, "InputXY");
	if (pInputXYFun)
	{
		pInputXYFun(x, y);
	}
}

int JoyTubeWin32::n_native(int left, int top, int width, int height, bool local){}
void JoyTubeWin32::n_startTimer(bool atfirst){}
void JoyTubeWin32::n_checkTimer(){}
bool JoyTubeWin32::n_passStartGame(){}
int JoyTubeWin32::n_sendMessage(std::string system, std::string cmd, std::string jsonstring){}
int JoyTubeWin32::n_useItem(std::string jsonstring) {}
int JoyTubeWin32::n_isUsedItem(){}
void JoyTubeWin32::n_setCredit(double credit){}
double JoyTubeWin32::n_isCredit(){}
bool JoyTubeWin32::n_isCreditEvent(){}
int JoyTubeWin32::n_isGameStatus(){}
int JoyTubeWin32::n_isPlayState(){}
int JoyTubeWin32::n_isErrorDefine(){}
void JoyTubeWin32::n_clearErrorDefine(){}
int JoyTubeWin32::n_isPostMessage(){}
int* JoyTubeWin32::n_getPostMessageString(){}
void JoyTubeWin32::n_openGameInfo(bool isActive){}
int* JoyTubeWin32::n_getJsonString(){}
void JoyTubeWin32::n_stringFromUnity(std::string str){}
int JoyTubeWin32::n_logout(){}
int* JoyTubeWin32::n_CreateTextureFunc(){}
int JoyTubeWin32::n_isTextureId(){}
int JoyTubeWin32::n_isTextureWidth(){}
int JoyTubeWin32::n_isTextureHeight(){}
int JoyTubeWin32::n_isTextureWidthGl(){}
int JoyTubeWin32::n_isTextureHeightGl(){}
int* JoyTubeWin32::n_NativeStepFunc(){}
int JoyTubeWin32::n_isRenderTextureId(int side){}
int JoyTubeWin32::n_isRenderTextureWidth(int side){}
int JoyTubeWin32::n_isRenderTextureHeight(int side){}
int JoyTubeWin32::n_isRenderTextureWidthGl(int side){}
int JoyTubeWin32::n_isRenderTextureHeightGl(int side){}
int JoyTubeWin32::n_isRenderTextureSide(){}
bool JoyTubeWin32::n_isDrawRenderTexture(){}
int JoyTubeWin32::n_isFinishInitialize(){}
bool JoyTubeWin32::n_isArrivedUpdateTex(){}
int JoyTubeWin32::n_isArrivedTextureId(){}
int JoyTubeWin32::n_isArrivedTextureWidth(){}
int JoyTubeWin32::n_isArrivedTextureHeight(){}
int JoyTubeWin32::n_isArrivedTextureWidthGl(){}
int JoyTubeWin32::n_isArrivedTextureHeightGl(){}
int JoyTubeWin32::n_isArrivedTextureFormat(){}
void JoyTubeWin32::n_PushButtons(int type){}
void JoyTubeWin32::n_PullButtons(int type){}
void JoyTubeWin32::n_toPause(bool pause){}
void JoyTubeWin32::n_GameDestroy(){}
void JoyTubeWin32::n_setSoundMute(bool isMute){}
bool JoyTubeWin32::n_enteringSetting(){}
void JoyTubeWin32::n_SetInputActive(bool bActive){}
void JoyTubeWin32::n_setAbort(){}