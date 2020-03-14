//import 'package: circular_profile_avatar/'
import 'package:eSenseFC/callSettings.dart';
import 'package:eSenseFC/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'musicPlayer.dart';
import 'callSettingsEdit.dart';

class HomeView extends StatelessWidget {

  StorageHandler sh = new StorageHandler();


  @override
  Widget build(BuildContext context) {
    print('new HomeBuild');
    
    print('start building');
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
                  return Card (
                      elevation: 6.0,
                      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),

                      child: ListTile(
                            leading: Container(
                                width: 40,
                                alignment: Alignment.center,
                                  //TODO Bilder
                                child: Icon(Icons.play_circle_filled, size: 27,),
                              ),
                            title: Text(sh.getSettingName(settings[index])),
                            subtitle: Text("Subtitle"),
                            trailing: OverviewPopUp(this.sh, index),
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

  StorageHandler sh;
  int index;
  BuildContext context;

  OverviewPopUp(StorageHandler sh, int index) {
    this.sh = sh;
    this.index = index;
  }

  _play() {
    sh.getSetting(index).then((value) =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InCallView(sh.getAudioLocation(value))),
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
    sh.deleteSetting(index);
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