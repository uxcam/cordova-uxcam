#import "CDVUXCam.h"

#import <UXCam/UXCam.h>

@implementation CDVUXCam

- (void)startWithKey:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* apiKey = command.arguments[0];
	
	if (apiKey.length > 0)
	{
		NSString* appVariantIdentifier = nil;
		if (command.arguments.count>1)
		{
			appVariantIdentifier = command.arguments[1];
			appVariantIdentifier = appVariantIdentifier.length>0 ? appVariantIdentifier : nil;
		}
		
		NSLog(@"UXCam: Starting UXCam with API Key: %@ App Variant id: %@", apiKey, appVariantIdentifier ?: @"nil");

		[UXCam startWithKey:apiKey appVariantIdentifier:appVariantIdentifier];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopUXCamCameraVideo:(CDVInvokedUrlCommand*)command
{
	[UXCam ignoreCameraVideoRecording];
	
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)stopApplicationAndUploadData:(CDVInvokedUrlCommand*)command
{
	[UXCam stopApplicationAndUploadData];
	
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)markUserAsFavorite:(CDVInvokedUrlCommand*)command
{
	[UXCam markUserAsFavorite];
	
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)tagUsersName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* userName = command.arguments[0];
	if (userName.length>0)
	{
		[UXCam tagUsersName:userName additionalData:nil];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)tagScreenName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* screenName = command.arguments[0];
	if (screenName.length>0)
	{
		[UXCam tagScreenName:screenName];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addTag:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* tag = command.arguments[0];
	if (tag.length>0)
	{
		[UXCam addTag:tag];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addTagWithProperties:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* tag = command.arguments[0];
	NSDictionary* properties = command.arguments[1];
	
	if (tag.length>0 && [properties isKindOfClass:NSDictionary.class])
	{
		[UXCam addTag:tag withProperties:properties];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)occludeSensitiveScreen:(CDVInvokedUrlCommand*)command
{
	BOOL hideScreen = [command.arguments[0] boolValue];
	
	[UXCam occludeSensitiveScreen:hideScreen];
	
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

@end