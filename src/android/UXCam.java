package com.uxcam.cordova;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class UXCam extends CordovaPlugin {
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("UXCamPlugin","action is "+action+ ", args"+ args.toString());
        if ("startWithKey".equals(action)) {
            this.start(args);
        }
        else if("stopApplicationAndUploadData".equals(action)){
            com.uxcam.UXCam.stopApplicationAndUploadData();
        }
        else if("markUserAsFavorite".equals(action)){
            com.uxcam.UXCam.markSessionAsFavorite();
        }
        else if("tagUsersName".equals(action)){
            String userName = args.getString(0);
            if (userName == null || userName.length() == 0) {
                throw new IllegalArgumentException("missing user Name");
            }
            com.uxcam.UXCam.tagUsersName(userName);
        }
        else if("setAutomaticScreenNameTagging".equals(action))
        {
            Log.d("UXCamPlugin","action "+action+" is not supported by UXCam Android");
        }
        else if("tagScreenName".equals(action)){
            String screenName = args.getString(0);
            if (screenName == null || screenName.length() == 0) {
                throw new IllegalArgumentException("missing screen Name");
            }
            com.uxcam.UXCam.tagScreenName(screenName);
        }
        else if("addTag".equals(action)){
            String eventName = args.getString(0);
            if (eventName == null || eventName.length() == 0) {
                throw new IllegalArgumentException("missing event Name");
            }
            com.uxcam.UXCam.addTagWithProperties(eventName);
        }
        else if("addTagWithProperties".equals(action)){
            String eventName = args.getString(0);
            JSONObject params = args.getJSONObject(1);
            
            if (eventName == null || eventName.length() == 0) {
                throw new IllegalArgumentException("missing event Name");
            }
            if (params == null || params.length() == 0) {
                com.uxcam.UXCam.addTagWithProperties(eventName);
            }else{
                com.uxcam.UXCam.addTagWithProperties(eventName, params);
            }
        }
        else if("occludeSensitiveScreen".equals(action)){
            boolean occludeSensitiveScreen = args.getBoolean(0);
            com.uxcam.UXCam.occludeSensitiveScreen(occludeSensitiveScreen);
        }
        else if("addVerificationListener".equals(action)){
            String url = com.uxcam.UXCam.urlForCurrentUser();
            if (url.contains("null")){
                addListener(callbackContext);
                return true;
            }
            callbackContext.success(url);
        }
        else if("urlForCurrentUser".equals(action)){
            String url = com.uxcam.UXCam.urlForCurrentUser();
            callbackContext.success(url);
        }
        else if("urlForCurrentSession".equals(action)){
            String url = com.uxcam.UXCam.urlForCurrentSession();
            callbackContext.success(url);
        }
        else {
            callbackContext.error("This API call is not supported by UXCam Android, API called: " + action);
            return false;
        }
        return true;
    }
    
    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
    
    
    private void start(final JSONArray args) throws IllegalArgumentException, JSONException {
        String key;
        String buildIdentifier;
        if (args.length() == 1){
            key = args.getString(0);
            if (key == null || key.length() == 0) {
                throw new IllegalArgumentException("missing api key");
            }
            com.uxcam.UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key);
            
        }
        else if (args.length() == 2){
            key = args.getString(0);
            buildIdentifier = args.getString(1);
            if (key == null || key.length() == 0 || buildIdentifier == null || buildIdentifier.length() == 0) {
                throw new IllegalArgumentException("missing api key or buildIdentifier");
            }
            com.uxcam.UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key, buildIdentifier);
            
        }else{
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

