/**
 * UXCam.js
 *
 * Cordova UXCam plugin for version >= 3.0.0
 *
 * Copyright(c) 2015 UXCam Inc.
 */

'use strict';

var exec = require('cordova/exec');

var UXCam = function(){};

UXCam.startWithKey = function(key, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'startWithKey', [key]);
};

UXCam.stopUXCamCameraVideo = function(successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'stopUXCamCameraVideo', []);
};

UXCam.stopApplicationAndUploadData = function(successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'stopApplicationAndUploadData', []);
};

UXCam.markUserAsFavorite = function(successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'markUserAsFavorite', []);
};

UXCam.tagUsersName = function(userName, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'tagUsersName', [userName]);
};

UXCam.tagScreenName = function(screenName, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'tagScreenName', [screenName]);
};

UXCam.addTag = function(eventName, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'addTag', [eventName]);
};
UXCam.occludeSensitiveScreen = function(occludeSensitiveScreen, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'occludeSensitiveScreen', [occludeSensitiveScreen]);
};
module.exports = UXCam;
