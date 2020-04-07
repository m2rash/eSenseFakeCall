import 'dart:async';

import 'package:eSenseFC/callSettingsEdit.dart';
import 'package:eSenseFC/generalSettings.dart';
import 'package:eSenseFC/homescreen.dart';
import 'package:eSenseFC/incomingCall.dart';
import 'package:flutter/material.dart';



import 'EsenseControl.dart';
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
  _OverviewState os;
  static bool callAllowed = false;
  static List<String> aktivSetting;

  static activateSetting(List<String> setting) {
    Overview.aktivSetting = setting;
    Overview.callAllowed = true;
  }

  static deactivateSetting() {
    Overview.aktivSetting = null;
    Overview.callAllowed = false;
  }

  activateCall() {
    os._activateCall();
  }

  @override
  _OverviewState createState() => this.os = _OverviewState(this);
}
  
    
class _OverviewState extends State<Overview>{

  int _currentTabIndex = 0;
  bool shouldCall = false;
  Overview ov;
  EsenseControler controler;

  _OverviewState(Overview overview) {
    this.ov = overview;
    this.controler = new EsenseControler(ov);
    // Overview.aktivSetting = ['NewSetting0', 'CallerName', '', '/storage/emulated/0/Download/Guardians of the Galaxy Klingelton.wav', 'true'];
  }
  
  _activateCall() {
    this.setState(() {this.shouldCall = true;});
  }

  @override
  Widget build(BuildContext context) {
    // controler = new EsenseControler(context);
    print('mainBuild!' + shouldCall.toString());

    if(shouldCall ) {
      List<String> s = Overview.aktivSetting;
      this.shouldCall = false;
      Overview.deactivateSetting();

      if (s != null) {
        return InComingCallView(s);
      }
    }

    final _kTabPages = <Widget>[
      //InCallView(),
      HomeView(),
      // MyApp1(),
      GeneralSettingsView(),
      // EsenseTest(),
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




    return Scaffold(
      appBar: AppBar(
        title: const Text('eSense Home'),
        actions: <Widget>[
          // TODO + Button designen
            MaterialButton(
              child: Icon(Icons.add),//Text("New Setting"),
              shape: StadiumBorder(),
              textTheme: ButtonTextTheme.primary,
              onPressed: (){
                new StorageHandler().createSettingForEdit().then((value) => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CallSettingsEditView(-1)))
                        });
              },
            ),
        ],
      ),

      body: _kTabPages[_currentTabIndex],

      bottomNavigationBar: bottomNavbar,
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ActivationButton(),
    );
  }
}


class ActivationButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActivationButtonState();
}

class _ActivationButtonState extends State<ActivationButton> {

  bool active = false;

  @override
  Widget build(BuildContext context) {


    if (!active) {
      return FloatingActionButton(
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.green,
          onPressed: (){
            StorageHandler().getRandomSetting().then((value) {
                setState(() {
                  this.active = true;
                  Overview.activateSetting(value);
                });
            });
          },
      );
    } else {
      return FloatingActionButton(
          child: Icon(Icons.stop),
          backgroundColor: Colors.red,
          onPressed: (){
            setState(() {
              this.active = false;
              Overview.deactivateSetting();
            });
          },
      );
    }
  }
  
}