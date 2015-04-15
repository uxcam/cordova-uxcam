package com.uxcam;

import java.util.Map;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

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
                UXCam.markUserAsFavorite();
            }
            else if("tagUsersName".equals(action)){
                String userName = args.getString(0);
                if (userName == null || userName.length() == 0) {
                    throw new IllegalArgumentException("missing user Name");
                }
                UXCam.tagUsersName(userName);
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
                UXCam.addTag(eventName);
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

    private void start(JSONArray args) throws IllegalArgumentException, JSONException {
        String key = args.getString(0);
        if (key == null || key.length() == 0) {
            throw new IllegalArgumentException("missing api key");
        }

        UXCam.startApplicationWithKeyForCordova(this.cordova.getActivity(), key);
    }

}
