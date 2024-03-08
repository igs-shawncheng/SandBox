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
				.addFunction("Start", &Downloader::Start)
				.addFunction("GetProgress", &Downloader::GetProgress)
			.endClass()
		.endNamespace();
}

void Downloader::Start()
{
	// Reset GameFiles
	m_gameFiles.clear();

	// Download verion.json
	const std::string url = "http://dl.gametower.com.tw/rd5/tmd_test/pachinslot/";
	const std::string filename = "Version.json";

	network::HttpRequest* req = new network::HttpRequest();
	req->setUrl(url + filename);
	req->setRequestType(cocos2d::network::HttpRequest::Type::GET);
	req->setResponseCallback([=](network::HttpClient* clt, network::HttpResponse* resp) {
		Downloader::FinishVersion(resp, url, filename); });
	network::HttpClient::getInstance()->send(req);
	req->release();
}

void Downloader::FinishVersion(network::HttpResponse* resp, const std::string& url, const std::string& versionFilename)
{
	if (!resp->isSucceed())
	{
		CCLOG("Failed to download version.json, reason: %s", resp->getErrorBuffer());
		m_gameFiles["None"] = GameFile(100, 100);
		return;
	}

	std::vector<char>* buf = resp->getResponseData();
	nlohmann::json downloadedJson = nlohmann::json::parse(std::string(buf->begin(), buf->end()));

	std::string fullPath = FileUtils::getInstance()->getWritablePath() + versionFilename;
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	fullPath = getExternalStoragePath() + "Android/data/org.cocos2dx.sandbox/files/" + versionFilename;
#endif

	if (FileUtils::getInstance()->isFileExist(fullPath))
	{
		const std::string currentStr = FileUtils::getInstance()->getStringFromFile(fullPath);
		nlohmann::json currentJson = nlohmann::json::parse(currentStr);
		if (downloadedJson["version"] == currentJson["version"])
		{
			CCLOG("Version is not changed so no need to be downloaded");
			m_gameFiles["None"] = GameFile(100, 100);
			return;
		}
	}

	// Replace version.json
	FileUtils::getInstance()->writeStringToFile(downloadedJson.dump(), fullPath);

	// Download description.txt
	const std::string filename = "description.txt";
	network::HttpRequest* req = new network::HttpRequest();
	req->setUrl(url + filename);
	req->setRequestType(cocos2d::network::HttpRequest::Type::GET);
	req->setResponseCallback([=](network::HttpClient* clt, network::HttpResponse* resp) {
		Downloader::FinishDescription(resp, url); });
	network::HttpClient::getInstance()->send(req);
	req->release();
}

void Downloader::FinishDescription(network::HttpResponse* resp, const std::string& url)
{
	if (!resp->isSucceed())
	{
		CCLOG("Failed to download description.txt, reason: %s", resp->getErrorBuffer());
		m_gameFiles["None"] = GameFile(100, 100);
		return;
	}

	std::vector<char>* buf = resp->getResponseData();
	nlohmann::json json = nlohmann::json::parse(std::string(buf->begin(), buf->end()));

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
		gameFile.totalCount = subJson["Count"];

		for (int i = 1; i <= gameFile.totalCount; ++i)
		{
			network::HttpRequest* req = new network::HttpRequest();
			req->setUrl(url + filename + "/" + std::to_string(i));
			req->setRequestType(cocos2d::network::HttpRequest::Type::GET);
			req->setResponseCallback([=](network::HttpClient* clt, network::HttpResponse* resp) {
				Downloader::FinishResource(resp, filename); });
			network::HttpClient::getInstance()->send(req);
			req->release();
		}
	}
}

void Downloader::FinishResource(network::HttpResponse* resp, const std::string& resourceFilename)
{
	if (!resp->isSucceed())
	{
		CCLOG("Failed to download %s, reason: %s", resourceFilename.c_str(), resp->getErrorBuffer());
		return;
	}

	std::string fullPath = FileUtils::getInstance()->getWritablePath() + resourceFilename;
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	fullPath = getExternalStoragePath() + "/Android/data/org.cocos2dx.sandbox/files/" + resourceFilename;
#endif

	std::vector<char>* buf = resp->getResponseData();
	std::ofstream ofs(fullPath, std::ios_base::binary | std::ios_base::app);
	ofs.write(reinterpret_cast<const char*>(buf->data()), sizeof(char) * buf->size());
	ofs.close();

	GameFile& gameFile = m_gameFiles[resourceFilename];
	gameFile.receivedCount += 1;
	CCLOG("Downloading %s, part %d of %d", resourceFilename.c_str(), gameFile.receivedCount, gameFile.totalCount);
}

float Downloader::GetProgress()
{
	int totalCount = 0, receivedCount = 0;
	for (const auto& gameFile : m_gameFiles)
	{
		totalCount += gameFile.second.totalCount;
		receivedCount += gameFile.second.receivedCount;
	}

	return totalCount > 0 ? static_cast<float>(receivedCount) / totalCount * 100 : 0;
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
#endif