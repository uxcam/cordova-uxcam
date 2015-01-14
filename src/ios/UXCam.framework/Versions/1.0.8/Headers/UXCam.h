//
//  UXCam.h
//
//  Copyright (c) 2013-2014 UXCam Ltd. All rights reserved.
//
//  UXCam SDK VERSION: 1.0.8
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UXCam : NSObject

/* UXCam SDK captures User experience data when a user uses an app, analyses this data on the cloud and provides insights to improve usability of the app or website. */


/*	
	Call this method from applicationDidFinishLaunching.
	This will start the UXCam application, ping the server, get the settings configurations and start capturing the data according to the configuration. 
*/
+ (void) startApplicationWithKey:(NSString*)applicationKey;

/*	
	Stops the UXCam application and sends captured data to the server.
	Use this to start sending the data on UXCam server without the app going into the background. 
	NB: This starts an asynchronous process and returns immediately.
*/
+ (void) stopApplicationAndUploadData;

/*	
	Starts a new session after the stopApplicationAndUploadData method has been called.
	Happens automatically when the app returns from background. 
*/
+ (void) restartSession;

/*
	Returns the current recording status
*/
+ (BOOL) isRecording;

/* 
	Hide views that contains sensitive information or you do not want recording on the screen video.
*/
+ (void) occludeSensitiveView:(UIView *)sensitiveView;

/*	
	UXCam normally captures the view controller name automatically but in cases where it doesn’t (such as in OpenGL applications)
	or you would like to set a different unique name, use this function.
*/
+ (void) tagScreenName:(NSString*)screenName;

/*	
	UXCam uses a unique number to tag a device.
	You can tag a device allowing you to search for it on the dashboard and review their sessions further. 
*/
+ (void) tagUsersName:(NSString*)userName additionalData:(NSString*)additionalData;

/* 
	Insert a general tag into the timeline - stores the tag with the timestamp when it was added. 
*/
+ (void) addTag:(NSString*)tag;

/* 
	You can set the precise location of a user.
*/
+ (void) setPreciseLocationLatitude:(double)latitude longitude:(double)longitude;

/*	
	You can mark a user specifically if certain condition are met making them a good user for further testing.
	You can then filter these users and perform further tests.
*/
+ (void) markUserAsFavorite;

@end
