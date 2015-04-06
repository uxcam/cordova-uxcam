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

UXCam.startApplicationWithKey = function(key, successCallback, errorCallback)
{
  return exec(successCallback, errorCallback, 'UXCam', 'start', [key]);
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

module.exports = UXCam;