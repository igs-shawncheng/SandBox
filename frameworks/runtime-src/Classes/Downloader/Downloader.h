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
	void Start();
	void FinishVersion(network::HttpResponse* resp, const std::string& url, const std::string& versionFilename);
	void FinishDescription(network::HttpResponse* resp, const std::string& url);
	void FinishResource(network::HttpResponse* resp, const std::string& resourceFilename);
	float GetProgress();

#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	std::string getExternalStoragePath();
#endif

protected:
	static Downloader *_instance;

private:
	struct GameFile
	{
		GameFile() : totalCount(0), receivedCount(0) {}
		GameFile(const int& totalCount, const int& receivedCount) : totalCount(totalCount), receivedCount(receivedCount) {}

		int totalCount;
		int receivedCount;
	};

	typedef std::map<std::string, GameFile> GameFiles;
	GameFiles m_gameFiles;
};

