#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Native.h"
#include <stdio.h>

using namespace native;

#ifdef IPHONE

value native_device_os()
{
	return alloc_string(os());
}
DEFINE_PRIM(native_device_os,0);

value native_device_vervion()
{
	return alloc_string(vervion());
}
DEFINE_PRIM(native_device_vervion,0);

value native_device_name()
{
	return alloc_string(deviceName());
}
DEFINE_PRIM(native_device_name,0);

value native_device_model()
{
	return alloc_string(model());
}
DEFINE_PRIM(native_device_model,0);

value native_device_is_retina()
{
	return alloc_bool(isRetina());
}
DEFINE_PRIM(native_device_is_retina,0);

value native_device_network_available()
{
	return alloc_bool(networkAvailable());
}
DEFINE_PRIM(native_device_network_available,0);

void native_device_vibrate(value time)
{
	vibrate(val_float(time));
}
DEFINE_PRIM(native_device_vibrate,1);

void native_system_ui_show_alert(value title,value message)
{
	showSystemAlert(val_string(title),val_string(message));
}
DEFINE_PRIM(native_system_ui_show_alert,2);

void native_system_ui_show_system_loading_view()
{
	showLoadingScreen();
}
DEFINE_PRIM(native_system_ui_show_system_loading_view,0);

void native_system_ui_hide_system_loading_view()
{
	hideLoadingScreen();
}
DEFINE_PRIM(native_system_ui_hide_system_loading_view,0);

#endif

extern "C" void native_main() 
{	
	// Here you could do some initialization, if needed	
}
DEFINE_ENTRY_POINT(native_main);

extern "C" int native_register_prims() 
{ 
    return 0; 
}