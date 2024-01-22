#include "Downloader.h"
#include "platform/CCFileUtils.h"
#include <curl/curl.h>
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
#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	downloadAndSendToJava("test_download");
#endif
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

#if  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
void Downloader::downloadAndSendToJava(const std::string& url) {
    // 在這裡下載文件並獲取下載的文件路徑
    std::string downloadedFilePath = "test_download";// downloadFile(url);

    // 使用 JniHelper 呼叫 Java 方法，將下載的文件路徑作為參數傳遞
    sendFilePathToJava(downloadedFilePath);
}

void Downloader::sendFilePathToJava(const std::string& filePath) {
    JniMethodInfo methodInfo;

    if (JniHelper::getStaticMethodInfo(methodInfo,
										"org/cocos2dx/lua/AppActivity",
										"javaMethodWithFilePath",
										"(Ljava/lang/String;)V")) {
        // 將 C++ 字符串轉換為 Java 字符串
        jstring filePathArg = methodInfo.env->NewStringUTF(filePath.c_str());

        // 呼叫 Java 方法，傳遞文件路徑參數
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, filePathArg);

        // 釋放資源
        methodInfo.env->DeleteLocalRef(filePathArg);
        methodInfo.env->DeleteLocalRef(methodInfo.classID);
    }
}
#endif
