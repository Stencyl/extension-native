#include <Native.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <netinet/in.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SCNetworkReachability.h>

namespace native 
{
    UIActivityIndicatorView* activityIndicator;
    UIView* loadingView;
    
	const char* os()
    {
		return  [[[UIDevice currentDevice] systemName] UTF8String];
	}
    
	const char* vervion()
    {
		return  [[[UIDevice currentDevice] systemVersion] UTF8String];
	}
    
	const char* deviceName()
    {
		return  [[[UIDevice currentDevice] localizedModel] UTF8String];
	}
    
	const char* model()
    {
		return  [[[UIDevice currentDevice] model] UTF8String];
	}
	
    bool networkAvailable()
    {
        // Create zero addy
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        // Recover reachability flags
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
        SCNetworkReachabilityFlags flags;
        
        BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
        CFRelease(defaultRouteReachability);
        
        if (!didRetrieveFlags)
        {
            NSLog(@"Error. Could not recover network reachability flags");
            return false;
        }
        
        BOOL isReachable = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        return (isReachable && !needsConnection) ? true : false;
    }	
    
	void vibrate(float milliseconds)
    {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
	
	void setBadgeNumber(int number)
	{
		[UIApplication sharedApplication].applicationIconBadgeNumber = number;
	}
    
    void showSystemAlert(const char *title,const char *message)
    {	
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle: [[NSString alloc] initWithUTF8String:title] message: [[NSString alloc] initWithUTF8String:message] 
                                                      delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] ;//autorelease];
        [alert show];
        //[alert release];
    }
    
    void showLoadingScreen()
    {
        activityIndicator= [[UIActivityIndicatorView alloc]  initWithFrame:CGRectMake(128.0f, 208.0f, 64.0f,64.0f)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.5;
        [loadingView addSubview:activityIndicator];
        [[[UIApplication sharedApplication] keyWindow] addSubview:loadingView];
        [activityIndicator startAnimating];
    }
    
    void hideLoadingScreen()
    {
        if(activityIndicator != NULL)
        {
            [activityIndicator stopAnimating];
            [activityIndicator release];
            activityIndicator = NULL;
            
            [loadingView removeFromSuperview];
            [loadingView release];
            loadingView = NULL;
        }
    }
    
    //TODO: WebView
    
    //TODO: Keyboard
}