package;

#if android
import lime.system.JNI;
#end

import com.stencyl.Engine;
import com.stencyl.event.EventMaster;
import com.stencyl.event.StencylEvent;

import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.events.KeyboardEvent;
import openfl.events.EventDispatcher;
import com.stencyl.Input;

import lime.system.CFFI;

class Native
{	

	private function new() {}
	
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
			funcVibrate = JNI.createStaticMethod("com/androidnative/Native", "vibrate", "(I)V", true);
		}
		
		funcVibrate([time * 1000]);
		#end
	}
	
	//Keyboard
	public static function showKeyboard():Void
	{
		#if(cpp && mobile && !android)
		initKeyboard();
		native_device_show_keyboard();
		Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_SHOW, ""));
		#end
		
		#if android
		initKeyboard();
		
		if(funcShowKeyboard == null)
		{
			funcShowKeyboard = JNI.createStaticMethod("com/androidnative/Native", "showKeyboard", "()V", true);
		}
		
		funcShowKeyboard([]);
		Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_SHOW, ""));
		#end
	}
	
	public static function hideKeyboard():Void
	{
		#if(cpp && mobile && !android)
		initKeyboard();
		native_device_hide_keyboard();
		Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_HIDE, ""));
		#end
		
		#if android
        initKeyboard();
 
		if(funcHideKeyboard == null)
		{
			funcHideKeyboard = JNI.createStaticMethod("com/androidnative/Native", "hideKeyboard", "()V", true);
		}
		
		funcHideKeyboard([]);
		Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_HIDE, ""));
		#end
	}
	
	public static function setKeyboardText(text:String):Void
	{
		#if(cpp && mobile && !android)
		native_setKeyboardText(text);
		#end
		
		#if android
		if(funcSetKeyboardText == null)
		{
			funcSetKeyboardText = JNI.createStaticMethod("com/androidnative/Native", "setText", "(Ljava/lang/String;)V", true);
		}
		
		funcSetKeyboardText([text]);
		#end
	}
	
	public static function initKeyboard():Void 
	{
		#if(cpp && mobile && !android)
		if(!keyboardInitialized)
		{
			keyboard_set_event_handle(notifyListeners);
			keyboardInitialized = true;
		}
		#end
		
		#if android
		if(!keyboardInitialized)
		{
			if(funcKeyboardInitialized == null)
			{
				funcKeyboardInitialized = JNI.createStaticMethod("com/androidnative/Native", "initialize", "(Lorg/haxe/lime/HaxeObject;)V", true);
			}
			var args = new Array<Dynamic>();
            args.push(new Native());
            funcKeyboardInitialized(args);
			
			keyboardInitialized = true;
		}
		#end
	}
	
	private static function notifyListeners(inEvent:Dynamic)
	{
		#if(cpp && mobile && !android)
		
		//Fire Key Event
		//var data:Int = Std.int(Reflect.field(inEvent, "data"));
		//Input.onKeyDown(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, data, data));
		//Input.onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, data, data));
		
		//Fire a special event
		var data = Reflect.field(inEvent, "data");
		trace("Text: " + data);
		
		if(data == "@SUBMIT@")
		{
			data = Reflect.field(inEvent, "data2");
			Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_DONE, data));
		}
		
		else
		{
			Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_EVENT, data));
		}
		#end	
	}
	
	//Android callbacks
	public function onKeyPressed(typedText:String = "") {
        #if android
		
        currentText = typedText;
		
		trace(currentText);
		
        Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_EVENT, currentText));
        #end
    }

    public function onEnterPressed() {
        #if android
        Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_DONE, currentText));
        #end
    }

    public function onKeyboardShown() {
        #if android
        Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_SHOW, currentText));
        #end
    }

    public function onKeyboardHidden() {
        #if android
        Engine.events.addKeyboardEvent(new StencylEvent(StencylEvent.KEYBOARD_HIDE, currentText));
        #end
    }
	
	public function onPause()
	{
		keyboardInitialized = false;
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
			funcAlert = JNI.createStaticMethod("com/androidnative/Native", "showAlert", "(Ljava/lang/String;Ljava/lang/String;)V", true);
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
	
	//Preferences
	
	public static function getUserPreference(name:String):String
	{
		#if ios
		return native_get_user_preference(name);
		#end
		
		#if android
		if(funcGetPreference == null)
		{
			funcGetPreference = JNI.createStaticMethod("com/androidnative/Native", "getUserPreference", "(Ljava/lang/String;)Ljava/lang/String;", true);
		}
		
		return funcGetPreference([name]);
		#end
	}
	
	public static function setUserPreference(name:String, value:String):Bool
	{
		#if ios
		native_set_user_preference(name, value);
		#end
		
		#if android
		if(funcSetPreference == null)
		{
			funcSetPreference = JNI.createStaticMethod("com/androidnative/Native", "setUserPreference", "(Ljava/lang/String;)V", true);
		}
		
		funcSetPreference([name, value]);
		#end
		
		return true;
	}
	
	public static function clearUserPreference(name:String):Bool
	{
		#if ios
		native_clear_user_preference(name);
		#end
		
		#if android
		if(funcClearPreference == null)
		{
			funcClearPreference = JNI.createStaticMethod("com/androidnative/Native", "clearUserPreference", "(Ljava/lang/String;)V", true);
		}
		
		funcClearPreference([name]);
		#end
		
		return true;
	}
	
	#if android
	private static var funcAlert:Dynamic;
	private static var funcVibrate:Dynamic;
	private static var funcShowKeyboard:Dynamic;
	private static var funcHideKeyboard:Dynamic;
	private static var funcGetPreference:Dynamic;
	private static var funcSetPreference:Dynamic;
	private static var funcClearPreference:Dynamic;
	//edit byRobin
	private static var funcKeyboardInitialized:Dynamic;
	private static var funcSetKeyboardText:Dynamic;
	private static var currentText:String = "";
	#end
	
	private static var keyboardInitialized:Bool = false;
	
	#if(cpp && mobile && !android)
	static var keyboard_set_event_handle = CFFI.load("native","keyboard_set_event_handle",1);
	
	static var native_device_os = CFFI.load("native","native_device_os",0);
	static var native_device_vervion = CFFI.load("native","native_device_vervion",0);
	static var native_device_name = CFFI.load("native","native_device_name",0);
	static var native_device_model = CFFI.load("native","native_device_model",0);
	static var native_device_network_available = CFFI.load("native","native_device_network_available",0);
	static var native_device_vibrate = CFFI.load("native","native_device_vibrate",1);
	static var native_device_badge = CFFI.load("native","native_device_badge",1);
	
	static var native_device_show_keyboard = CFFI.load("native","native_device_show_keyboard",0);
	static var native_device_hide_keyboard = CFFI.load("native","native_device_hide_keyboard",0);
	static var native_setKeyboardText = CFFI.load("native","native_setKeyboardText",1);
	
	static var native_system_ui_show_alert = CFFI.load("native","native_system_ui_show_alert",2);
	static var native_system_ui_show_system_loading_view = CFFI.load("native","native_system_ui_show_system_loading_view",0);
	static var native_system_ui_hide_system_loading_view = CFFI.load("native","native_system_ui_hide_system_loading_view",0);

	static var native_get_user_preference = CFFI.load("native","native_get_user_preference",1);
	static var native_set_user_preference = CFFI.load("native","native_set_user_preference",2);
	static var native_clear_user_preference = CFFI.load("native","native_clear_user_preference",1);
	#end
}