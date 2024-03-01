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
	void FinishDownloadGameDescription(const std::string& url, network::HttpClient*, network::HttpResponse*);
	void FinishDownloadGamePart(const std::string& filename, network::HttpClient*, network::HttpResponse*);
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
	void setDownloadPath();
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	std::string getExternalStoragePath();
	void setDownloadPathAndroid();
#endif
protected:
	static Downloader *_instance;

private:
	struct GameFile
	{
		long length;
		int totalCount;
		int receivedCount;
	};

	typedef std::map<std::string, GameFile> GameFiles;
	GameFiles m_gameFiles;
};

