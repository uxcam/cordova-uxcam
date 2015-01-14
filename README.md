# Cordova UXCam plugin

## Add UXCam plugin

STEP 1: INTEGRATE  WITH PHONEGAP

cordova plugin add com.uxcam.cordova.plugin

or

phonegap plugin add com.uxcam.cordova.plugin


Supported platforms: android, ios

---

STEP 2: START UXCAM

Call the startApplicationWithKey method on deviceready to start the UXCam session:

#### startApplicationWithKey
Starts the UXCam session

UXCam.startApplicationWithKey("App-key from https://www.uxcam.com to be placed here");

---

### OPTIONAL METHODS

#### stopApplicationAndUploadData 
Stops the UXCam application and sends captured data to the server. Use this to start sending the data on UXCam server without waiting for the app going into the background.

UXCam.stopApplicationAndUploadData();


#### stopUXCamCameraVideo
Stops the faceCamera video recording if your application uses camera 

UXCam.stopUXCamCameraVideo ();


#### tagScreenName
UXCam captures the view controller name automatically but in case where it doesn’t (such as in OpenGL) or you would like to set a different unique name, use this function.

UXCam.tagScreenName(“Screen Name”)
Parameters 
screenName: The name of the screen as required.


#### tagUserName
UXCam uses a unique number to tag a device. You can tag a device allowing you to search for it on the dashboard and review their session further.

UXCam.tagUserName(“User name”);
Parameters 
userName: The name of the tag of device


#### markUserAsFavorite
You can mark a user specifically if certain condition are met making them a good user for further testing. You can then filter these users and perform further test.

UXCam.markUserAsFavorite();


#### addTag
Insert a general tag into the timeline - stores the tag with the timestamp when it was added. 

UXCam.addTag(“Tag”);
Parameters 
Tag: The name of the tag

