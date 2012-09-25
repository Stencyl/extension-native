#ifndef NativeDevice
#define NativeDevice

namespace native 
{	
    void initDevice();
	const char* os();
	const char* vervion();
	const char* deviceName();
	const char* model();
	bool networkAvailable();
	void vibrate(float milliseconds);
	void setBadgeNumber(int n);
    
    void showSystemAlert(const char* title, const char* message);
    void showLoadingScreen();
    void hideLoadingScreen();
}

#endif
