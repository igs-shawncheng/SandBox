#pragma once

#include "IJoyTubeNative.h"


class JoyTubeAndroid : public IJoyTubeNative
{
public:
	JoyTubeAndroid(int width, int height);
	virtual ~JoyTubeAndroid();

	unsigned char* GetTextureData();

	// void OnTouch(int phase, int x, int y);
    void SetMouseEvent(int phase, int x, int y);
    void SetMouseEventf(int phase, float x, float y);

	void UnLoadLibrary();

    void n_set_debug_log_func(DebugLogFunc func);
    int n_native(int left, int top, int width, int height, bool local, bool master, unsigned int texID);
    void n_startTimer(bool atfirst);
    void n_checkTimer();
    bool n_passStartGame();
    int n_sendMessage(std::string cmd, std::string jsonstring);
    int n_useItem(std::string jsonstring);
    int n_isUsedItem();
    void n_setCredit(double credit);
    double n_isCredit();
    bool n_isCreditEvent();
    int n_isGameStatus();
    int n_isPlayState();
    bool n_isAutoPlay();
    int n_isErrorDefine();
    void n_clearErrorDefine();
    int n_isPostMessage();
    int* n_getPostMessageString();
    void n_openGameInfo(bool isActive);
    int* n_getJsonString();
    void n_stringFromUnity(std::string str);
    int n_logout();
    int* n_CreateTextureFunc();
    int n_isTextureId();
    int n_isTextureWidth();
    int n_isTextureHeight();
    int n_isTextureWidthGl();
    int n_isTextureHeightGl();
    void n_NativeStep();
    int n_isRenderTextureId(int side);
    int n_isRenderTextureWidth(int side);
    int n_isRenderTextureHeight(int side);
    int n_isRenderTextureWidthGl(int side);
    int n_isRenderTextureHeightGl(int side);
    int n_isRenderTextureSide();
    bool n_isDrawRenderTexture();
    int n_isFinishInitialize();
    bool n_isArrivedUpdateTex();
    int n_isArrivedTextureId();
    int n_isArrivedTextureWidth();
    int n_isArrivedTextureHeight();
    int n_isArrivedTextureWidthGl();
    int n_isArrivedTextureHeightGl();
    int n_isArrivedTextureFormat();
    // void n_PushButtons(int type);
    // void n_PullButtons(int type);
	void n_setMouseEvent(int phase, int x, int y);
	void n_setMouseEventf(int phase, float x, float y);
    void n_toPause(bool pause);
    void n_GameDestroy();
    void n_setSoundMute(bool isMute);
    bool n_enteringSetting();
    void n_SetInputActive(bool bActive);
    void n_setAbort();
#if defined(ANDROID)
    void n_setJavaVM(jobject* object);
#endif
protected:
	unsigned char* m_textureData;

	int m_width = 640;
	int m_height = 1136;

	void InitLibrary();

	// void TestLibInputXY(int phase, int x, int y);
};

