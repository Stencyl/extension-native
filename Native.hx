package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

#if android
import nme.JNI;
#end

import com.stencyl.Engine;
import com.stencyl.event.EventMaster;
import com.stencyl.event.StencylEvent;

import nme.utils.ByteArray;
import nme.display.BitmapData;
import nme.geom.Rectangle;

class Native 
{	
	public static function osName():String
	{
		#if(cpp && mobile && !android)
		return native_device_os();
		#elseif android
		return "";
		#else
		return "";
		#end
	}
	
	public static function osVersion():String
	{
		#if(cpp && mobile && !android)
		return native_device_vervion();
		#elseif android
		return "";
		#else
		return "";
		#end
	}
	
	public static function deviceName():String
	{
		#if(cpp && mobile && !android)
		return native_device_name();
		#elseif android
		return "";
		#else
		return "";
		#end
	}
	
	public static function model():String
	{
		#if(cpp && mobile && !android)
		return native_device_model();
		#elseif android
		return "";
		#else
		return "";
		#end
	}
	
	public static function networkAvailable():Bool
	{
		#if(cpp && mobile && !android)
		return native_device_network_available();
		#elseif android
		return false;
		#else
		return false;
		#end
	}
	
	public static function vibrate(time:Float):Void
	{
		#if(cpp && mobile && !android)
		native_device_vibrate(time);
		#end
		
		#if android
		if(funcVibrate == null)
		{
			funcVibrate = JNI.createStaticMethod("Native", "vibrate", "(I)V", true);
		}
		
		funcVibrate([time * 1000]);
		#end
	}
	
	//Badge
	
	public static function setIconBadgeNumber(n:Int):Void
	{
		#if(cpp && mobile && !android)
		native_device_badge(n);
		#end
	}

	//Alert
	
	private static var alertTitle:String;
	private static var alertMSG:String;

	public static function showAlert(title:String, message:String):Void
	{
		alertTitle = title;
		alertMSG = message;
		haxe.Timer.delay(delayAlert, 30);
	}
	
	private static function delayAlert():Void
	{
		#if(cpp && mobile && !android)
		native_system_ui_show_alert(alertTitle, alertMSG);
		#end
		
		#if android
		if(funcAlert == null)
		{
			funcAlert = nme.JNI.createStaticMethod("Native", "showAlert", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		}
		
		funcAlert([alertTitle, alertMSG]);
		#end
	}
	
	//Spinner - No Android Equivalent
	
	public static function showLoadingScreen():Void
	{
		#if(cpp && mobile && !android)
		native_system_ui_show_system_loading_view();
		#end
	}	
	
	public static function hideLoadingScreen():Void
	{
		#if(cpp && mobile && !android)
		native_system_ui_hide_system_loading_view();
		#end
	}
	
	#if android
	private static var funcAlert:Dynamic;
	private static var funcVibrate:Dynamic;
	#end
	
	#if(cpp && mobile && !android)
	static var native_device_os = nme.Loader.load("native_device_os",0);
	static var native_device_vervion = nme.Loader.load("native_device_vervion",0);
	static var native_device_name = nme.Loader.load("native_device_name",0);
	static var native_device_model = nme.Loader.load("native_device_model",0);
	static var native_device_network_available = nme.Loader.load("native_device_network_available",0);
	static var native_device_vibrate = nme.Loader.load("native_device_vibrate",1);
	static var native_device_badge = nme.Loader.load("native_device_badge",1);
	
	static var native_system_ui_show_alert = nme.Loader.load("native_system_ui_show_alert",2);
	static var native_system_ui_show_system_loading_view = nme.Loader.load("native_system_ui_show_system_loading_view",0);
	static var native_system_ui_hide_system_loading_view = nme.Loader.load("native_system_ui_hide_system_loading_view",0);
	#end
}