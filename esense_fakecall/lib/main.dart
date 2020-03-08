import 'dart:io';

import 'package:eSenseFC/gyroTest.dart';
import 'package:eSenseFC/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'callSettings.dart';
import 'musicPlayer.dart';
import 'gyroTest.dart';
import 'storage.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSense MC',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Overview(),
    );
  }
}






class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}
  
    
class _OverviewState extends State<Overview>{

  int _currentTabIndex = 0;
  


  @override
  Widget build(BuildContext context) {

    final _kTabPages = <Widget>[
      //InCallView(),
      HomeView(),
      ESenseTest(),
      //Center(child: Icon(Icons.alarm, size: 64.0, color: Colors.cyan)),
    ];


    Widget bottomNavbar = new BottomAppBar(
        elevation: 0,
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              IconButton(
                color: Colors.grey.shade700,
                icon: Icon(Icons.home, size: 30,), onPressed: (){setState(() {
                  _currentTabIndex = 0;});
                },
              ),
                
              Spacer(),
              IconButton(
                color: Colors.grey.shade700,
                icon: Icon(Icons.menu,size: 30,), onPressed: (){setState(() {
                  _currentTabIndex = 1;});
                },
              ),
              SizedBox(width: 20.0),
            ],
          ),
        ),
      );



    /*String loadNewAudioFile() {
      String path = FilePicker.getFilePath(type: FileType.AUDIO) as String;
      //File file = await FilePicker.getFile(type: FileType.AUDIO);
      print(path);
      
      return path;
    }*/



    return Scaffold(
      appBar: AppBar(
        title: const Text('eSense MC Home'),
      ),
      body: _kTabPages[_currentTabIndex],

      bottomNavigationBar: bottomNavbar,
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){new StorageHandler().storeSetting(['test', 'test', 'test', 'test', 'true']);/*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => )
                      );*/
              },
      ),
  
    );



    
  }
}
















