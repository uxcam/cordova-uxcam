//
//  UXCam.h
//
//  Copyright (c) 2013-2015 UXCam Ltd. All rights reserved.
//
//  UXCam SDK VERSION: 2.0.1
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
*	UXCam SDK captures User experience data when a user uses an app, analyses this data on the cloud and provides insights to improve usability of the app or website.
*/
@interface UXCam : NSObject


/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam application, ping the server, get the settings configurations and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey The key to identify your UXCam account - find it in the UXCam dashboard for your account at http://newdashboard.uxcam.com/user/settings
 */
+ (void) startWithKey:(NSString*)userAPIKey;

/**
	Stops the UXCam application and sends captured data to the server.
	Use this to start sending the data on UXCam server without the app going into the background.
 
	@brief Stop the UXCam session and send data to the server
	@note This starts an asynchronous process and returns immediately.
*/
+ (void) stopApplicationAndUploadData;

/**
	Starts a new session after the stopApplicationAndUploadData method has been called.
	This happens automatically when the app returns from background.
*/
+ (void) restartSession;

/**
	Returns the current recording status
	@return YES if the session is being recorded
*/
+ (BOOL) isRecording;

/**
	Overrides any attempt to record the camera video that the application settings ask for.
	@note You should call this if you application makes use of either device camera and might have the camera video settings enabled.
	Otherwise the UXCam video recordings can become corrupted as UXCam and your application contest the use of the camera data.
*/
+ (void)ignoreCameraVideoRecording;

/**
	Hide a view that contains sensitive information or that you do not want recording on the screen video.

	@param sensitiveView The view to occlude in the screen recording
*/
+ (void) occludeSensitiveView:(UIView *)sensitiveView;

/**
	UXCam normally captures the view controller name automatically but in cases where it this is not sufficient (such as in OpenGL applications)
	or where you would like to set a different unique name, use this function to set the name.

	@param screenName Name to apply to the current screen in the session video
*/
+ (void) tagScreenName:(NSString*)screenName;

/**
	UXCam uses a unique number to tag a device.
	You can tag a device allowing you to search for it on the dashboard and review their sessions further.

	@param username Name to apply to this user in this recording session
	@param additionalData A dictionary of additional data to store with this session
*/
+ (void) tagUsersName:(NSString*)userName additionalData:(NSString*)additionalData;

/**
	Insert a general tag into the timeline - stores the tag with the timestamp when it was added.

	@param tag A tag to attach to the session recording at the current time
*/
+ (void) addTag:(NSString*)tag;

/**
	You can mark a user specifically if certain condition are met making them a good user for further testing.
	You can then filter these users from the dashboard and perform further tests.

	@note This flag is cleared after each upload of data, so if you wish to mark a user as a favorite across multiple sesssions you will need to call this once in each session
*/
+ (void) markUserAsFavorite;

#pragma mark - Deprecated methods - these will be removed on the next major version number update

/**
	You can set the precise location of a user.
*/
+ (void) setPreciseLocationLatitude:(double)latitude longitude:(double)longitude __attribute__((deprecated("from SDK 1.0.9")));

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam application, ping the server, get the settings configurations and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param applicationKey The key to identify this application - find it in the UXCam dashboard for your application
 */
+ (void) startApplicationWithKey:(NSString*)applicationKey __attribute__((deprecated("from SDK 2.0.0 - use startWithKey: from now")));

@end
