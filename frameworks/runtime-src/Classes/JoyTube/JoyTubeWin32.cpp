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