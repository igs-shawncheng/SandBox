#include <fstream>
#include <cstdio>
#include <codecvt>
#include <nlohmann/json.hpp>
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
	const std::string url = "http://dl.gametower.com.tw/rd5/tmd_test/pachinslot/";
	network::HttpRequest* req = new network::HttpRequest();
	req->setUrl(url + "description.txt");
	req->setRequestType(cocos2d::network::HttpRequest::Type::GET);
	req->setResponseCallback([=](network::HttpClient* clt, network::HttpResponse* resp) {
		Downloader::FinishDownloadGameDescription(url, clt, resp); });

	network::HttpClient::getInstance()->send(req);
	req->release();
}

void Downloader::FinishDownloadGameDescription(const std::string& url, network::HttpClient* clt, network::HttpResponse* resp)
{
	if (!resp->isSucceed())
	{
		CCLOG("Downloading Game Description failed: %s", resp->getErrorBuffer());
		return;
	}

	m_gameFiles.clear();
	std::vector<char>* buf = resp->getResponseData();
	std::string descFile(buf->begin(), buf->end());
	nlohmann::json json = nlohmann::json::parse(descFile);

	for (const auto& item : json.items())
	{
		const std::string filename = item.key();
		nlohmann::json subJson = item.value();

		std::string fullPath = FileUtils::getInstance()->getWritablePath() + filename;
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
		fullPath = getExternalStoragePath() + "/Android/data/org.cocos2dx.sandbox/files/" + filename;
#endif
		std::remove(fullPath.c_str());

		GameFile& gameFile = m_gameFiles[filename];
		gameFile.length = subJson["Length"];
		gameFile.totalCount = subJson["Count"];

		for (int i = 1; i <= m_gameFiles[filename].totalCount; ++i)
		{
			network::HttpRequest* req = new network::HttpRequest();
			req->setUrl(url + filename + "/" + std::to_string(i));
			req->setRequestType(cocos2d::network::HttpRequest::Type::GET);
			req->setResponseCallback([=](network::HttpClient* clt, network::HttpResponse* resp) {
				Downloader::FinishDownloadGamePart(filename, clt, resp); });
			network::HttpClient::getInstance()->send(req);
			req->release();
		}
	}
}

void Downloader::FinishDownloadGamePart(const std::string& filename, network::HttpClient* clt, network::HttpResponse* resp)
{
	if (!resp->isSucceed())
	{
		CCLOG("Downloading Game Part failed: %s", resp->getErrorBuffer());
		return;
	}

	std::string fullPath = FileUtils::getInstance()->getWritablePath() + filename;
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	fullPath = getExternalStoragePath() + "/Android/data/org.cocos2dx.sandbox/files/" + filename;
#endif

	std::vector<char>* buf = resp->getResponseData();
	std::ofstream ofs(fullPath, std::ios_base::binary | std::ios_base::app);
	ofs.write(reinterpret_cast<const char*>(buf->data()), sizeof(char) * buf->size());
	ofs.close();

	m_gameFiles[filename].receivedCount += 1;
	CCLOG("Downloading game file %s, part %d", filename.c_str(), m_gameFiles[filename].receivedCount);
}

float Downloader::DownloadGameProgress()
{
	int totalCounts = 0;
	int receivedCounts = 0;
	for (const auto& gameFile : m_gameFiles)
	{
		totalCounts += gameFile.second.totalCount;
		receivedCounts += gameFile.second.receivedCount;
	}

	downloadPercentage = (totalCounts > 0) ? (static_cast<float>(receivedCounts) / totalCounts) * 100.0f : 0.0f;
    return downloadPercentage;
}

bool Downloader::DownloadGameFinish()
{
	if(downloadPercentage != 100)
    	return false;
	else
		return true;
}

void Downloader::StartDownloadVersion()
{
	setDownloadPath();
	downloadFile("https://cdn-g.gametower.com.tw/rd5/tmd_mobile/data/win/Inanna/InannaLua/Version.json", versionPath);
}

std::string Downloader::GetDownloadVersionInfo()
{
	std::string str = "{}";
	return str;
}

bool Downloader::DownloadVersionFinish()
{
	if(downloadPercentage != 100)
    	return false;
	else
		return true;
}

std::string Downloader::GetLocalVersionInfo()
{
	localVersionInfo = FileUtils::getInstance()->getStringFromFile(versionPath);
	CCLOG("localVersionInfo %s", localVersionInfo.c_str());
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

void Downloader::setDownloadPath()
{
	versionPath = FileUtils::getInstance()->getWritablePath() + "Version.json";
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	setDownloadPathAndroid();
	versionPath = versionPath + "/Android/data/org.cocos2dx.sandbox/files/Version.json";
#endif
}

#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
std::string Downloader::getExternalStoragePath()
{
    JniMethodInfo methodInfo;
    if (cocos2d::JniHelper::getStaticMethodInfo(methodInfo, "org/cocos2dx/lua/AppActivity", "getExternalStoragePath", "()Ljava/lang/String;"))
	{
        jstring jstr = (jstring)methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        const char* path = methodInfo.env->GetStringUTFChars(jstr, nullptr);
        std::string externalStoragePath = path;
        methodInfo.env->ReleaseStringUTFChars(jstr, path);
        methodInfo.env->DeleteLocalRef(methodInfo.classID);
        return externalStoragePath;
    }
	else
	{
        return "";
    }
}

void Downloader::setDownloadPathAndroid()
{
	versionPath = getExternalStoragePath(); // path: /storage/emulated/0
	CCLOG("External Storage Path: %s", getExternalStoragePath().c_str());
}
#endif