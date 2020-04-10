import 'dart:async';
import 'dart:io';

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
  String title = 'Home';
  bool shouldCall = false;
  Overview ov;
  EsenseControler controler;

  _OverviewState(Overview overview) {
    this.ov = overview;
    this.controler = new EsenseControler(ov);
  }


  
  _activateCall() {
    this.setState(() {this.shouldCall = true;});
  }

  _switchTabIndex(int index) {
    this.setState(() {
      this._currentTabIndex = index;
      if (index == 0) this.title = 'Home';
      else if (index == 1) this.title = 'Settings';
    });
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
      HomeView(),
      // MyApp1(),
      GeneralSettingsView(),
    ];


    




    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black),),
        actions: _currentTabIndex == 0 ? 
                    <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        onPressed: (){
                          new StorageHandler().createSettingForEdit().then((value) => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CallSettingsEditView(-1)))
                                  });
                        },
                      ),
                    ] 
                  : [],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: _kTabPages[_currentTabIndex],

      bottomNavigationBar: NavBar(this._switchTabIndex),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ActivationButton(),
    );
  }
}



class NavBar extends StatefulWidget {

  final void Function(int index) switchTab;

  NavBar(this.switchTab);

  @override
  State<StatefulWidget> createState() => NavBarState(this.switchTab);
  
}

class NavBarState extends State<NavBar> {

  void Function(int index) switchTab;

  NavBarState(this.switchTab);

  Color activeColor = Colors.black;
  Color inactiveColor = Colors.grey[400];
  int currentIndex = 0;


  _updateTab(int index) {
    switchTab(index);
    this.setState(() {this.currentIndex = index;});
  }


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          child: Row(
            children: <Widget>[
              IconButton(
                color: currentIndex == 0
                      ? this.activeColor
                      : this.inactiveColor,
                icon: Icon(Icons.home, size: 30,),
                padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0), 
                onPressed: (){
                    if (currentIndex != 0) this._updateTab(0);
                },
              ),
                
              Spacer(),

              IconButton(
                color: currentIndex == 1
                      ? this.activeColor
                      : this.inactiveColor,
                icon: Icon(Icons.settings,size: 30,), 
                padding: EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                onPressed: (){
                    if (currentIndex != 1) this._updateTab(1);
                },
              ),
            ],
          ),
        ),
      );
  }
}






class ActivationButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActivationButtonState();
}

class _ActivationButtonState extends State<ActivationButton> {

  bool active = false;
  StorageHandler sh = new StorageHandler();

  @override
  Widget build(BuildContext context) {

    if (!active) {
      return FloatingActionButton(
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.green,
          onPressed: (){
            sh.getRandomSetting().then((value) async {
                bool audioPathVal = await File(sh.getAudioLocation(value)).exists();
                if (!audioPathVal) {
                  _showAlert(context, sh.getSettingName(value));
                } else {
                  setState(() {
                    this.active = true;
                    Overview.activateSetting(value);
                  });
                }
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


  _showAlert(BuildContext context, String settingName) {
    String errorMessages = 'Invlaid AuioPath in Setting: "' + settingName + '"';

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: new Text("ERROR!!!"),
          content: new Text(errorMessages),
          actions: <Widget>[
            MaterialButton(
              child: Text("I understood"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.red,
              elevation: 3,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}