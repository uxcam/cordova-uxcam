package com.uxcam.cordova;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.uxcam.datamodel.UXCamBlur;
import com.uxcam.datamodel.UXCamOverlay;
import com.uxcam.datamodel.UXCamOcclusion;
import com.uxcam.datamodel.UXCamOccludeAllTextFields;
import com.uxcam.datamodel.UXConfig;
/**
 * This class echoes a string called from JavaScript.
 */
public class UXCam extends CordovaPlugin {
    private static final String UXCAM_PLUGIN_TYPE = "cordova";
    private static final String UXCAM_CORDOVA_PLUGIN_VERSION = "3.5.2";

    public static final String USER_APP_KEY = "userAppKey";
    public static final String ENABLE_MUTLI_SESSION_RECORD = "enableMultiSessionRecord";
    public static final String ENABLE_CRASH_HANDLING = "enableCrashHandling";
    public static final String ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING = "enableAutomaticScreenNameTagging";
    public static final String ENABLE_IMPROVED_SCREEN_CAPTURE = "enableImprovedScreenCapture";
    public static final String OCCLUSION = "occlusions";
    public static final String SCREENS = "screens";
    public static final String NAME = "name";
    public static final String TYPE = "type";
    public static final String EXCLUDE_MENTIONED_SCREENS = "excludeMentionedScreens";
    public static final String CONFIG = "config";
    public static final String BLUR_RADIUS = "blurRadius";
    public static final String HIDE_GESTURES = "hideGestures";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("startWithKey".equals(action)) {
            addListener(callbackContext);
            this.start(args);
        } else if("startWithConfiguration".equals(action)){
            try{
                startWithConfiguration(toMap(args.getJSONObject(0)));
            } catch(Exception e) {
                Log.d("UXCam Cordova Android:"," startWithConfiguration");
                e.printStackTrace();
            }
        } else if("applyOcclusion".equals(action)){
            try{
                UXCamOcclusion occlusion = getOcclusion(toMap(args.getJSONObject(0)));
                com.uxcam.UXCam.applyOcclusion(occlusion);
            }catch(Exception e){
                Log.d("UXCam Cordova Android:","applyOcclusion");
                e.printStackTrace();
            }
        } else if("removeOcclusion".equals(action)){
            try{
                UXCamOcclusion occlusion = getOcclusion(toMap(args.getJSONObject(0)));
            com.uxcam.UXCam.removeOcclusion(occlusion);
            }catch(Exception e){
                Log.d("UXCam Cordova Android:","removeOcclusion");
                e.printStackTrace();
            }            
        }else if ("startNewSession".equals(action)) {
            com.uxcam.UXCam.startNewSession();
        } else if ("stopSessionAndUploadData".equals(action)) {
            com.uxcam.UXCam.stopSessionAndUploadData();
        } else if ("occludeSensitiveScreen".equals(action)) {
            boolean occludeSensitiveScreen = args.getBoolean(0);
            com.uxcam.UXCam.occludeSensitiveScreen(occludeSensitiveScreen);
        } else if ("occludeAllTextFields".equals(action)) {
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
        else if ("urlForCurrentUser".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentUser();
            callbackContext.success(url);
        } else if ("urlForCurrentSession".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentSession();
            callbackContext.success(url);
        }  else if ("occludeRectsOnNextFrame".equals(action)) {
            com.uxcam.UXCam.occludeRectsOnNextFrame(new JSONArray(args.getString(0)));
        } else if ("setPushNotificationToken".equals(action)) {
            String token = args.getString(0);
            com.uxcam.UXCam.setPushNotificationToken(token);
        } else if ("reportBugEvent".equals(action)) {
            String eventName = args.getString(0);
            JSONObject params = args.getJSONObject(1);

            if (eventName == null || eventName.length() == 0) {
                throw new IllegalArgumentException("missing event Name");
            }
            if (params == null || params.length() == 0) {
                com.uxcam.UXCam.reportBugEvent(eventName);
            } else {
                com.uxcam.UXCam.reportBugEvent(eventName, params);
            }
        } else {
            callbackContext.error("This API call is not supported by UXCam Android, API called: " + action);
            return false;
        }
        return true;
    }

    private void start(final JSONArray args) throws IllegalArgumentException, JSONException {
        String key;
        String buildIdentifier;
        com.uxcam.UXCam.pluginType(UXCAM_PLUGIN_TYPE, UXCAM_CORDOVA_PLUGIN_VERSION);
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
                callback.success(com.uxcam.UXCam.urlForCurrentSession());
            }

            @Override
            public void onVerificationFailed(String errorMessage) {
                callback.error(errorMessage);
            }
        });
    }

    private List<UXCamOcclusion> convertToOcclusionList(List<Map<String, Object>> occlusionObjects) {
        List<UXCamOcclusion> occlusionList = new ArrayList<UXCamOcclusion>();
        for (Map<String, Object> occlusionMap :
                occlusionObjects) {
                    UXCamOcclusion occlusion = getOcclusion(occlusionMap);
            if (occlusion != null)
                occlusionList.add(getOcclusion(occlusionMap));
        }
        return occlusionList;
    }

    private Map<String, Object> toMap(JSONObject jsonobj)  throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        Iterator<String> keys = jsonobj.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            Object value = jsonobj.get(key);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }   
            map.put(key, value);
        }   return map;
    }

    private List<Object> toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for(int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }
            else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }   return list;
}

    private UXCamOcclusion getOcclusion(Map<String, Object> occlusionMap) {
        int typeIndex = (int) occlusionMap.get(TYPE);
        switch (typeIndex) {
            case 1:
                return (UXCamOcclusion) getOccludeAllTextFields();
            case 2:
                return (UXCamOcclusion) getOverlay(occlusionMap);
            case 3:
                return (UXCamOcclusion) getBlur(occlusionMap);
            default:
                return null;
        }
    }

    private UXCamOccludeAllTextFields getOccludeAllTextFields() {
        return new UXCamOccludeAllTextFields.Builder().build();
    }

    private UXCamOverlay getOverlay(Map<String, Object> overlayMap) {
        // get data
        List<String> screens = (List<String>) overlayMap.get(SCREENS);
        Boolean excludeMentionedScreens = (Boolean) overlayMap.get(EXCLUDE_MENTIONED_SCREENS);
        Boolean hideGestures = (Boolean) overlayMap.get(HIDE_GESTURES);

        // set data
        UXCamOverlay.Builder overlayBuilder = new UXCamOverlay.Builder();
        if (screens != null && !screens.isEmpty())
            overlayBuilder.screens(screens);
        if (excludeMentionedScreens != null)
            overlayBuilder.excludeMentionedScreens(excludeMentionedScreens);
        if (hideGestures != null)
            overlayBuilder.withoutGesture(hideGestures);
        return overlayBuilder.build();
    }

    private UXCamBlur getBlur(Map<String, Object> blurMap) {
        // get data
        List<String> screens = (List<String>) blurMap.get(SCREENS);
        Boolean excludeMentionedScreens = (Boolean) blurMap.get(EXCLUDE_MENTIONED_SCREENS);
        Double blurRadius = 0.0;
        if(blurMap.get(BLUR_RADIUS) != null)
          blurRadius = Double.valueOf(blurMap.get(BLUR_RADIUS).toString());
        
        Boolean hideGestures = (Boolean) blurMap.get(HIDE_GESTURES);

        // set data
        UXCamBlur.Builder blurBuilder = new UXCamBlur.Builder();
        if (screens != null && !screens.isEmpty())
            blurBuilder.screens(screens);
        if (excludeMentionedScreens != null)
            blurBuilder.excludeMentionedScreens(excludeMentionedScreens);
        if (blurRadius != null)
            blurBuilder.blurRadius(blurRadius.intValue());
        if (hideGestures != null)
            blurBuilder.withoutGesture(hideGestures);
        return blurBuilder.build();


    }
    private void startWithConfiguration(Map<String,Object> configuration) {
        try {
            HashMap<String, Object> configMap = (HashMap<String, Object>) configuration;
            String appKey = (String) configMap.get(USER_APP_KEY);
            Boolean enableMultiSessionRecord = (Boolean) configMap.get(ENABLE_MUTLI_SESSION_RECORD);
            Boolean enableCrashHandling = (Boolean) configMap.get(ENABLE_CRASH_HANDLING);
            Boolean enableAutomaticScreenNameTagging = (Boolean) configMap.get(ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING);
            Boolean enableImprovedScreenCapture = (Boolean) configMap.get(ENABLE_IMPROVED_SCREEN_CAPTURE);

            // // occlusion
            List<UXCamOcclusion> occlusionList = null;
            if (configMap.get(OCCLUSION) != null) {
                List<Map<String, Object>> occlusionObjects = (List<Map<String, Object>>) configMap.get(OCCLUSION);
                occlusionList = convertToOcclusionList(occlusionObjects);
            }

            UXConfig.Builder uxConfigBuilder = new UXConfig.Builder(appKey);
            if (enableMultiSessionRecord != null)
                uxConfigBuilder.enableMultiSessionRecord(enableMultiSessionRecord);
            if (enableCrashHandling != null)
                uxConfigBuilder.enableCrashHandling(enableCrashHandling);
            if (enableAutomaticScreenNameTagging != null)
                uxConfigBuilder.enableAutomaticScreenNameTagging(enableAutomaticScreenNameTagging);
            if (enableImprovedScreenCapture != null) {
                Log.d("config", "improved screen capture enabled " + enableImprovedScreenCapture);
                uxConfigBuilder.enableImprovedScreenCapture(enableImprovedScreenCapture);
            }
            if (occlusionList != null)
                uxConfigBuilder.occlusions(occlusionList);

            UXConfig config = uxConfigBuilder.build();
            com.uxcam.UXCam.pluginType(UXCAM_PLUGIN_TYPE, UXCAM_CORDOVA_PLUGIN_VERSION);
            com.uxcam.UXCam.startWithConfigurationCrossPlatform(this.cordova.getActivity(), config);
        
        } catch (Exception e) {
            Log.d("config", "Error starting with configuration");
            e.printStackTrace();
        }
    }
}
