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
  Future<List<String>> f;
//TODO Zwischenspeichern
  CallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex;
      f = sh.getSetting(settingIndex);
  }




  Future<String> _setProfilImage(List<String> setting) {
      Future<String> path = FilePicker.getFilePath(type: FileType.IMAGE);
      path.then((value) => sh.setImageLocation(setting, value));
  }
  
  Future<String> _setAudioFile(List<String> setting, BuildContext context) {
      Future<String> path = FilePicker.getFilePath(type: FileType.AUDIO);
      path.then((value) => sh.setAudioPath(setting, value).then(_refreshView(context)));
  }





  _refreshView(BuildContext context) {
    print('refresh');
    //TODO nur Notlösung: evtl futuerBuilder austauschen
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => this)
    );
                                  
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
            List<String> setting = snapshot.data ?? [];
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
                  


                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: .0),
                    child:
                      ListTile(
                        leading: Container(
                          width: 40, // can be whatever value you want
                          alignment: Alignment.center,
                          child: Icon(Icons.play_circle_filled, size: 27,),
                        ),
                        title: Text('Audio File', style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
                        subtitle: Text(sh.getAudioLocation(setting), style: TextStyle(fontSize: 19.0),),
                        onTap: () {_setAudioFile(setting, context);},
                      ),
                  ),
                  
                ],
              ),



              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InCallView(sh.getAudioLocation(setting)),
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