import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {

  String keyListId = 'keylist8';
  String ringToneId = 'RingTone';
  String exampleSetting = '__fakeCallSampleSetting__';
  List<String> keyList;

  var possibleColors = [Colors.green, Colors.lightGreen, 
                        Colors.deepOrange, Colors.red, Colors.orange, Colors.lime,
                        Colors.lightBlue, Colors.blue, 
                        Colors.indigo, Colors.deepPurple, Colors.purple, Colors.pink,
                        Colors.brown];


  Future<bool> initHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.keyList = prefs.getStringList(keyListId) ?? [];
    //print('got keyList' + keyList[0]);
    prefs.setStringList(exampleSetting, ['settingsName', 'callerName', '', '', '0']);
    return true;
  }

  






  Future<List<List<String>>> getAllSettings() async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(keyList.length.toString());

    List<List<String>> settings = [];

    for (int i = 0; i < keyList.length; i++) {
      settings.add(prefs.getStringList(keyList[i]));
    }

    // List<String> l = [];
    //settings.add(l);
    print(settings.length.toString());

    return settings;
  }


  ///Returns a StringList with all information about a fakeCall.
  ///StringDef: [settingsName, callerName, PicLocaion, audioLocation, color]
  Future<List<String>> getSetting(int index) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (index == -1) {
      return prefs.getStringList(this.exampleSetting);
    }
    
    return prefs.getStringList(keyList[index]);
  }

  Future<List<String>> getRandomSetting() async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(keyList[new Random().nextInt(keyList.length)]);
  }



  Future<List<String>> createSettingForEdit() async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(this.exampleSetting, ['NewSetting' + keyList.length.toString(), 'CallerName', '', '', 'true']);

    return getSetting(-1);
  }




  ///Stores a StringList with all information about a fakeCall.
  ///StringDef: [settingsName, callerName, PicLocaion, audioLocation, color]
  ///returns 0 for success or a number with error from checkSettingValid() or 100 for unknown Error
  Future<int> storeSetting(List<String> newSetting, int index) async {
    int error = 0;
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<List<String>> settings = await this.getAllSettings();
    print('saveSettingslength: ' + settings.length.toString());

    //Error prevention
    await this.checkSettingValid(newSetting, index).then((value) {
        if (value != 0) error = value;
    });
    if (error != 0) return error;



    if (index == -1) {
      //Set new Index for new setting
      index = keyList.length;
      keyList.add(newSetting[0]);
      await prefs.setStringList(keyListId, keyList);
    } else {
      if (getSettingName(settings[index]) != getSettingName(newSetting)) {
        
        //TODO Fehlschlag abfangen

        //set new SettingName
        this.keyList[index] = getSettingName(newSetting);
        await prefs.setStringList(keyListId, keyList);
      }
    }

    await prefs.setStringList(getSettingName(newSetting), newSetting);

    return 0;
  }

  Future<bool> deleteSetting(int index) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(keyList[index]);
    await prefs.remove(keyListId);
    keyList.removeWhere((item) => item == keyList[index]); //removes also duplicates
    print('new keyLength> ' + keyList.length.toString());
    return prefs.setStringList(keyListId, keyList);
  }


  ///check if setting is valid
  ///returns a number that indicates the errors:
  ///0: valid
  ///1: invalid SettingsName
  ///2: invalid CallerName
  ///3: invalid AudioPath
  Future<int> checkSettingValid(List<String> setting, int index) async {
    // await initHandler();
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    if(this.getSettingName(setting) == this.exampleSetting) return 1;

    if (this.keyList.contains(this.getSettingName(setting))) {
      //is the containing key from the same setting?  | if index == -1 => newSetting => it cant be the same setting
      if (index == -1 || this.getSettingName(setting) != this.keyList[index]) return 1;
    }

    bool audioPathVal = await File(this.getAudioLocation(setting)).exists();
    if (!audioPathVal) return 3;


    return 0;
  }








/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  int getSettingCount() {
    return keyList.length;
  }


  String getSettingName(List<String> setting) {
    return setting[0];
  }

  String getCallerName(List<String> setting) {
    return setting[1];
  }

  String getPicLocation(List<String> setting) {
    return setting[2];
  }

  String getAudioLocation(List<String> setting) {
    return setting[3];
  }

  Color getColor(List<String> setting) {
    int index = int.parse(setting[4]);
    return possibleColors[index];
  }



  setSettingName(List<String> setting, String newSettingName) {
    if (newSettingName != null) {
      setting[0] = newSettingName;
    }
  }

  setCallerName(List<String> setting, String newCallerName) {
    if (newCallerName != null) {
      setting[1] = newCallerName;

      _setColor(setting, newCallerName);
    }
  }

  setImageLocation(List<String> setting, String path) {
    if (path != null) {
      setting[2] = path;
    }
  }
  
  setAudioPath(List<String> setting, String path) {
    if (path != null) {
      setting[3] = path;
    }
  }

  _setColor(List<String> setting, String callerName) {
    if (callerName != null) {
      setting[4] = new Random(callerName.hashCode).nextInt(possibleColors.length).toString();
      // print(setting[4]);
    }
  }




  //----------------------------------------------------------------------------------------------------//  
  //                                             Ring                                                   //
  //----------------------------------------------------------------------------------------------------//  



  Future<String> getRingTone() async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(this.ringToneId);
  }

  Future<bool> setRingTone(String ringTonePath) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(this.ringToneId, ringTonePath);
  }

}