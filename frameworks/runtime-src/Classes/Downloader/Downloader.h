#pragma once

#include <string>
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"
#include "network/HttpClient.h"

class Downloader
{
public:
	static Downloader *getInstance();
	Downloader();
	virtual ~Downloader();

	void RegisterLua();
	void StartDownloadGame();
	float DownloadGameProgress();
	bool DownloadGameFinish();
	void StartDownloadVersion();
	std::string GetDownloadVersionInfo();
	bool DownloadVersionFinish();
	std::string GetLocalVersionInfo();
	bool LocalVersionIsExist();
	void StoreDownloadVersion();
	std::string versionPath;
	std::string localVersionInfo = "None";
	std::string downloadVersionInfo = "None";
	float downloadPercentage = 0.0f;
	void onProgress(network::HttpClient* , network::HttpResponse*, const std::string&);
	void downloadFile(const std::string&, const std::string&);
	void saveDownloadedFile(const std::string&, const char*, ssize_t);
	int getTotalBytesFromResponse(network::HttpResponse*);
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	void saveGameDataToAndroid(const std::string&, const std::string&);
#endif
protected:
	static Downloader *_instance;
};

