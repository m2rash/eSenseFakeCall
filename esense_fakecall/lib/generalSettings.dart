

import 'package:eSenseFC/gyroTest.dart';
import 'package:eSenseFC/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralSettingsView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[

        Card (
            elevation: 6.0,
            margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),

            child: Column(
              children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 20.0, 8.0, 8.0),
                    height: 30,
                    child: Text(
                      'RingTonetone',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                  
                  RingTonePathField(),
                  SizedBox(height: 10,)
              ],
            )

        ),
        

        Card (
            elevation: 6.0,
            margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),

            child: Column(
              children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 20.0, 8.0, 8.0),
                    height: 30,
                    child: Text(
                      'GzroTest',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                    ),
                  ),

                  
                  SizedBox(height: 10,)
              ],
            )

        ),
        // EsenseTest(),
      ],
    );
  }
  
}








class RingTonePathField extends StatefulWidget{

  @override
  RingTonePathFieldState createState() => RingTonePathFieldState();
  
}

class RingTonePathFieldState extends State<RingTonePathField> {

  StorageHandler sh = new StorageHandler();
  String path = '_';

  _setRingToneFilePath(String path) {
    sh.setRingTone(path);
    if (path == null) {
      path = '-';
    }
    this.setState(() {
        this.path = path;
    });
  }

  _setRingToneFile() {
    Future<String> path = FilePicker.getFilePath(type: FileType.audio);
       path.then((value) => _setRingToneFilePath(value));
  }

  @override
  Widget build(BuildContext context) {
    sh.getRingTone().then((value) => this._setRingToneFilePath(value));
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
            onTap: () {_setRingToneFile();},
          ),
      );
  }
}