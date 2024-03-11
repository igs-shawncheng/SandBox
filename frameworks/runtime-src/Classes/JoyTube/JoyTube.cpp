#include "JoyTube.h"
#include "base/CCDirector.h"
#include "base/CCScheduler.h"
#include "base/CCEventDispatcher.h"
#include "platform/CCFileUtils.h"


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
	: m_creditEventCallback( nullptr )
	, m_errorStatusCallback( nullptr )
{
	InitTube();

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 )
	m_joyTubeNative = IJoyTubeNativePtr(new JoyTubeWin32(m_width, m_height));
#elif ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
	m_joyTubeNative = IJoyTubeNativePtr(new JoyTubeAndroid(m_width, m_height));
#elif ( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
    m_joyTubeNative = IJoyTubeNativePtr(new JoyTubeIOS(m_width, m_height));
#endif

	m_textureData = m_joyTubeNative->GetTextureData();

	float fps = cocos2d::Director::getInstance()->getFrameRate();
	cocos2d::Director::getInstance()->getScheduler()->schedule(
		schedule_selector(JoyTube::Process),
		this,
		fps,
		false
		);

	m_callEndOfFramesListener = cocos2d::Director::getInstance()->getEventDispatcher()->addCustomEventListener(cocos2d::Director::EVENT_AFTER_DRAW, [this](EventCustom* eventCustom) {
		this->CallEndOfFrames();
	});
}

JoyTube::~JoyTube()
{
	CCLOG("~JoyTube");
	m_sprite->release();
	cocos2d::Director::getInstance()->getEventDispatcher()->removeEventListener(m_callEndOfFramesListener);
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

void JoyTube::RegisterLua()
{
	luabridge::getGlobalNamespace(LuaEngine::getInstance()->getLuaStack()->getLuaState())
		.beginNamespace("Inanna")
		.addFunction("GetJoyTube", &JoyTube::getInstance)
		.beginClass<JoyTube>("JoyTube")
		.addConstructor<void(*) ()>()
		.addFunction("AddSprite", &JoyTube::AddSprite)
		// .addFunction("OnTouch", &JoyTube::OnTouch)
		.addFunction("SetMouseEvent", &JoyTube::SetMouseEvent)
		.addFunction("SetMouseEventf", &JoyTube::SetMouseEventf)
		.addData("m_testInt", &JoyTube::m_testInt)
		.addFunction("SetSourcePath", &JoyTube::SetSourcePath)
		.addFunction("InitPlugin", &JoyTube::InitPlugin)
		.addFunction("OnLeaveGame", &JoyTube::OnLeaveGame)
		.addFunction("OnRecvUserInfo", &JoyTube::OnRecvUserInfo)
		.addFunction("SetMusicMute", &JoyTube::SetMusicMute)
		.addFunction("SetGameInfoOpen", &JoyTube::SetGameInfoOpen)
		.addFunction("SetInputActive", &JoyTube::SetInputActive)
		.addFunction("Abort", &JoyTube::Abort)
		.addFunction("RegisterCreditEventCB", &JoyTube::RegisterCreditEventCB)
		.addFunction("RegisterErrorStatusCB", &JoyTube::RegisterErrorStatusCB)
		.addFunction("ResetErrorStatus", &JoyTube::ResetErrorStatus)
		.addFunction("GetIsAutoPlay", &JoyTube::GetIsAutoPlay)
		.addFunction("GetGameStatus", &JoyTube::GetGameStatus)
		.addFunction("GetPlayState", &JoyTube::GetPlayState)
		.addFunction("IsEnteringSetting", &JoyTube::IsEnteringSetting)
		.addFunction("SendMessage", &JoyTube::SendMessages)
		.addFunction("IsPostMessage", &JoyTube::IsPostMessage)
		.addFunction("GetPostMessageString", &JoyTube::GetPostMessageString)
		// .addFunction("OnPullButton", &JoyTube::OnPushButton)
		// .addFunction("OnPushButton", &JoyTube::OnPushButton)
		.endClass()
		.endNamespace();
}

void JoyTube::AddSprite(luabridge::LuaRef node)
{
	auto scene = Director::getInstance()->getRunningScene();
	if (!scene)
	{
		CCLOG("JoyTube::AddSprite getRunningScene fail");
		return;
	}

	cocos2d::Node* parentNode = static_cast<cocos2d::Node*>(tolua_tousertype(node.state(), 0, 0));
	if (!parentNode->getChildByName(m_spriteName))
	{
		m_sprite->setAnchorPoint(Vec2(0, 0));
		parentNode->addChild(m_sprite);
	}
}

// void JoyTube::OnTouch(int phase, int x, int y)
// {
// 	CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
// 	m_joyTubeNative->OnTouch(phase, x, y);
// }

// phase = 0 // down
// phase = 1 // move
// phase = 3 // up
void JoyTube::SetMouseEvent(int phase, int x, int y)
{
    CCLOG("joyTube OnTouch x:%d y:%d phase:%d", x, y, phase);
    m_joyTubeNative->n_setMouseEvent(phase, x, y);
    
}

void JoyTube::SetMouseEventf(int phase, float x, float y)
{
    CCLOG("joyTube OnTouch x:%f y:%f phase:%d", x, y, phase);
    m_joyTubeNative->n_setMouseEventf(phase, x, y);
}

void JoyTube::Process(float tick)
{
	//CCLOG("JoyTube::Process tick %f", tick);

	if (m_joyTubeNative->n_isCreditEvent())
	{
		const int chip = m_joyTubeNative->n_isCredit();
		if (m_creditEventCallback)
		{
			m_creditEventCallback(chip);
		}
	}

	const int errorStatus = m_joyTubeNative->n_isErrorDefine();
	if (errorStatus != 0)
	{
		if (m_errorStatusCallback)
		{
			m_errorStatusCallback(errorStatus);
		}
	}
}

void JoyTube::CallEndOfFrames()
{
	//CCLOG("JoyTube::CallEndOfFrames tick %f", cocos2d::Director::getInstance()->getDeltaTime());

	//UpdateTextureData();
    m_joyTubeNative->n_NativeStep();
}

void JoyTube::UpdateTextureData()
{
	m_texture2D->updateWithData(m_textureData, 0, 0, m_width, m_height);
}

void JoyTube::SetSourcePath(std::string sourcePath)
{
	std::string fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(sourcePath + "nativeResTest.txt");
	CCLOG("JoyTube::Path:%s", fullPath.c_str());

	std::string content = FileUtils::getInstance()->getStringFromFile(fullPath);
	CCLOG("JoyTube::NativaResTestFile Content:%s", content.c_str());

	size_t lastSlash = fullPath.find_last_of("/\\");
	std::string nativeResPath = fullPath.substr(0, lastSlash + 1);
	
	CCLOG("JoyTube::NativeResPath:%s", nativeResPath.c_str());
    m_joyTubeNative->n_stringFromUnity(nativeResPath.c_str());
#if    ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
    std::string path = "/storage/emulated/0/Android/data/org.cocos2dx.SandBox/files/";
	m_joyTubeNative->n_stringFromUnity(path);
#endif
}

void JoyTube::InitPlugin(int left, int top, int width, int height, bool local)
{
	m_joyTubeNative->n_native(left, top, width, height, local, false, m_texture2D->getName());
}

void JoyTube::OnLeaveGame()
{
	m_creditEventCallback = nullptr;
	m_errorStatusCallback = nullptr;
	m_joyTubeNative->n_GameDestroy();
}

void JoyTube::OnRecvUserInfo(int coin)
{
	m_joyTubeNative->n_setCredit(coin);
}

void JoyTube::SetMusicMute(bool isMute)
{
	m_joyTubeNative->n_setSoundMute(isMute);
}

void JoyTube::SetGameInfoOpen(bool isOpen)
{
	m_joyTubeNative->n_openGameInfo(isOpen);
}

void JoyTube::SetInputActive(bool isActive)
{
	m_joyTubeNative->n_SetInputActive(isActive);
}

void JoyTube::Abort()
{
	m_joyTubeNative->n_setAbort();
}

void JoyTube::RegisterCreditEventCB(luabridge::LuaRef cb)
{
	m_creditEventCallback = [cb](int chip)
	{
		cb(chip);
	};
}

void JoyTube::RegisterErrorStatusCB(luabridge::LuaRef cb)
{
	m_errorStatusCallback = [cb](int chip)
	{
		cb(chip);
	};
}

void JoyTube::ResetErrorStatus()
{
	m_joyTubeNative->n_clearErrorDefine();
}

bool JoyTube::GetIsAutoPlay()
{
	return m_joyTubeNative->n_isAutoPlay();
}

int JoyTube::GetGameStatus()
{
	return m_joyTubeNative->n_isGameStatus();
}

int JoyTube::GetPlayState()
{
	return m_joyTubeNative->n_isPlayState();
}

bool JoyTube::IsEnteringSetting()
{
	return m_joyTubeNative->n_enteringSetting();
}

int JoyTube::SendMessages(char const* system, char const* cmd, char const* jsonstring)
{
	//CCLOG("JoyTube::SendMessages %s", system);
	return m_joyTubeNative->n_sendMessage(cmd, jsonstring);
}

int JoyTube::IsPostMessage()
{
    int post =m_joyTubeNative->n_isPostMessage();
    if(post != 0) CCLOG("JoyTube::postMessage:%d", post);
	return post;
}
std::string JoyTube::GetPostMessageString()
{
	return (const char*)m_joyTubeNative->n_getPostMessageString();
}

// void JoyTube::OnPushButton(int type)
// {
// 	m_joyTubeNative->n_PushButtons(type);
// }
// void JoyTube::OnPullButton(int type)
// {
// 	m_joyTubeNative->n_PullButtons(type);
// }
