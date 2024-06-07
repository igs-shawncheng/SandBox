#pragma once

#include <string>
#include "renderer/CCTexture2D.h"
#include "2d/CCSprite.h"
#include "base/CCRef.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#if ( CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 )
#include "JoyTubeWin32.h"
#elif ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "JoyTubeAndroid.h"
#elif ( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
#include "JoyTubeIOS.h"
#endif

class JoyTube : public cocos2d::Ref
{
public:
	void NativeCallJava();

	static JoyTube *getInstance();
	JoyTube();
	virtual ~JoyTube();

	void RegisterLua();

	void LoadUnity();

protected:
	static JoyTube *_instance;

	int m_width = 640;
	int m_height = 1136;
	std::string m_spriteName = "JoyTubeSprite";

	void Process(float tick);
};

