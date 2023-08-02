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
#endif

class JoyTube : public cocos2d::Ref
{
public:
	static JoyTube *getInstance();
	JoyTube();
	virtual ~JoyTube();

	void RegisterLua();

	void AddSprite(luabridge::LuaRef node);
	void OnTouch(int x, int y);

	void SetSourcePath(std::string sourcePath);
	void InitPlugin(int left, int top, int width, int height, bool local);
	void OnLeaveGame();
	void SetMusicMute(bool isMute);
	void SetGameInfoOpen(bool isOpen);
	void SetInputActive(bool isActive);
	void Abort();
	void RegisterCreditEventCB(luabridge::LuaRef cb);
	void RegisterErrorStatusCB(luabridge::LuaRef cb);
	void ResetErrorStatus();
	int GetGameStatus();
	int GetPlayState();
	bool IsEnteringSetting();
	
	int m_testInt = 640;
protected:
	static JoyTube *_instance;

	IJoyTubeNativePtr m_joyTubeNative;

	unsigned char *m_textureData;
	cocos2d::Texture2D *m_texture2D;
	cocos2d::Sprite *m_sprite;

	int m_width = 640;
	int m_height = 1136;
	std::string m_spriteName = "JoyTubeSprite";

	void InitTube();

	void Process(float tick);
	void UpdateTextureData();

	void CallEndOfFrames();
private:
	typedef std::function< void(int) > OnCreditEventCallback;
	OnCreditEventCallback m_creditEventCallback = nullptr;

	typedef std::function< void(int) > OnErrorStatusCallback;
	OnErrorStatusCallback m_errorStatusCallback = nullptr;

	EventListenerCustom* m_callEndOfFramesListener;
};

