package com.uxcam;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONObject;
import android.util.Log;
import com.uxcam.UXCam;

public class UXCamPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callback) throws JSONException {
        try {
            Log.d("UXCamPlugin","action is "+action);
            if ("startWithKey".equals(action)) {
                this.start(args);
            }else if("stopUXCamCameraVideo".equals(action)){
                UXCam.stopUXCamCameraVideo(this.cordova.getActivity());
            }
            else if("stopApplicationAndUploadData".equals(action)){
                UXCam.stopApplicationAndUploadData();
            }
            else if("markUserAsFavorite".equals(action)){
                UXCam.markSessionAsFavorite();
            }
            else if("tagUsersName".equals(action)){
                String userName = args.getString(0);
                if (userName == null || userName.length() == 0) {
                    throw new IllegalArgumentException("missing user Name");
                }
                UXCam.tagUsersName(userName);
            }
			else if("setAutomaticScreenNameTagging".equals(action))
			{
				
			}
			else if("tagScreenName".equals(action)){
                String screenName = args.getString(0);
                if (screenName == null || screenName.length() == 0) {
                    throw new IllegalArgumentException("missing screen Name");
                }
                UXCam.tagScreenName(screenName);
            }
            else if("addTag".equals(action)){
                String eventName = args.getString(0);
                if (eventName == null || eventName.length() == 0) {
                    throw new IllegalArgumentException("missing event Name");
                }
                UXCam.addTagWithProperties(eventName);
            }
            else if("addTagWithProperties".equals(action)){
                String eventName = args.getString(0);
                JSONObject params = args.getJSONObject(1);

                if (eventName == null || eventName.length() == 0) {
                    throw new IllegalArgumentException("missing event Name");
                }
                if (params == null || params.length() == 0) {
                    UXCam.addTagWithProperties(eventName);
                }else{
                    UXCam.addTagWithProperties(eventName, params);
                }
            }
            else if("occludeSensitiveScreen".equals(action)){
                boolean occludeSensitiveScreen = args.getBoolean(0);
                UXCam.occludeSensitiveScreen(occludeSensitiveScreen);
            }
            else if("addVerificationListener".equals(action)){
                String url = UXCam.urlForCurrentUser();
                if (url.contains("null")){
                    addListener(callback);
                    return true;
                }
                callback.success(url);
            }
            else if("urlForCurrentUser".equals(action)){
                String url = UXCam.urlForCurrentUser();
                callback.success(url);
            }
            else if("urlForCurrentSession".equals(action)){
                String url = UXCam.urlForCurrentSession();
                callback.success(url);
            }
            else {
                callback.error("Unknown UXCam API called: " + action);
                return false;
            }
            callback.success(String.format("UXCam.%s(%s)", action, args.join(", ")));
            return true;
        } catch (Exception exception) {
            callback.error(exception.getMessage());
            return false;
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
            UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key);

        }
        else if (args.length() == 2){
            key = args.getString(0);
            buildIdentifier = args.getString(1);
            if (key == null || key.length() == 0 || buildIdentifier == null || buildIdentifier.length() == 0) {
                throw new IllegalArgumentException("missing api key or buildIdentifier");
            }
            UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key, buildIdentifier);

        }else{
            throw new IllegalArgumentException("unsupported number of arguments");
        }
    }

    private void addListener(final CallbackContext callback) {
        UXCam.addVerificationListener(new UXCam.OnVerificationListener() {
            @Override
            public void onVerificationSuccess() {
                callback.success(UXCam.urlForCurrentUser());
            }

            @Override
            public void onVerificationFailed(String errorMessage) {
                callback.error(errorMessage);
            }
        });
    }
}
