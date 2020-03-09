import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {

  String keyListId = 'keylist4';
  List<String> keyList;
  List<List<String>> settings;


  Future<bool> initHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.keyList = prefs.getStringList(keyListId) ?? [];
    //print('got keyList' + keyList[0]);

    return true;
  }


//




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
    
    return prefs.getStringList(keyList[index]);
  }






  createSettingForEdit() {
    //TODO
  }

  ///Stores a StringList with all information about a fakeCall.
  ///StringDef: [settingsName, callerName, PicLocaion, audioLocation, activ?]
  ///returns true for success and false if the new one is a duplicate
  Future<bool> storeSetting(List<String> setting) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //TODO await for Bedingung?
    //No duplicates
    if (!prefs.containsKey(setting[0])) {
      print('object');
      prefs.setStringList(setting[0], setting);
      keyList.add(setting[0]);
      prefs.setStringList(keyListId, keyList);
      return true;
    }

    return false;
  }

  deleteSetting(int index) async {
    await initHandler();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(keyList[index]);
    await prefs.remove(keyListId);
    keyList.remove(keyList[index]);
    print('new keyLength> ' + keyList.length.toString());
    prefs.setStringList(keyListId, keyList);
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

      int index = keyList.indexOf(setting[0]);
      String oldName = setting[0];

      setting[0] = newSettingName;

      await initHandler();
      SharedPreferences prefs = await SharedPreferences.getInstance();


      await prefs.setStringList(setting[0], setting);
      keyList[index] = setting[0];
      await prefs.setStringList(keyListId, keyList);
      await prefs.remove(oldName);
    }
  }

  setCallerName(List<String> setting, String newCallerName) async {
    if (newCallerName != null) {

      setting[1] = newCallerName;

      await initHandler();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setStringList(setting[0], setting);
    }
  }

  setImageLocation(List<String> setting, String path) async{
    if (path != null) {
      
      setting[2] = path;

      await initHandler();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setStringList(setting[0], setting);
    }
  }
  
  setAudioPath(List<String> setting, String path) async{
    if (path != null) {
      
      setting[3] = path;

      await initHandler();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setStringList(setting[0], setting);
    }
  }












/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////







  /*List<Map> callList = [
    {
      "name": "Hamster tot",
      "callerName": "Kübel Kotze",
      "picLocation": "https://avatars0.githubusercontent.com/u/8264639?s=460&v=4",
      "audioLocation": "/data/user/0/com.example.esense_fakecall/cache/Doctor Who Theme 5.mp3",
      "activ": "true",
    },
    {
      "name": "Hamster lebendig",
      "audioLocation": "path",
      "callerNameLocation": "callerName",
      "picLocation": "pic",
      "activ": "true",
    },
    
    
  ];

  String getSettingName(int i) {
    return '${callList[i]['name']}';
  }

  String getCallerName(int i) {
    return '${callList[i]['callerName']}';
  }

  String getAudioLocation(int i) {
    return '${callList[i]['audioLocation']}';
  }

  String getPicLocation(int i) {
    return '${callList[i]['picLocation']}';
  }


  Map getCallSettings(int i) {

  }




  addCallSettingsToList(Map callSetting) {
    //TODO longTermSave
    callList.add(callSetting);
  }


  Map createNewCallSeting() {
    Map cs = {
      "name": "_Enter SettingName_",
      "audioLocation": "_audioLocation_",
      "callerName": "_Enter CallerName_",
      "picLocation": "_pic Location_",
      "activ": "false",
    };

    addCallSettingsToList(cs);
  }*/

}