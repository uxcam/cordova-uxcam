package com.uxcam.cordova;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class UXCam extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("startWithKey".equals(action)) {
            this.start(args);
        } else if ("startNewSession".equals(action)) {
            com.uxcam.UXCam.startNewSession();
        } else if ("stopSessionAndUploadData".equals(action)) {
            com.uxcam.UXCam.stopSessionAndUploadData();
        } else if ("occludeSensitiveScreen".equals(action)) {
            boolean occludeSensitiveScreen = args.getBoolean(0);
            com.uxcam.UXCam.occludeSensitiveScreen(occludeSensitiveScreen);
        } else if ("occludeAllTextView".equals(action)) {
            boolean occludeAllTextField = args.getBoolean(0);
            com.uxcam.UXCam.occludeAllTextFields(occludeAllTextField);
        } else if ("tagScreenName".equals(action)) {
            String eventName = args.getString(0);
            com.uxcam.UXCam.tagScreenName(eventName);
        } else if ("setAutomaticScreenNameTagging".equals(action)) {
            Log.d("UXCamPlugin", "action " + action + " is not supported by UXCam Android");
        } else if ("setUserIdentity".equals(action)) {
            String userIdentity = args.getString(0);
            com.uxcam.UXCam.setUserIdentity(userIdentity);
        } else if ("setUserProperty".equals(action)) {
            String key = args.getString(0);
            String value = args.getString(1);
            com.uxcam.UXCam.setUserProperty(key, value);
        } else if ("setSessionProperty".equals(action)) {
            String key = args.getString(0);
            String value = args.getString(1);
            com.uxcam.UXCam.setSessionProperty(key, value);
        } else if ("logEvent".equals(action)) {
            String eventName = args.getString(0);
            if (eventName == null || eventName.length() == 0) {
                throw new IllegalArgumentException("missing event Name");
            }
            com.uxcam.UXCam.logEvent(eventName);
        } else if ("logEventWithProperties".equals(action)) {
            String eventName = args.getString(0);
            JSONObject params = args.getJSONObject(1);

            if (eventName == null || eventName.length() == 0) {
                throw new IllegalArgumentException("missing event Name");
            }
            if (params == null || params.length() == 0) {
                com.uxcam.UXCam.logEvent(eventName);
            } else {
                com.uxcam.UXCam.logEvent(eventName, params);
            }
        } else if ("isRecording".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.isRecording()));
            return true;
        } else if ("pauseScreenRecording".equals(action)) {
            com.uxcam.UXCam.pauseScreenRecording();
        } else if ("resumeScreenRecording".equals(action)) {
            com.uxcam.UXCam.resumeScreenRecording();
        } else if ("optIn".equals(action)) {
            com.uxcam.UXCam.optIn();
        } else if ("optOut".equals(action)) {
            com.uxcam.UXCam.optOut();
        }else if ("optInOverall".equals(action)) {
            com.uxcam.UXCam.optIn();
        } else if ("optOutOverall".equals(action)) {
            com.uxcam.UXCam.optOut();
        } else if ("optStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInStatus()));
        } else if ("optInStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInStatus()));
        } else if ("optInOverallStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInStatus()));
        }else if ("optIntoVideoRecording".equals(action)) {
            com.uxcam.UXCam.optIntoVideoRecording();
        } else if ("optOutOfVideoRecording".equals(action)) {
            com.uxcam.UXCam.optOutOfVideoRecording();
        } else if ("optInVideoRecordingStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInVideoRecordingStatus()));
        } else if ("cancelCurrentSession".equals(action)) {
            com.uxcam.UXCam.cancelCurrentSession();
        } else if ("allowShortBreakForAnotherApp".equals(action)) {
            com.uxcam.UXCam.allowShortBreakForAnotherApp();
        } else if ("resumeShortBreakForAnotherApp".equals(action)) {
            com.uxcam.UXCam.resumeShortBreakForAnotherApp();
        } else if ("deletePendingUploads".equals(action)) {
            com.uxcam.UXCam.deletePendingUploads();
        } else if ("pendingSessionCount".equals(action)) {
            com.uxcam.UXCam.pendingSessionCount();
        } else if ("stopApplicationAndUploadData".equals(action)) {
            com.uxcam.UXCam.stopSessionAndUploadData();
        } else if ("tagScreenName".equals(action)) {
            String screenName = args.getString(0);
            if (screenName == null || screenName.length() == 0) {
                throw new IllegalArgumentException("missing screen Name");
            }
            com.uxcam.UXCam.tagScreenName(screenName);
        }
        else if ("addVerificationListener".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentUser();
            if (url == null || url.contains("null")) {
                addListener(callbackContext);
                return true;
            }
            callbackContext.success(url);
        } else if ("urlForCurrentUser".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentUser();
            callbackContext.success(url);
        } else if ("urlForCurrentSession".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentSession();
            callbackContext.success(url);
        }  else if ("occludeRectsOnNextFrame".equals(action)) {
            com.uxcam.UXCam.occludeRectsOnNextFrame(new JSONArray(args.getString(0)));
        } else {
            callbackContext.error("This API call is not supported by UXCam Android, API called: " + action);
            return false;
        }
        return true;
    }

    private void start(final JSONArray args) throws IllegalArgumentException, JSONException {
        String key;
        String buildIdentifier;
        com.uxcam.UXCam.pluginType("cordova", "3.2.1");
        if (args.length() == 1) {
            key = args.getString(0);
            if (key == null || key.length() == 0) {
                throw new IllegalArgumentException("missing api key");
            }
            com.uxcam.UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key);

        } else if (args.length() == 2) {
            key = args.getString(0);
            buildIdentifier = args.getString(1);
            if (key == null || key.length() == 0 || buildIdentifier == null || buildIdentifier.length() == 0) {
                throw new IllegalArgumentException("missing api key or buildIdentifier");
            }
            com.uxcam.UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key, buildIdentifier);

        } else {
            throw new IllegalArgumentException("unsupported number of arguments");
        }
    }

    private void addListener(final CallbackContext callback) {
        com.uxcam.UXCam.addVerificationListener(new com.uxcam.OnVerificationListener() {
            @Override
            public void onVerificationSuccess() {
                callback.success(com.uxcam.UXCam.urlForCurrentUser());
            }

            @Override
            public void onVerificationFailed(String errorMessage) {
                callback.error(errorMessage);
            }
        });
    }
}

