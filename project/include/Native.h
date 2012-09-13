#ifndef NativeDevice
#define NativeDevice

namespace native 
{	
    extern bool retina;
	extern bool retinaInit;

    void initDevice();
	const char* os();
	const char* vervion();
	const char* deviceName();
	const char* model();
	bool isRetina();
	bool networkAvailable();
	void vibrate(float milliseconds);
    
    void showSystemAlert(const char* title, const char* message);
    void showLoadingScreen();
    void hideLoadingScreen();
}

#endif
