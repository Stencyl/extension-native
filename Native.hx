package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

import nme.utils.ByteArray;
import nme.display.BitmapData;
import nme.geom.Rectangle;

class Native 
{	
	private static var contentScaleFactor:Int = 1;
	private static var forceRetina:Bool = false;
	
	public static function osName():String
	{
		#if cpp
		return native_device_os();
		#end
		
		#if !cpp
		return "";
		#end
	}
	
	public static function osVersion():String
	{
		#if cpp
		return native_device_vervion();
		#end
		
		#if !cpp
		return "";
		#end
	}
	
	public static function deviceName():String
	{
		#if cpp
		return native_device_name();
		#end
		
		#if !cpp
		return "";
		#end
	}
	
	public static function model():String
	{
		#if cpp
		return native_device_model();
		#end
		
		#if !cpp
		return "";
		#end
	}
	
	public static function networkAvailable():Bool
	{
		#if cpp
		return native_device_network_available();
		#end
		
		#if !cpp
		return false;
		#end
	}
	
	public static function vibrate(time:Float):Void
	{
		#if cpp
		native_device_vibrate(time);
		#end
	}
	
	public static function isRetina():Bool
	{
		#if cpp
		if(forceRetina)	
		{
			return true;
		}
		
		return native_device_is_retina();
		#end
		
		#if !cpp
		return false;
		#end
	}
	
	public static function scaleFactor():Float
	{
		#if cpp
	    if(isRetina())
	    {
	    	contentScaleFactor = 2;
	    }
	    
	    else
	    {
	    	contentScaleFactor = 1;
	    }
		
		return contentScaleFactor;
		#end
		
		#if !cpp
		return 0;
		#end
	}
	
	//---
	
	private static var alertTitle:String;
	private static var alertMSG:String;

	public static function showAlert(title:String, message:String):Void
	{
		alertTitle = title;
		alertMSG = message;
		haxe.Timer.delay(delayAlert, 30);
	}
	
	public static function showLoadingScreen():Void
	{
		#if cpp
		native_system_ui_show_system_loading_view();
		#end
	}	
	
	public static function hideLoadingScreen():Void
	{
		#if cpp
		native_system_ui_hide_system_loading_view();
		#end
	}
	
	private static function delayAlert():Void
	{
		#if cpp
		native_system_ui_show_alert(alertTitle, alertMSG);
		#end
	}
	
	#if cpp
	static var native_deivce_get_doc_path = nme.Loader.load("native_device_get_doc_path",0);
	static var native_deivce_get_rec_path = nme.Loader.load("native_device_get_rec_path",0);
	static var native_device_unique_id = nme.Loader.load("native_device_unique_id",0);
	static var native_device_os = nme.Loader.load("native_device_os",0);
	static var native_device_vervion = nme.Loader.load("native_device_vervion",0);
	static var native_device_name = nme.Loader.load("native_device_name",0);
	static var native_device_model = nme.Loader.load("native_device_model",0);
	static var native_device_is_retina = nme.Loader.load("native_device_is_retina",0);
	static var native_device_network_available = nme.Loader.load("native_device_network_available",0);
	static var native_device_vibrate = nme.Loader.load("native_device_vibrate",1);
	
	static var native_system_ui_show_alert = nme.Loader.load("native_system_ui_show_alert",2);
	static var native_system_ui_show_system_loading_view = nme.Loader.load("native_system_ui_show_system_loading_view",0);
	static var native_system_ui_hide_system_loading_view = nme.Loader.load("native_system_ui_hide_system_loading_view",0);
	#end
}