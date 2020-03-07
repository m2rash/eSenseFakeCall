//import 'package: circular_profile_avatar/'
import 'package:eSenseFC/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'musicPlayer.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewState();
 
}



  class _HomeViewState extends State<HomeView> {

  final StorageHandler sh = new StorageHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ListView.builder(
            itemCount: sh.callList.length,
            itemBuilder: (context, index) {
              	return Card (
                    elevation: 6.0,
                    margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),

                    child: ListTile(
                           leading: Icon(Icons.ac_unit),
                           title: Text(sh.getSettingName(index)),
                           subtitle: Text("Subtitle"),
                           trailing: Icon(Icons.more_vert),
                           //TODO SettingsView anzeigen
                           onTap: (){Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => InCallView(sh.getAudioLocation(index))
                                      ),
                                    );},
                    ),

                );
            },
      )
    );
  }
}       







  /*Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 85,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(



        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              /*image: DecorationImage(
                  image: CachedNetworkImageProvider(schoolLists[index]['logoText']),
                  fit: BoxFit.fill),*/
            ),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  callList[index]['name'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
    }*/