#include <memory>

struct IJoyTubeNative
{
	virtual ~IJoyTubeNative() {};

	virtual unsigned char* GetTextureData() = 0;
	virtual void OnTouch(int x, int y) = 0;
};

typedef std::shared_ptr<IJoyTubeNative> IJoyTubeNativePtr;