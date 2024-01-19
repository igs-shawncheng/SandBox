#pragma once

#include <string>
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaBridge.h"
#include "LuaBridge.h"

class Downloader
{
public:
	static Downloader *getInstance();
	Downloader();
	virtual ~Downloader();

	void RegisterLua();
	void StartDownloadGame();
	double DownloadGameProgress();
	bool DownloadGameFinish();
	void StartDownloadVersion();
	std::string GetDownloadVersionInfo();
	bool DownloadVersionFinish();
	std::string GetLocalVersionInfo();
	bool LocalVersionIsExist();
	void StoreDownloadVersion();
protected:
	static Downloader *_instance;
};

