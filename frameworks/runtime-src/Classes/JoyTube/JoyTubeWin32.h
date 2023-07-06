#pragma once

#include "IJoyTubeNative.h"

typedef unsigned char* (*libInitFun)(int width, int height);
typedef void(*libInputXYFun)(int x, int y);

struct HandleData;

class JoyTubeWin32: public IJoyTubeNative
{
public:
	JoyTubeWin32(int width, int height);
	virtual ~JoyTubeWin32();

	unsigned char* GetTextureData();

	void OnTouch(int x, int y);

	void UnLoadLibrary();
protected:
	HandleData* m_hData;
	unsigned char *m_textureData;

	int m_width = 640;
	int m_height = 1136;

	void InitLibrary();
	
	void TestLibInputXY(int x, int y);
};

