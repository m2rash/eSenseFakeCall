import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'callSettingsEdit.dart';
import 'incomingCall.dart';
import 'profileImage.dart';
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
              actions: <Widget>[
                  CallSettingPopUp(this.sh, this.settingIndex),
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
                      Center (child: 
                        ProfileImage(sh.getPicLocation(setting), sh.getCallerName(setting), sh.getColor(setting), 1),
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
                      title: Text('Caller Name', style: TextStyle(color: sh.getColor(setting), fontSize: 12.0),),
                      subtitle: Text(sh.getCallerName(setting), style: TextStyle(fontSize: 19.0),),        
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
                      title: Text('Audio File', style: TextStyle(color: sh.getColor(setting), fontSize: 12.0),),
                      subtitle: Text(sh.getAudioLocation(setting), style: TextStyle(fontSize: 19.0),),
                    ),
                ),
                
              ],
            ),



            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.edit, color: Colors.white,),
                backgroundColor: sh.getColor(setting),
                onPressed: () async {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CallSettingsEditView(settingIndex),
                        )
                      );
                },
            ),
          );
    } 
    ); 
  }
}






class CallSettingPopUp extends StatelessWidget{

  StorageHandler sh;
  int index;
  BuildContext context;

  CallSettingPopUp(StorageHandler sh, int index) {
    this.sh = sh;
    this.index = index;
  }

  _play() {
    sh.getSetting(index).then((value) =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InComingCallView(value)),
      )
    );
  }

  _edit(int index) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CallSettingsEditView(index)),
    );
  }

  _delete() {
    sh.deleteSetting(index).then((value) => Navigator.pop(context));
  }

  void choiceAction(String choice){
      if(choice == 'Play'){
        this._play();
      }else if(choice == 'Edit'){
        this._edit(index);
      }else if(choice == 'Delete'){
        this._delete();
      }
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;
    return PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
                  value: 'Play',
                  child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('Play'),
                  )
          ),
          PopupMenuItem(
                  value: 'Edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  )
          ),
          PopupMenuItem(
                  value: 'Delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text('Delete'),
                  )
          ),
        ]
    );
  }
}