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

import com.uxcam.screenshot.model.UXCamBlur;
import com.uxcam.screenshot.model.UXCamOverlay;
import com.uxcam.screenshot.model.UXCamOcclusion;
import com.uxcam.screenshot.model.UXCamOccludeAllTextFields;
import com.uxcam.screenshot.model.UXCamAITextOcclusion;
import com.uxcam.datamodel.UXConfig;
/**
 * This class echoes a string called from JavaScript.
 */
public class UXCam extends CordovaPlugin {
    private static final String UXCAM_PLUGIN_TYPE = "cordova";
    private static final String UXCAM_CORDOVA_PLUGIN_VERSION = "3.7.1";

    public static final String USER_APP_KEY = "userAppKey";
    public static final String ENABLE_MUTLI_SESSION_RECORD = "enableMultiSessionRecord";
    public static final String ENABLE_CRASH_HANDLING = "enableCrashHandling";
    public static final String ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING = "enableAutomaticScreenNameTagging";
    public static final String ENABLE_IMPROVED_SCREEN_CAPTURE = "enableImprovedScreenCapture";
    public static final String ENABLE_INTEGRATION_LOGGING = "enableIntegrationLogging";
    public static final String OCCLUSION = "occlusions";
    public static final String SCREENS = "screens";
    public static final String NAME = "name";
    public static final String TYPE = "type";
    public static final String EXCLUDE_MENTIONED_SCREENS = "excludeMentionedScreens";
    public static final String CONFIG = "config";
    public static final String BLUR_RADIUS = "blurRadius";
    public static final String HIDE_GESTURES = "hideGestures";
    public static final String RECOGNITION_LANGUAGES = "recognitionLanguages";
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("startWithConfiguration".equals(action)) {
            try {
                addListener(callbackContext);
                startWithConfiguration(toMap(args.getJSONObject(0)));
            } catch(Exception e) {
                Log.d("UXCam Cordova Android:"," startWithConfiguration");
                e.printStackTrace();
            }
        } else if("applyOcclusion".equals(action)){
            try{
                UXCamOcclusion occlusion = getOcclusion(toMap(args.getJSONObject(0)));
                if (occlusion != null) {
                    com.uxcam.UXCam.applyOcclusion(occlusion);
                }
                callbackContext.success();
            }catch(Exception e){
                Log.d("UXCam Cordova Android:","applyOcclusion");
                e.printStackTrace();
                callbackContext.error(e.getMessage());
            }
        } else if("removeOcclusion".equals(action)){
            try{
                UXCamOcclusion occlusion = getOcclusion(toMap(args.getJSONObject(0)));
                if (occlusion != null) {
                    com.uxcam.UXCam.removeOcclusion(occlusion);
                }
                callbackContext.success();
            }catch(Exception e){
                Log.d("UXCam Cordova Android:","removeOcclusion");
                e.printStackTrace();
                callbackContext.error(e.getMessage());
            }
        } else if ("startNewSession".equals(action)) {
            com.uxcam.UXCam.startNewSession();
            callbackContext.success();
        } else if ("stopSessionAndUploadData".equals(action)) {
            com.uxcam.UXCam.stopSessionAndUploadData();
            callbackContext.success();
        } else if ("occludeAllTextFields".equals(action)) {
            boolean occludeAllTextField = args.getBoolean(0);
            com.uxcam.UXCam.occludeAllTextFields(occludeAllTextField);
            callbackContext.success();
        } else if ("tagScreenName".equals(action)) {
            String eventName = args.getString(0);
            com.uxcam.UXCam.tagScreenName(eventName);
            callbackContext.success();
        } else if ("setUserIdentity".equals(action)) {
            String userIdentity = args.getString(0);
            com.uxcam.UXCam.setUserIdentity(userIdentity);
            callbackContext.success();
        } else if ("setUserProperty".equals(action)) {
            String key = args.getString(0);
            String value = args.getString(1);
            com.uxcam.UXCam.setUserProperty(key, value);
            callbackContext.success();
        } else if ("logEvent".equals(action)) {
            String eventName = args.getString(0);
            if (eventName == null || eventName.length() == 0) {
                callbackContext.error("missing event Name");
                return false;
            }
            com.uxcam.UXCam.logEvent(eventName);
            callbackContext.success();
        } else if ("logEventWithProperties".equals(action)) {
            String eventName = args.getString(0);
            JSONObject params = args.getJSONObject(1);

            if (eventName == null || eventName.length() == 0) {
                callbackContext.error("missing event Name");
                return false;
            }
            if (params == null || params.length() == 0) {
                com.uxcam.UXCam.logEvent(eventName);
            } else {
                com.uxcam.UXCam.logEvent(eventName, params);
            }
            callbackContext.success();
        } else if ("isRecording".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.isRecording()));
        } else if ("pauseScreenRecording".equals(action)) {
            com.uxcam.UXCam.pauseScreenRecording();
            callbackContext.success();
        } else if ("resumeScreenRecording".equals(action)) {
            com.uxcam.UXCam.resumeScreenRecording();
            callbackContext.success();
        } else if ("optInOverall".equals(action)) {
            com.uxcam.UXCam.optIn();
            callbackContext.success();
        } else if ("optOutOverall".equals(action)) {
            com.uxcam.UXCam.optOut();
            callbackContext.success();
        } else if ("optInOverallStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInStatus()));
        } else if ("optOutOfSchematicRecordings".equals(action)) {
            com.uxcam.UXCam.optOutOfVideoRecording();
            callbackContext.success();
        } else if ("optIntoSchematicRecordings".equals(action)) {
            com.uxcam.UXCam.optIntoVideoRecording();
            callbackContext.success();
        } else if ("optInSchematicRecordingStatus".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.optInVideoRecordingStatus()));
        } else if ("cancelCurrentSession".equals(action)) {
            com.uxcam.UXCam.cancelCurrentSession();
            callbackContext.success();
        } else if ("allowShortBreakForAnotherApp".equals(action)) {
            boolean continueSession = args.getBoolean(0);
            if (continueSession) {
                com.uxcam.UXCam.allowShortBreakForAnotherApp();
            } else {
                com.uxcam.UXCam.resumeShortBreakForAnotherApp();
            }
            callbackContext.success();
        } else if ("deletePendingUploads".equals(action)) {
            com.uxcam.UXCam.deletePendingUploads();
            callbackContext.success();
        } else if ("pendingUploads".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.pendingUploads()));
        } else if ("pendingSessionCount".equals(action)) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, com.uxcam.UXCam.pendingSessionCount()));
        } else if ("uploadPendingSession".equals(action)) {
            // Android SDK handles uploads automatically
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
        } else if ("urlForCurrentUser".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentUser();
            callbackContext.success(url);
        } else if ("urlForCurrentSession".equals(action)) {
            String url = com.uxcam.UXCam.urlForCurrentSession();
            callbackContext.success(url);
        } else {
            callbackContext.error("This API call is not supported by UXCam Android, API called: " + action);
            return false;
        }
        return true;
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
        for (Map<String, Object> occlusionMap : occlusionObjects) {
            UXCamOcclusion occlusion = getOcclusion(occlusionMap);
            if (occlusion != null) {
                occlusionList.add(occlusion);
            }
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
            case 4:
                return (UXCamOcclusion) getAITextOcclusion(occlusionMap);   
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

    private UXCamAITextOcclusion getAITextOcclusion(Map<String, Object> aiMap) {
        Boolean hideGestures = (Boolean) aiMap.get(HIDE_GESTURES);
        UXCamAITextOcclusion.Builder builder = new UXCamAITextOcclusion.Builder();
        if (hideGestures != null) {
            builder.withoutGesture(hideGestures);
        }
        return builder.build();
    }

    private void startWithConfiguration(Map<String,Object> configuration) {
        try {
            HashMap<String, Object> configMap = (HashMap<String, Object>) configuration;
            String appKey = (String) configMap.get(USER_APP_KEY);
            Boolean enableMultiSessionRecord = (Boolean) configMap.get(ENABLE_MUTLI_SESSION_RECORD);
            Boolean enableCrashHandling = (Boolean) configMap.get(ENABLE_CRASH_HANDLING);
            Boolean enableAutomaticScreenNameTagging = (Boolean) configMap.get(ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING);
            Boolean enableImprovedScreenCapture = (Boolean) configMap.get(ENABLE_IMPROVED_SCREEN_CAPTURE);
            Boolean enableIntegrationLogging = (Boolean) configMap.get(ENABLE_INTEGRATION_LOGGING);

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
            if (enableIntegrationLogging != null) {
                Log.d("config", "integration logging enabled " + enableIntegrationLogging);
                uxConfigBuilder.enableIntegrationLogging(enableIntegrationLogging);
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
