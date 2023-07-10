#include <memory>
#include <string>

struct IJoyTubeNative
{
	virtual ~IJoyTubeNative() {};

	virtual unsigned char* GetTextureData() = 0;
	virtual void OnTouch(int x, int y) = 0;


    //typedef void (*DebugLogFunc) (const char* str);
    //virtual void n_set_debug_log_func(DebugLogFunc func);
    virtual int n_native(int left, int top, int width, int height, bool local) = 0;
    virtual void n_startTimer(bool atfirst) = 0;
     virtual void n_checkTimer() = 0;
    virtual bool n_passStartGame() = 0;
    virtual int n_sendMessage(std::string system, std::string cmd, std::string jsonstring) = 0;
    virtual int n_useItem(std::string jsonstring) = 0;
    virtual int n_isUsedItem() = 0;
    virtual void n_setCredit(double credit) = 0;
    virtual double n_isCredit() = 0;
    virtual bool n_isCreditEvent() = 0;
    virtual int n_isGameStatus() = 0;
    virtual int n_isPlayState() = 0;
    virtual int n_isErrorDefine() = 0;
    virtual void n_clearErrorDefine() = 0;
    virtual int n_isPostMessage() = 0;
    // ※Nativeから文字列を受け取る場合、IntPtrで受けてMarshal.PtrToStringAnsi()を通すこと。
    virtual int* n_getPostMessageString() = 0;
    virtual void n_openGameInfo(bool isActive) = 0;
    virtual int* n_getJsonString() = 0;
    virtual void n_stringFromUnity(std::string str) = 0;
    virtual int n_logout() = 0;
    virtual int* n_CreateTextureFunc() = 0;
#if UNITY_IOS
    virtual IntPtr n_isTextureId() = 0;
#else
    virtual int n_isTextureId() = 0;
#endif
    virtual int n_isTextureWidth() = 0;
    virtual int n_isTextureHeight() = 0;
    virtual int n_isTextureWidthGl() = 0;
    virtual int n_isTextureHeightGl() = 0;
    virtual int* n_NativeStepFunc() = 0;
#if UNITY_IOS
    virtual int* n_isRenderTextureId(int side) = 0;
#else
    virtual int n_isRenderTextureId(int side) = 0;
#endif
    virtual int n_isRenderTextureWidth(int side) = 0;
    virtual int n_isRenderTextureHeight(int side) = 0;
    virtual int n_isRenderTextureWidthGl(int side) = 0;
    virtual int n_isRenderTextureHeightGl(int side) = 0;
    virtual int n_isRenderTextureSide() = 0;
    virtual bool n_isDrawRenderTexture() = 0;
    virtual int n_isFinishInitialize() = 0;
    virtual bool n_isArrivedUpdateTex() = 0;
#if UNITY_IOS
    virtual IntPtr n_isArrivedTextureId() = 0;
#else
    virtual int n_isArrivedTextureId() = 0;
#endif
    virtual int n_isArrivedTextureWidth() = 0;
    virtual int n_isArrivedTextureHeight() = 0;
    virtual int n_isArrivedTextureWidthGl() = 0;
    virtual int n_isArrivedTextureHeightGl() = 0;
    virtual int n_isArrivedTextureFormat() = 0;
    virtual void n_PushButtons(int type) = 0;
    virtual void n_PullButtons(int type) = 0;
    virtual void n_toPause(bool pause) = 0;
    virtual void n_GameDestroy() = 0;
    virtual void n_setSoundMute(bool isMute) = 0;
    virtual bool n_enteringSetting() = 0;
    virtual void n_SetInputActive(bool bActive) = 0;
    virtual void n_setAbort() = 0;
};

typedef std::shared_ptr<IJoyTubeNative> IJoyTubeNativePtr;