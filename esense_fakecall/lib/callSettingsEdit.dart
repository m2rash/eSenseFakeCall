import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'storage.dart';


class CallSettingsEditView extends StatelessWidget{

  StorageHandler sh = new StorageHandler();
  int settingIndex;

  CallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex;
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
            return Scaffold(
              // backgroundColor: Colors.deepOrange,
              appBar: AppBar(
                title: Text(sh.getSettingName(setting)),
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

                        Center (child: 
                          CircularProfileAvatar(
                            sh.getPicLocation(setting),
                                radius: 70,
                                backgroundColor: Colors.green,
                                initialsText: Text(
                                  sh.getCallerName(setting).substring(0, 2),
                                  style: TextStyle(fontSize: 40, color: Colors.white),
                                ),
                                elevation: 5.0,
                                onTap: () {
                                  print(sh.getCallerName(setting));
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
                      ),
                  ),
                  
                ],
              ),



              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    await sh.deleteSetting(settingIndex);
                    Navigator.pop(context);
                  },
              ),
            );
            //TODO delete button   
      } 
      );

  
  }
  

}