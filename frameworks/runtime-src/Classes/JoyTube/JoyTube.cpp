#include "JoyTube.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"

typedef unsigned char*(*libInitFun)(int width, int height);
typedef void(*libInputXYFun)(int x, int y);

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
	InitTube();
	InitLibrary();

	float fps = cocos2d::Director::getInstance()->getFrameRate();
	cocos2d::Director::getInstance()->getScheduler()->schedule(
		schedule_selector(JoyTube::Process),
		this,
		fps,
		false
		);
}

JoyTube::~JoyTube()
{
	CCLOG("~JoyTube");
	m_sprite->release();
	UnLoadLibrary();
}

void JoyTube::InitTube()
{
	auto dataLen = m_width * m_height * 4;
	m_textureData = new unsigned char[dataLen];

	auto allcolor = Color4B::WHITE;
	int w = 4 * m_width;
	for (int i = 0; i < m_height; i++)
	{
		for (int j = 0; j < m_width; j++)
		{
			m_textureData[i * w + j * 4 + 0] = allcolor.r;
			m_textureData[i * w + j * 4 + 1] = allcolor.g;
			m_textureData[i * w + j * 4 + 2] = allcolor.b;
			m_textureData[i * w + j * 4 + 3] = allcolor.a;
		}
	}

	m_texture2D = new cocos2d::Texture2D();
	m_texture2D->initWithData(m_textureData, dataLen, Texture2D::PixelFormat::RGBA8888, m_width, m_height, Size((float)m_width, (float)m_height));

	m_sprite = cocos2d::Sprite::createWithTexture(m_texture2D);
	m_sprite->setName(m_spriteName);
	m_sprite->retain();
}

void JoyTube::InitLibrary()
{
	std::string path = "Win32Project.dll";
	//m_hDll = LoadLibraryA(path.c_str());
	//CCLOG("JoyTube::InitLibrary m_hDll %X", m_hDll);
	//if (m_hDll == NULL)
	//{
	//	CCLOG("JoyTube::InitLibrary LoadLibraryA GetLastError %d", GetLastError());
	//}
	//else
	//{
	//	libInitFun pInitFun = (libInitFun)GetProcAddress(m_hDll, "Init");
	//	if (pInitFun)
	//	{
	//		m_textureData = pInitFun(m_width, m_height);
	//		CCLOG("JoyTube::InitLibrary done");
	//	}
	//}
}

void JoyTube::UnLoadLibrary()
{
	//if (!FreeLibrary(m_hDll))
	//{
	//	CCLOG("JoyTube Failed to unload DLL.");
	//}
	//else
	//{
		CCLOG("JoyTube unload DLL.");
	//}
}

void JoyTube::RegisterLua()
{
	luabridge::getGlobalNamespace(LuaEngine::getInstance()->getLuaStack()->getLuaState())
		.beginNamespace("Inanna")
		.addFunction("GetJoyTube", &JoyTube::getInstance)
		.beginClass<JoyTube>("JoyTube")
		.addConstructor<void(*) ()>()
		.addFunction("Init", &JoyTube::Init)
		.addFunction("OnTouch", &JoyTube::OnTouch)
		.addData("m_testInt", &JoyTube::m_testInt)
		.endClass()
		.endNamespace();
}

void JoyTube::Init()
{
	AddSprite();
}

void JoyTube::AddSprite()
{
	auto scene = Director::getInstance()->getRunningScene();
	if (!scene)
	{
		CCLOG("JoyTube::AddSprite getRunningScene fail");
		return;
	}

	if (!scene->getChildByName(m_spriteName))
	{
		m_sprite->setAnchorPoint(Vec2(0, 0));
		scene->addChild(m_sprite);
		Size winSize = scene->getContentSize();
		Size contentSize = m_sprite->getContentSize();
        m_sprite->setPosition(Vec2(winSize.width / 2 - contentSize.width / 2, winSize.height / 2 - contentSize.height / 2));
	}
}

void JoyTube::OnTouch(int x, int y)
{
	CCLOG("joyTube OnTouch x:%d y:%d", x, y);
	TestLibInputXY(x, y);
}

void JoyTube::Process(float tick)
{
	//CCLOG("JoyTube::Process tick %f", tick);
	UpdateTextureData();
}

void JoyTube::UpdateTextureData()
{
	m_texture2D->updateWithData(m_textureData, 0, 0, m_width, m_height);
}

void JoyTube::TestLibInputXY(int x, int y)
{
	//libInputXYFun pInputXYFun = (libInputXYFun)GetProcAddress(m_hDll, "InputXY");
	//if (pInputXYFun)
	//{
	//	pInputXYFun(x, y);
	//}
}