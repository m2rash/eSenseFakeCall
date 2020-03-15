import 'dart:io';
import 'dart:math';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:eSenseFC/inCall.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'storage.dart';


class AltCallSettingsEditView extends StatefulWidget{

  int settingIndex;
  AltCallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex; 
  }

@override
  AltSettingEditState createState() => AltSettingEditState(settingIndex);
}


class AltSettingEditState extends State<AltCallSettingsEditView>{
  StorageHandler sh = new StorageHandler();
  int settingIndex;
  List<String> setting;


  AltSettingEditState (int settingIndex) {
      this.settingIndex = settingIndex; 
  }  




  Future<String> _setProfilImage(List<String> setting) {
      Future<String> path = FilePicker.getFilePath(type: FileType.IMAGE);
      path.then((value) => sh.setImageLocation(setting, value));
  }
  
  Future<String> _setAudioFile(List<String> setting, BuildContext context) {
      Future<String> path = FilePicker.getFilePath(type: FileType.AUDIO);
      path.then((value) => _refreshView(value));
  }

  _aktPath(String path) {
    this.setting[3] = path;
  }



  _refreshView(String value) {
    print('refresh' + value);
    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => this)
    // );
    this.setState(() {setting[3] = value;});
  }
  
  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
            future: sh.getSetting(settingIndex),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done) {
                return Center(child: Text('Loading.....'));
              }
              if(snapshot.hasError) {
                return Center(child: Text('Error!!!!!'));
              }
            this.setting = snapshot.data ?? [];
            print('EditView Setting: ' + setting.toString());
            return Scaffold(
              // backgroundColor: Colors.deepOrange,
                                                          appBar: AppBar(
                                                            title: TextField(
                                                                  textCapitalization: TextCapitalization.sentences,
                                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                                                                  decoration: InputDecoration(
                                                                      
                                                                      hintText: sh.getSettingName(setting),
                                                                      suffixIcon: Icon(Icons.edit)
                                                                  ),
                                                                  onSubmitted: (String value) {
                                                                    sh.setSettingName(setting, value);
                                                                  },
                                                            ),
                                                              //Text(sh.getSettingName(setting)),
                                                            actions: <Widget>[
                                                              MaterialButton(
                                                                child: Text("Save"),
                                                                shape: StadiumBorder(),
                                                                //color: Colors.red,
                                                                textTheme: ButtonTextTheme.primary,
                                                                onPressed: (){},
                                                            )
                                                          ],
                                                            backgroundColor: Colors.transparent,
                                                            elevation: 0,
                                                          ),



              body: ListView(
                children: <Widget>[

                  AudioPathField(sh.getAudioLocation(setting)),
                  
                ],
              ),



              
            );
            //TODO delete button   
      } 
      );

  
  }

  
  

}

class AudioPathField extends StatefulWidget{

  String path;

  AudioPathField(String path) {
    this.path = path;
  }

  @override
  AudioPathFieldState createState() => AudioPathFieldState(path);
  
}

class AudioPathFieldState extends State<AudioPathField> {

  String path;

  AudioPathFieldState (String path) {
      this.path = path;
  }

  _setAudioFile() {
    setState(() {
      this.path = 'newpath';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: new EdgeInsets.symmetric(horizontal: .0),
        child:
          ListTile(
            leading: Container(
              width: 40, // can be whatever value you want
              alignment: Alignment.center,
              child: Icon(Icons.play_circle_filled, size: 27,),
            ),
            title: Text('Audio File', style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text(path, style: TextStyle(fontSize: 19.0),),
            onTap: () {_setAudioFile();},
          ),
      );
  }

}


