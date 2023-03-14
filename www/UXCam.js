  /**
   * UXCam.js
   *
   * Cordova UXCam plugin for version >= 3.0.0
   *
   * Copyright(c) 2015-2019 UXCam Inc.
   */
   
  var exec = require('cordova/exec');
  
  var UXCam = function(){};
  
  UXCam.startWithConfiguration = function(configuration, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'startWithConfiguration', [configuration]);
  };

  UXCam.startWithKey = function(key, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'startWithKey', [key]);
  };

  UXCam.applyOcclusion = function(occlusion, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'applyOcclusion', [occlusion]);
  };

  UXCam.removeOcclusion = function(occlusion, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'removeOcclusion', [occlusion]);
  };
  
  UXCam.startWithKeyAndAppVariant = function(key, appVariant, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'startWithKey', [key, appVariant]);
  };
  
  UXCam.startNewSession = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'startNewSession', []);
  };
  
  UXCam.stopSessionAndUploadData = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'stopSessionAndUploadData', []);
  };
  
  UXCam.tagScreenName = function(screenName, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'tagScreenName', [screenName]);
  };
  
  UXCam.setAutomaticScreenNameTagging = function(automaticScreenNameTagging, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setAutomaticScreenNameTagging', [automaticScreenNameTagging]);
  };
  
  UXCam.setUserIdentity = function(name, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setUserIdentity', [name]);
  };
  
  UXCam.setUserProperty = function(key, value, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setUserProperty', [key, value]);
  };
  
  UXCam.setSessionProperty = function(key, value, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setSessionProperty', [key, value]);
  };
  
  UXCam.isRecording =  async function(successCallback, errorCallback)
  {
      return exec(successCallback, errorCallback, 'UXCam', 'isRecording', []);
  };

  UXCam.pendingUploads = async function(successCallback, errorCallback){
       return exec(successCallback,errorCallback,'UXCam', 'pendingUploads');
  };
  
  UXCam.pauseScreenRecording = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'pauseScreenRecording', []);
  };
  
  UXCam.resumeScreenRecording = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'resumeScreenRecording', []);
  };
  
  UXCam.optOutOverall = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optOutOverall', []);
  };
  
  UXCam.optOutOfSchematicRecordings = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optOutOfSchematicRecordings', []);
  };
  
  UXCam.optInOverall = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInOverall', []);
  };
  
  UXCam.optIntoSchematicRecordings = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optIntoSchematicRecordings', []);
  };
  
  UXCam.optInOverallStatus = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInOverallStatus', []);
  };
  
  UXCam.optInSchematicRecordingStatus = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInSchematicRecordingStatus', []);
  };
  
  //deprecated; use optInOverall
  UXCam.optIn = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optIn', []);
  };
  //deprecated; use optOutOverall
  UXCam.optOut = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optOut', []);
  };
  //deprecated; use optInOverallStatus
  UXCam.optStatus = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optStatus', []);
  };
  //deprecated; use optInOverallStatus
  UXCam.optInStatus = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInStatus', []);
  };
  
  UXCam.optIntoVideoRecording = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInStatus', []);
  };
  
  UXCam.optOutOfVideoRecording = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInStatus', []);
  };
  
  UXCam.optInVideoRecordingStatus = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'optInStatus', []);
  };
  
  UXCam.cancelCurrentSession = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'cancelCurrentSession', []);
  };
  
  UXCam.allowShortBreakForAnotherApp = function(isEnabled, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'allowShortBreakForAnotherApp', [isEnabled]);
  };
  
  UXCam.resumeShortBreakForAnotherApp = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'resumeShortBreakForAnotherApp', []);
  };
  
  UXCam.getMultiSessionRecord = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'getMultiSessionRecord', []);
  };
  
  UXCam.setMultiSessionRecord = function(mulitSession, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setMultiSessionRecord', [mulitSession]);
  };
  
  UXCam.deletePendingUploads = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'deletePendingUploads', []);
  };
  
  UXCam.pendingSessionCount = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'pendingSessionCount', []);
  };
  
  UXCam.uploadPendingSession = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'uploadPendingSession', []);
  };
  
  UXCam.stopApplicationAndUploadData = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'stopApplicationAndUploadData', []);
  };
  
  UXCam.setAutomaticScreenNameTagging = function(enableAutomaticNameTagging, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setAutomaticScreenNameTagging', [enableAutomaticNameTagging]);
  };
  
  UXCam.tagScreenName = function(screenName, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'tagScreenName', [screenName]);
  };
  
  UXCam.logEvent = function(eventName, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'logEvent', [eventName]);
  };
  
  UXCam.logEventWithProperties = function(eventName, properties, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'logEventWithProperties', [eventName, properties]);
  };
  
  UXCam.occludeSensitiveScreen = function(occludeSensitiveScreen, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'occludeSensitiveScreen', [occludeSensitiveScreen]);
  };
  

  UXCam.occludeSensitiveScreenWithoutGesture = function(occludeSensitiveScreenWithoutGesture, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'occludeSensitiveScreenWithoutGesture', [occludeSensitiveScreenWithoutGesture]);
  };
  

  // For historical reasons this can be called as occludeAllTextFields or occludeAllTextView
  UXCam.occludeAllTextFields = function(occludeAll, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'occludeAllTextFields', [occludeAll]);
  };

  UXCam.occludeAllTextView = function(occludeAll, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'occludeAllTextFields', [occludeAll]);
  };
  
  
  UXCam.urlForCurrentUser = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'urlForCurrentUser', []);
  };
  
  UXCam.urlForCurrentSession = function(successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'urlForCurrentSession', []);
  };
  
  UXCam.occludeRectsOnNextFrame = function(rects, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'occludeRectsOnNextFrame', [rects]);
  };
  
  UXCam.setPushNotificationToken = function(token, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'setPushNotificationToken', [token]);
  };
  
  UXCam.reportBugEvent = function(eventName, properties, successCallback, errorCallback)
  {
    return exec(successCallback, errorCallback, 'UXCam', 'reportBugEvent', [eventName, properties]);
  };
  
  module.exports = UXCam;
  