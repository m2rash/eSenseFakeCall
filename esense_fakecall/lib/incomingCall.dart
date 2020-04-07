import 'dart:async';
import 'dart:ui';

import 'package:eSenseFC/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';

import 'inCall.dart';
import 'profileImage.dart';


class InComingCallView extends StatelessWidget {

  List<String> setting;
  String callerName;
  String imagePath;
  Future<String> audioPath;
  final player = AudioPlayer();


  InComingCallView(List<String> setting) {
    StorageHandler sh = new StorageHandler();

    this.setting = setting;
    this.callerName = sh.getCallerName(setting);
    this.imagePath = sh.getPicLocation(setting);
    this.audioPath = sh.getRingTone();
  }
  

 


  Future<void> playFakeMessage(String path) async {    
    var duration = await player.setUrl(path);

    player.play();
  }

  void stopRing() {
    player.stop();
  }

  void stopCall() {
    player.stop();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    this.audioPath.then((value) => playFakeMessage(value));
    return Scaffold(
        backgroundColor: Colors.grey[800],
      
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              _buildCallerInfo(),
              // _buildAdditionalButtons(),
              _buildCallButtons(context),
            ]
          ),
    );
  }
  

  Widget _buildCallerInfo() {
    print('image: ' + this.imagePath);
      return Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: new Stack(fit: StackFit.loose, children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileImage(this.imagePath, this.callerName, 1),
              SizedBox(height: 15),

              Text(
                'incoming Call...',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
              ),


              SizedBox(height: 10),
              Text(
                callerName, 
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ]),
      );
  }





  Widget _buildCallButtons(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            MaterialButton(
              height: 65,
              child: Icon(Icons.call, color: Colors.white, size: 30,),
              color: Colors.green,
              shape: CircleBorder(),
              onPressed: (){
                stopRing();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InCallView(this.setting)),
                );
              },
              
            ),
            MaterialButton(
              height: 65,
              child: Icon(Icons.call_end, color: Colors.white, size: 30,),
              color: Colors.red,
              shape: CircleBorder(),
              onPressed: (){
                stopCall(); 
                // Navigator.pop(context);
                // for TestCalls
                if (Navigator.canPop(context)) {Navigator.pop(context);} 
                // for real FakeCalls
                //else {player.stop().then((val) {SystemChannels.platform.invokeMethod('SystemNavigator.pop');});}
              },
            ),
          ],
        ),
      );
  }
}
