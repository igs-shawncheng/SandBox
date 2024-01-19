#include "Downloader.h"
#include "platform/CCFileUtils.h"
#include <curl/curl.h>


Downloader *Downloader::_instance = nullptr;

Downloader *Downloader::getInstance()
{
	if (!_instance)
	{
		_instance = new Downloader();
	}
	return _instance;
}

Downloader::Downloader()
{

}

Downloader::~Downloader()
{
	CCLOG("~Downloader");
}

void Downloader::RegisterLua()
{
	luabridge::getGlobalNamespace(LuaEngine::getInstance()->getLuaStack()->getLuaState())
		.beginNamespace("Inanna")
			.addFunction("GetDownloader", &Downloader::getInstance)
			.beginClass<Downloader>("Downloader")
				.addConstructor<void(*) ()>()
				.addFunction("StartDownloadGame", &Downloader::StartDownloadGame)
				.addFunction("DownloadGameProgress", &Downloader::DownloadGameProgress)
				.addFunction("DownloadGameFinish", &Downloader::DownloadGameFinish)
				.addFunction("StartDownloadVersion", &Downloader::StartDownloadVersion)
				.addFunction("GetDownloadVersionInfo", &Downloader::GetDownloadVersionInfo)
				.addFunction("DownloadVersionFinish", &Downloader::DownloadVersionFinish)
				.addFunction("GetLocalVersionInfo", &Downloader::GetLocalVersionInfo)
				.addFunction("LocalVersionIsExist", &Downloader::LocalVersionIsExist)
				.addFunction("StoreDownloadVersion", &Downloader::StoreDownloadVersion)
			.endClass()
		.endNamespace();
}

void Downloader::StartDownloadGame()
{
	
}

double Downloader::DownloadGameProgress()
{
    return 10;//progress;
}

bool Downloader::DownloadGameFinish()
{
    return true;
}

void Downloader::StartDownloadVersion()
{

}

std::string Downloader::GetDownloadVersionInfo()
{
	std::string str = "{}";
	return str;
}

bool Downloader::DownloadVersionFinish()
{
	return true;
}

std::string Downloader::GetLocalVersionInfo()
{
	std::string str = "{}";
	return str;
}

bool Downloader::LocalVersionIsExist()
{
	return true;
}

void Downloader::StoreDownloadVersion()
{
	
}
