package com.androidnative;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.util.HashMap;

import org.haxe.lime.*;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import android.util.Log;
import android.app.*;
import android.content.*;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.net.Uri;
import android.os.*;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.text.*;

public class Native extends Extension
{
    
    private static HaxeObject callback;
    private static View view;
    private static String text = "";
    private static InputMethodManager imm;
    
    
	public static void vibrate(final int duration)
	{
        mainActivity.runOnUiThread(new Runnable()
                                   {
            public void run()
            {
                Vibrator v = (Vibrator) mainContext.getSystemService(mainContext.VIBRATOR_SERVICE);
                v.vibrate(duration);
            }
        });
	}
	
	public static void showAlert(final String title, final String message)
	{
		
		mainActivity.runOnUiThread
		(
			new Runnable() 
			{
				public void run() 
				{
					Dialog dialog = new AlertDialog.Builder(mainActivity).setTitle(title).setMessage(message).setPositiveButton
					(
						"OK",
						new DialogInterface.OnClickListener()
						{
							public void onClick(DialogInterface dialog, int whichButton)
							{
								//Throw event?	
							}
						}
					).create();
			
					dialog.show();
				}
			}
		);
    }

    static public void initialize(final HaxeObject cb){
        
        callback = cb;
        
        view = mainActivity.getCurrentFocus();
        
        view.setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(View view, int keyCode, KeyEvent event)
            {
                if(event.getAction()==KeyEvent.ACTION_DOWN)
                {
                    return true;
                }
                
                if(keyCode==KeyEvent.KEYCODE_ALT_LEFT || keyCode==KeyEvent.KEYCODE_ALT_RIGHT || keyCode==KeyEvent.KEYCODE_SHIFT_LEFT || keyCode==KeyEvent.KEYCODE_SHIFT_RIGHT)
                {
                   return true;
                }
                
                if (keyCode == KeyEvent.KEYCODE_DEL)
                {
                    int len = text.length();
                    
                    if (len > 0)
                    {
                        text = text.substring(0, len - 1);
                    }
                    
                    callback.call("onKeyPressed", new Object[] {text});
                    
                    
                    return true;
                } else if (keyCode == KeyEvent.KEYCODE_ENTER) {
                    hideKeyboard();
                    
                    callback.call("onEnterPressed", new Object[] {});
                    
                    return true;
                }
                
                
                if (event.getAction()==KeyEvent.ACTION_UP)
                {
                    text += String.valueOf((char)event.getUnicodeChar());
                    
                    //Toast.makeText(mainActivity,text + "Action UP",Toast.LENGTH_LONG).show();
                    
                    callback.call("onKeyPressed", new Object[] {text});
                    
                    return true;
                }
                else if (event.getAction()==KeyEvent.ACTION_MULTIPLE)
                {
                    
                    text += String.valueOf(event.getCharacters());
                    
                    //Toast.makeText(mainActivity,text + "Action Multi",Toast.LENGTH_LONG).show();
                    
                    callback.call("onKeyPressed", new Object[] {text});
                    
                    return true;
                }
            return false;
                
            }

    });
        
        mainActivity.runOnUiThread(new Runnable()
                                   {
            public void run()
            {

                imm = (InputMethodManager) mainContext.getSystemService(mainContext.INPUT_METHOD_SERVICE);
                
            }
        });
      
        
		/*EditText textField = (EditText) activity.findViewById(R.id.editTextConvertValue);
	
		textField.addTextChangedListener
		(
			new TextWatcher()
			{
				public void afterTextChanged(Editable s) 
				{
					System.out.println("TESTING: " + s);
				}
			}
		);*/
		
	}
    
    public static void showKeyboard() 
    {
		mainActivity.runOnUiThread(new Runnable()
        {
			public void run()
			{
				imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);
			}
        });
		
        //activity.showKeyboard(true);
    }
    
    public static void hideKeyboard() 
    {
    	
    	mainActivity.runOnUiThread(new Runnable()
        {
    		public void run()
    		{
    			imm.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_IMPLICIT_ONLY);
    		}
        });
    	
        //activity.showKeyboard(false);
    }
    
    static public void setText(final String newText)
    {
        text = newText;
    }
}