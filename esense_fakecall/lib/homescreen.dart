import 'package:eSenseFC/callSettings.dart';
import 'package:eSenseFC/profileImage.dart';
import 'package:eSenseFC/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'callSettingsEdit.dart';
import 'incomingCall.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}



class HomeViewState extends State<HomeView> {

  StorageHandler sh = new StorageHandler();


  _updateHomeView() => this.setState(() {this.sh = new StorageHandler();});

  @override
  Widget build(BuildContext context) {
    print('new HomeBuild');
    return Scaffold(
      body: FutureBuilder(
          future: sh.getAllSettings(),
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Center(child: Text('Loading.....'));
            }
            if(snapshot.hasError) {
              return Center(child: Text('Error!!!!!'));
            }
            List<List<String>> settings = snapshot.data ?? [];
            //TODO nicht aktive settings abfangen
            print('in Overview Settingslength: ' + settings.length.toString());
            return ListView.builder( 
              itemCount: settings.length,
              itemBuilder: (context, index) {
                  print(settings[index]);
                  return Card (
                      elevation: 6.0,
                      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: ListTile(
                            leading: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                child: ProfileImage(sh.getPicLocation(settings[index]), sh.getCallerName(settings[index]), sh.getColor(settings[index]), 0),
                              ),
                            title: Text(sh.getSettingName(settings[index]), style: TextStyle(fontSize: 18,),),
                            subtitle: Text(sh.getCallerName(settings[index])),
                            trailing: OverviewPopUp(this, this.sh, index),
                            onTap: (){Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CallSettingsView(index),
                                        )
                                      );
                                    }
                      ),
                );
                },
      
            );
          },
      ),
    );
  }
}       




class OverviewPopUp extends StatelessWidget{

  HomeViewState homeViewState;
  StorageHandler sh;
  int index;
  BuildContext context;

  OverviewPopUp(HomeViewState homeViewState, StorageHandler sh, int index) {
    this.homeViewState = homeViewState;
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
    sh.deleteSetting(index).then((value) => homeViewState._updateHomeView());
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
      icon: Icon(Icons.more_vert, color: Colors.black,),
        onSelected: choiceAction,
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
                  value: 'Play',
                  child: ListTile(
                    leading: Icon(Icons.play_arrow, color: Colors.black),
                    title: Text('Play', style: TextStyle(color: Colors.black)),
                  )
          ),
          PopupMenuItem(
                  value: 'Edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.black,),
                    title: Text('Edit', style: TextStyle(color: Colors.black)),
                  )
          ),
          PopupMenuItem(
                  value: 'Delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.black,),
                    title: Text('Delete', style: TextStyle(color: Colors.black)),
                  )
          ),
        ]
    );
  }
}