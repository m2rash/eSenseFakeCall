import 'dart:io';
import 'dart:math';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:eSenseFC/musicPlayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'storage.dart';


class CallSettingsEditView extends StatelessWidget{

  StorageHandler sh = new StorageHandler();
  int settingIndex;
  List<String> setting;
  AudioPathField audioPathField;


  CallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex;
  }


  Future<bool> _saveSetting() {
    sh.setAudioPath(setting, audioPathField.path);
    return sh.storeSetting(setting, settingIndex);
  }

  _exit (BuildContext context) {
    Navigator.pop(context);
    if (Navigator.canPop(context)) {Navigator.pop(context);}
  }


  _setProfilImage(List<String> setting) {
      Future<String> path = FilePicker.getFilePath(type: FileType.IMAGE);
      path.then((value) => {});
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
            this.audioPathField = AudioPathField(sh.getAudioLocation(setting));
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
                    onPressed: (){
                      _saveSetting().then((value) => {_exit(context)});
                    },
                )
              ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),



              body: ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.5, 0.9],
                        colors: [
                          Colors.transparent,
                          Colors.transparent
                        ]
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Center (child: //Image.file(File(sh.getPicLocation(setting)))
                          CircularProfileAvatar(
                            sh.getPicLocation(setting),
                                radius: 70,
                                backgroundColor: Colors.green,
                                initialsText: Text(
                                  sh.getCallerName(setting).substring(0, min(2, sh.getCallerName(setting).length)),
                                  style: TextStyle(fontSize: 40, color: Colors.white),
                                ),
                                elevation: 5.0,
                                onTap: () {
                                  print(sh.getCallerName(setting));
                                  _setProfilImage(setting);
                                },
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: .0),
                    child:
                      ListTile(
                        leading: Container(
                          width: 40, // can be whatever value you want
                          alignment: Alignment.center,
                          child: Icon(Icons.person, size: 27,),
                        ),
                        title: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                            decoration: InputDecoration(
                                hintText: sh.getCallerName(setting),
                            ),
                            onSubmitted: (String value) async {
                              sh.setCallerName(setting, value);
                            },
                        )
                      ),
                  ),
                  

                  audioPathField,
                  
                ],
              ),



              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    sh.setAudioPath(setting, audioPathField.path);
                    print('Path: ' + audioPathField.path);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InCallView(sh.getAudioLocation(this.setting)),
                        )
                      );
                  },
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
  AudioPathFieldState createState() => AudioPathFieldState(path, this);
  
}

class AudioPathFieldState extends State<AudioPathField> {

  String path;
  AudioPathField field;

  AudioPathFieldState (String path, AudioPathField field) {
      this.path = path;
      this.field = field;
  }

  _saveAudioFilePath(String path) {
    this.setState(() {
        this.path = path;
    });
    field.path = path;
  }

  _setAudioFile() {
    Future<String> path = FilePicker.getFilePath(type: FileType.AUDIO);
       path.then((value) => _saveAudioFilePath(value));
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