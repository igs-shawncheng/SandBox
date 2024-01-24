#include "Downloader.h"
#include "platform/CCFileUtils.h"
#include "network/HttpClient.h"

#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "platform/android/jni/JniHelper.h"
#endif


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
	versionPath = FileUtils::getInstance()->getWritablePath() + "Version.json";
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

float Downloader::DownloadGameProgress()
{
    return 10;//downloadPercentage;
}

bool Downloader::DownloadGameFinish()
{
    return true;
}

void Downloader::StartDownloadVersion()
{
	downloadFile("https://cdn-g.gametower.com.tw/rd5/tmd_mobile/data/win/Inanna/InannaLua/Version.json", versionPath);
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
	localVersionInfo = FileUtils::getInstance()->getStringFromFile(versionPath);
	return localVersionInfo;
}

bool Downloader::LocalVersionIsExist()
{
	CCLOG("%s", versionPath.c_str());
	if (FileUtils::getInstance()->isFileExist(versionPath))
		return true;
	else
		return false;
}

void Downloader::StoreDownloadVersion()
{
	std::string targetPath = versionPath;
	bool success = FileUtils::getInstance()->writeStringToFile(downloadVersionInfo, targetPath);

    if (success) {
        CCLOG("Save success: %s", targetPath.c_str());
    } else {
        CCLOG("Save file Fail");
    }
}
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
void Downloader::saveGameDataToAndroid(const std::string& filename, const std::string& content)
{
    std::string targetPath = "/storage/emulated/0/Android/data/org.cocos2dx.sandbox/files/" + filename;

    bool success = FileUtils::getInstance()->writeStringToFile(content, targetPath);

    if (success) {
        CCLOG("Save success: %s", targetPath.c_str());
    } else {
        CCLOG("Save file Fail");
    }
}
#endif
void Downloader::onProgress(network::HttpClient* client, network::HttpResponse* response, const std::string& savePath)
{
	if (!response->isSucceed()) {
		CCLOG("Download failed: %s", response->getErrorBuffer());
	} else {
		// get download data
		std::vector<char>* buffer = response->getResponseData();
		
		// get download bytes
		int downloadedBytes = buffer->size();

		// get progress
		int totalBytes = getTotalBytesFromResponse(response);
		downloadPercentage = (totalBytes > 0) ? (static_cast<float>(downloadedBytes) / totalBytes) * 100.0f : 0.0f;

		CCLOG("Download progress: %.2f%%", downloadPercentage);
		// save file
		saveDownloadedFile(savePath, buffer->data(), downloadedBytes);

        CCLOG("File downloaded successfully to: %s", savePath.c_str());
	}
}

int Downloader::getTotalBytesFromResponse(network::HttpResponse* response)
{
	std::vector<char>* headersData = response->getResponseHeader();
	std::string headersString(headersData->begin(), headersData->end());
	
	// check Content-Length to get totalBytes
	int totalBytes = 0;
	size_t pos = headersString.find("Content-Length:");
	if (pos != std::string::npos)
	{
		pos += strlen("Content-Length:");
		totalBytes = std::stoi(headersString.substr(pos));
	}

	return totalBytes;
}

void Downloader::downloadFile(const std::string& url, const std::string& savePath)
{
	network::HttpRequest* request = new network::HttpRequest();
	request->setUrl(url);
	request->setRequestType(cocos2d::network::HttpRequest::Type::GET);

	request->setResponseCallback([=](network::HttpClient* client, network::HttpResponse* response) {
			Downloader::onProgress(client, response, savePath);
		});

	network::HttpClient::getInstance()->send(request);
	request->release();
}

void Downloader::saveDownloadedFile(const std::string& filePath, const char* data, ssize_t dataSize)
{
	// uses FileUtils to save file
	FileUtils::getInstance()->writeStringToFile(std::string(data, dataSize), filePath);
}