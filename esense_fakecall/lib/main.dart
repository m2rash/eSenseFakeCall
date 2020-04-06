import 'dart:async';

import 'package:eSenseFC/callSettingsEdit.dart';
import 'package:eSenseFC/generalSettings.dart';
import 'package:eSenseFC/homescreen.dart';
import 'package:eSenseFC/incomingCall.dart';
import 'package:flutter/material.dart';

import 'package:esense_flutter/esense.dart';
import 'package:just_audio/just_audio.dart';


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
  EsenseControler controler;
  


  @override
  Widget build(BuildContext context) {
    controler = new EsenseControler(context);

    final _kTabPages = <Widget>[
      //InCallView(),
      HomeView(),
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
        title: const Text('eSense MC Home'),
      ),
      body: _kTabPages[_currentTabIndex],

      bottomNavigationBar: bottomNavbar,
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){new StorageHandler().createSettingForEdit().then((value) => {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CallSettingsEditView(-1)))
                                          });/*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => )
                      );*/
              },
      ),
  
    );



    
  }
}

class EsenseControler {
  String _deviceName = 'Unknown';
  double _voltage = -1;
  String _deviceStatus = '';
  bool sampling = false;
  String _event = '';
  String _button = 'not pressed';

  BuildContext context;
  final player = AudioPlayer();
  playRing() async {
    var duration = await player.setUrl('/data/user/0/com.example.esense_fakecall/cache/Warrior Concerto');

    player.play();
  }

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0723';

  EsenseControler(BuildContext context) {
    this.context = context;
    _connectToESense();
  }
  

  Future<void> _connectToESense() async {
    bool con = false;

    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = 'connected';
            break;
          case ConnectionType.unknown:
            _deviceStatus = 'unknown';
            break;
          case ConnectionType.disconnected:
            _deviceStatus = 'disconnected';
            break;
          case ConnectionType.device_found:
            _deviceStatus = 'device_found';
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = 'device_not_found';
            break;
        }
      
    });

    con = await ESenseManager.connect(eSenseName);

//TODO Conectionsymbol
      _deviceStatus = con ? 'connecting' : 'connection failed';
  }

  void _listenToESenseEvents() async {
    ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

        switch (event.runtimeType) {
          case DeviceNameRead:
            _deviceName = (event as DeviceNameRead).deviceName;
            break;
          case BatteryRead:
            _voltage = (event as BatteryRead).voltage;
            break;
          case ButtonEventChanged:
            _button = (event as ButtonEventChanged).pressed ? 'pressed' : 'not pressed';
            // playRing();
              
              // StorageHandler().getSetting(0).then((value) => Navigator.push(
              //                             context,
              //                             MaterialPageRoute(builder: (context) => InComingCallView(value),
              //                             )
              //                           ));
              print('!!!!!!!!!!!!!!');
            
            break;
          case AccelerometerOffsetRead:
            // TODO
            break;
          case AdvertisementAndConnectionIntervalRead:
            // TODO
            break;
          case SensorConfigRead:
            // TODO
            break;
        }
    });

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    // get the battery level every 10 secs
    Timer.periodic(Duration(seconds: 10), (timer) async => await ESenseManager.getBatteryVoltage());

    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
    Timer(Duration(seconds: 2), () async => await ESenseManager.getDeviceName());
    Timer(Duration(seconds: 3), () async => await ESenseManager.getAccelerometerOffset());
    Timer(Duration(seconds: 4), () async => await ESenseManager.getAdvertisementAndConnectionInterval());
    Timer(Duration(seconds: 5), () async => await ESenseManager.getSensorConfig());
  }

  StreamSubscription subscription;
  void _startListenToSensorEvents() async {
    // subscribe to sensor event from the eSense device
    subscription = ESenseManager.sensorEvents.listen((event) {
      print('SENSOR event: $event');
        _event = event.toString();
    });
      sampling = true;
  }

  void _pauseListenToSensorEvents() async {
    subscription.cancel();
      sampling = false;
  }
}
















