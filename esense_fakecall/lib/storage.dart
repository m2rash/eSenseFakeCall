
class StorageHandler {

  List<Map> callList = [
    {
      "name": "Hamster tot",
      "audioLocation": "/data/user/0/com.example.esense_fakecall/cache/Doctor Who Theme 5.mp3",
      "callerName": "callerName",
      "picLocation": "pic",
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
  }

}