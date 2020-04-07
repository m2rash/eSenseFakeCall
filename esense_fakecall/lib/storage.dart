import 'dart:async';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {

  String keyListId = 'keylist5';
  String ringToneId = 'RingTone';
  String exampleSetting = '__fakeCallSampleSetting__';
  List<String> keyList;

  Future<bool> initHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.keyList = prefs.getStringList(keyListId) ?? [];
    //print('got keyList' + keyList[0]);

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
  ///StringDef: [settingsName, callerName, PicLocaion, audioLocation, activ?]
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
  ///StringDef: [settingsName, callerName, PicLocaion, audioLocation, activ?]
  ///returns true for success and false if the new one is a duplicate
  Future<bool> storeSetting(List<String> newSetting, int index) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<List<String>> settings = await this.getAllSettings();
    print('saveSettingslength: ' + settings.length.toString());

    if (index == -1) {
      //Set new Index for new setting
      index = keyList.length;
      keyList.add(newSetting[0]);
      await prefs.setStringList(keyListId, keyList);
    } else {
      if (getSettingName(settings[index]) != getSettingName(newSetting)) {
        
        //TODO Check duplicate and exampleName
        //TODO Fehlschlag abfangen

        //set new SettingName
        this.keyList[index] = getSettingName(newSetting);
        await prefs.setStringList(keyListId, keyList);
      }
    }

    await prefs.setStringList(getSettingName(newSetting), newSetting);

    return false;
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

  bool isSettingActive(List<String> setting) {
    return setting[4] == 'true';
  }



  setSettingName(List<String> setting, String newSettingName) async {
    if (newSettingName != null) {
      setting[0] = newSettingName;
    }
  }

  setCallerName(List<String> setting, String newCallerName) async {
    if (newCallerName != null) {
      setting[1] = newCallerName;
    }
  }

  setImageLocation(List<String> setting, String path) async{
    if (path != null) {
      setting[2] = path;
    }
  }
  
  setAudioPath(List<String> setting, String path) async{
    if (path != null) {
      setting[3] = path;
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