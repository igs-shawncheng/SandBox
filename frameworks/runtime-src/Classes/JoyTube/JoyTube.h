#pragma once

#include <string>
#include "renderer/CCTexture2D.h"
#include "2d/CCSprite.h"
#include "base/CCRef.h"
#include "JoyTubeWin32.h"

class JoyTube : public cocos2d::Ref
{
public:
	static JoyTube *getInstance();
	JoyTube();
	virtual ~JoyTube();

	void RegisterLua();
	
	void Init();
	void AddSprite();
	void OnTouch(int x, int y);
	
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
};

