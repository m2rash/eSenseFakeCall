import 'dart:async';

import 'package:eSenseFC/Essentials/EsenseControl.dart';
import 'package:eSenseFC/Essentials/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';

class GeneralSettingsView extends StatelessWidget {

  EsenseControler controler;
  final EsenseControler Function() updateESenseControler;

  GeneralSettingsView(this.controler, this.updateESenseControler);


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[

        RingTonePathField(),

        ESenseTest(this.controler, this.updateESenseControler),
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
    return Card (
        elevation: 3.0,
        margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),

        child: Column(
          children: <Widget>[
              Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(),
                  height: 30,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'RingTone',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                      ), 
                      
                      // Icon(Icons.play_arrow),
                    ],
                  ),
                ),
                Divider(color: Colors.black,),


              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                leading: Container(
                  width: 40, // can be whatever value you want
                  alignment: Alignment.center,
                  child: Icon(Icons.play_circle_filled, size: 27, color: Colors.black,),
                ),
                title: Text('Audio File', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),),
                subtitle: Text(path, style: TextStyle(fontSize: 19.0),),
                trailing: Icon(Icons.edit, color: Colors.black),
                onTap: () {_setRingToneFile();},
              ),
              
          ],
        )
    );
  }
}



class ESenseTest extends StatefulWidget {

  EsenseControler controler;
  final EsenseControler Function() updateESenseControler;

  ESenseTest(this.controler, this.updateESenseControler);

  @override
  State<StatefulWidget> createState() => ESenseTestState(this.controler, this.updateESenseControler);
  
}

class ESenseTestState extends State<ESenseTest> {

  EsenseControler controler;
  final EsenseControler Function() updateESenseControler;
  Timer t;
  bool connected = false;
  Icon _batteryIcon = Icon(Icons.battery_unknown, color: Colors.yellow[800],);
  Icon _connectionIcon = Icon(Icons.bluetooth_searching, color: Colors.yellow[800],);

  ESenseTestState(EsenseControler controler, this.updateESenseControler) {
    this.controler = controler;
    this.t = Timer.periodic(Duration(seconds: 2), (t) async => this._refreshConnectionState());

  }

  _refreshConnectionState() {
    print(controler.connnected().toString());
    if (!connected) {
      if (controler.connnected()) {
        this._listenToESenseEvents();
        controler.updateBatteryState();
        this.setState(() {this.connected = true;});
      }
      this._setConnectionIcon(controler.getDeviceStatus());
    } 
    else {
      if (!controler.connnected()) {
        if (this._gyroSub != null) this._gyroSub.cancel();
        if (this._batteryAndButtonSub != null) this._batteryAndButtonSub.cancel();
        this.setState(() {this.connected = false;});
        this._setConnectionIcon('disconnected');
      } 
      //normal state
      else {
        controler.updateBatteryState();
      }
    }
  }


  _setConnectionIcon(String state) {
    if (state == 'connected') this.setState(() {this._connectionIcon = Icon(Icons.bluetooth_connected, color: Colors.green,);});
    else if (state == 'unknown') this.setState(() {this._connectionIcon = Icon(Icons.bluetooth_searching, color: Colors.yellow[800],);});
    else {
      this.setState(() {
        this._connectionIcon = Icon(Icons.bluetooth_disabled, color: Colors.red,);
        this._batteryIcon = Icon(Icons.battery_unknown, color: Colors.yellow[800],);
      });
    }
  }

  _setBatteryIcon(double voltage) {
    print('Battery Voltage: ' + voltage.toString());
    if (voltage > 3.98) this.setState(() {this._batteryIcon = Icon(Icons.battery_full, color: Colors.green,);});
    else if (voltage > 3.8) this.setState(() {this._batteryIcon = Icon(Icons.battery_full, color: Colors.yellow[800],);});
    else this.setState(() {this._batteryIcon = Icon(Icons.battery_alert, color: Colors.red);});
  }



  String _buttonState = 'unknown';
  double _battery = -1;

  bool sampling = false;

  StreamSubscription _batteryAndButtonSub;
  StreamSubscription _gyroSub;
  bool gyroRunning;


  String _event = '';

  String acc_x = '-';
  String acc_y = '-';
  String acc_z = '-';

  String gyro_x = '-';
  String gyro_y = '-';
  String gyro_z = '-';

  String timestamp = '-';
  String packageIndex = '-';


  void _listentoGyro() async{

      _gyroSub = controler.events().listen((event) {
        print('SENSOR event: $event');
        setState(() {
          _event = event.toString();

          acc_x = event.accel[0].toString();
          acc_y = event.accel[1].toString();
          acc_z = event.accel[2].toString();

          gyro_x = event.gyro[0].toString();
          gyro_y = event.gyro[1].toString();
          gyro_z = event.gyro[2].toString();

          timestamp = event.timestamp.toString();
          packageIndex = event.packetIndex.toString();

        });
      });
      setState(() {
        gyroRunning = true;
        sampling = true;
      });

  }

  void _listenToESenseEvents() async {
    _batteryAndButtonSub = ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

        switch (event.runtimeType) {
          case BatteryRead:
            _battery = (event as BatteryRead).voltage;
            this._setBatteryIcon(_battery);
            this._setConnectionIcon(controler.getDeviceStatus());
            break;
          case ButtonEventChanged:
            this.setState(() {_buttonState = (event as ButtonEventChanged).pressed ? 'pressed' : 'not pressed';});
            
            break;
        }
    });
  }

  void pauseGyro() async{
    _gyroSub.cancel();
    setState(() {
      gyroRunning = false;
      sampling = false;
    });
  }


  void dispose() {
    if (this._gyroSub != null) this._gyroSub.cancel();
    if (this._batteryAndButtonSub != null) this._batteryAndButtonSub.cancel();
    t.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return  Card (
            elevation: 3.0,
            margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),

            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(),
                  height: 30,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'eSense',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                      ), 
                      Row(
                        children: <Widget>[
                          this._connectionIcon,
                          Container(width: 10),
                          this._batteryIcon,
                        ],
                      ),

                      
                    ],
                      
                  ),
                ),
                Divider(color: Colors.black,),
    
    
    
    
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('ButtonState: ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),  
                          ),
                          Text("'" + _buttonState + "'",
                            style: TextStyle(fontSize: 18, textBaseline: TextBaseline.alphabetic),  
                          )
                        ],
                      ),
                    ),

                    Divider(color: Colors.black, indent: 20, endIndent: 20,),



                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      height: 145,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Gyro: ',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),  
                              ),

                                Row(
                                  children: <Widget>[
                                    Text(gyro_x,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(width: 20,),
                                    Text(gyro_y,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(width: 20,),
                                    Text(gyro_z,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                  
                                ),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Accl: ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                                ),

                                Row(
                                  children: <Widget>[
                                    Text(acc_x,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(width: 20,),
                                    Text(acc_y,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(width: 20,),
                                    Text(acc_y,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                  
                                ),
                              ],
                            ),
                            
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Timestamp: ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                                ),

                                Text(timestamp,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('PackageIndex: ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic),
                                ),

                                Text(packageIndex,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                        ],
                      )
                    ),


                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                      child: connected == true ? 
                                  ((_gyroSub == null || !gyroRunning) ? 
                                      MaterialButton(
                                        child: Text("Start GyroListener"),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        color: Colors.black,
                                        elevation: 3,
                                        textTheme: ButtonTextTheme.primary,
                                        onPressed: () {this._listentoGyro();}
                                      ) :
                                      MaterialButton(
                                        child: Text("Pause GyroListener"),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        color: Colors.black,
                                        elevation: 3,
                                        textTheme: ButtonTextTheme.primary,
                                        onPressed: () {this.pauseGyro();}
                                      )
                                  ):

                            MaterialButton(
                              child: Text("Reconnect eSense"),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              color: Colors.black,
                              elevation: 3,
                              textTheme: ButtonTextTheme.primary,
                              onPressed: () {this.updateESenseControler();}
                            )
                    )
                  ],
                ),

              ],
            )
    );
  }
}