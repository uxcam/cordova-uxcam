#import <Cordova/CDVPlugin.h>

@interface CDVUXCam : CDVPlugin

- (void)startWithConfiguration:(CDVInvokedUrlCommand*)command;

- (void)startWithKey:(CDVInvokedUrlCommand*)command;

- (void)applyOcclusion:(CDVInvokedUrlCommand*)command;

- (void)removeOcclusion:(CDVInvokedUrlCommand*)command;

- (void)stopSessionAndUploadData:(CDVInvokedUrlCommand*)command;

- (void)allowShortBreakForAnotherApp:(CDVInvokedUrlCommand*)command;

- (void)startNewSession:(CDVInvokedUrlCommand*)command;

- (void)cancelCurrentSession:(CDVInvokedUrlCommand*)command;

- (void)isRecording:(CDVInvokedUrlCommand*)command;

- (void)pauseScreenRecording:(CDVInvokedUrlCommand*)command;

- (void)resumeScreenRecording:(CDVInvokedUrlCommand*)command;

- (void)pendingUploads:(CDVInvokedUrlCommand*)command;

- (void)deletePendingUploads:(CDVInvokedUrlCommand*)command;

- (void)pendingSessionCount:(CDVInvokedUrlCommand*)command;

- (void)uploadPendingSession:(CDVInvokedUrlCommand*)command;

- (void)occludeAllTextFields:(CDVInvokedUrlCommand*)command;

- (void)tagScreenName:(CDVInvokedUrlCommand*)command;

- (void)setUserIdentity:(CDVInvokedUrlCommand*)command;

- (void)setUserProperty:(CDVInvokedUrlCommand*)command;

- (void)logEvent:(CDVInvokedUrlCommand*)command;

- (void)logEventWithProperties:(CDVInvokedUrlCommand*)command;

- (void)urlForCurrentUser:(CDVInvokedUrlCommand*)command;

- (void)urlForCurrentSession:(CDVInvokedUrlCommand*)command;

- (void)optOutOverall:(CDVInvokedUrlCommand*)command;

- (void)optOutOfSchematicRecordings:(CDVInvokedUrlCommand*)command;

- (void)optInOverall:(CDVInvokedUrlCommand*)command;

- (void)optIntoSchematicRecordings:(CDVInvokedUrlCommand*)command;

- (void)optInOverallStatus:(CDVInvokedUrlCommand*)command;

- (void)optInSchematicRecordingStatus:(CDVInvokedUrlCommand*)command;

@end
