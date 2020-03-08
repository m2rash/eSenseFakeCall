import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:eSenseFC/homescreen.dart';
import 'package:eSenseFC/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'storage.dart';

class CallSettingsView extends StatelessWidget {

  StorageHandler sh = new StorageHandler();
  int settingIndex;

  CallSettingsView (int settingIndex) {
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
                      title: Text('Caller Name', style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
                      subtitle: Text(sh.getCallerName(setting), style: TextStyle(fontSize: 19.0),),
                      onTap: () {sh.setCallerName(setting, 'test');  //TODO Test
                                    
                                    print(sh.getCallerName(setting));},
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

/*final Color color1 = Color(0xffFC5CF0);
    final Color color2 = Color(0xffFE8852);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(sh.getSettingName(setting)),
      ),
      body: Cusrto
      Container(
        child: 
          Column(
            children: [
              Container(
                height: 200,

                child: Center (child: CircularProfileAvatar(
                      'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                          radius: 80,
                          backgroundColor: Colors.green,
                          initialsText: Text(
                            "AD",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                          elevation: 5.0,
                          onTap: () {
                            print('adil');
                          },
                          ),),
              ),

              Container (
                margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                  height: 100,
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: sh.getCallerName(setting),
                      ),
                      onSubmitted: (String value) async {
                        sh.callList[setting]['callerName'] = value;
                        print('new Name:' + sh.callList[setting]['callerName']);
                      },
                  ),
              )
            ],
          ),
          
      ),
    );*/