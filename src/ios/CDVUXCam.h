#import <Cordova/CDVPlugin.h>

@interface CDVUXCam : CDVPlugin

- (void)startWithKey:(CDVInvokedUrlCommand*)command;
- (void)stopUXCamCameraVideo:(CDVInvokedUrlCommand*)command;
- (void)stopApplicationAndUploadData:(CDVInvokedUrlCommand*)command;
- (void)markUserAsFavorite:(CDVInvokedUrlCommand*)command;
- (void)tagUsersName:(CDVInvokedUrlCommand*)command;
- (void)tagScreenName:(CDVInvokedUrlCommand*)command;
- (void)addTag:(CDVInvokedUrlCommand*)command;
- (void)addTagWithProperties:(CDVInvokedUrlCommand*)command;

- (void)occludeSensitiveScreen:(CDVInvokedUrlCommand*)command;

@end