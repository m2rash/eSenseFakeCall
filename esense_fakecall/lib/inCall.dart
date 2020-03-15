import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:eSenseFC/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';

import 'profileImage.dart';


class InCallView extends StatelessWidget {

  String callerName;
  String imagePath;
  String audioPath;
  final player = AudioPlayer();


  InCallView(List<String> setting) {
    StorageHandler sh = new StorageHandler();

    this.callerName = sh.getCallerName(setting);
    this.imagePath = sh.getPicLocation(setting);
    this.audioPath = sh.getAudioLocation(setting);
  }
  

 


  Future<void> playFakeMessage(String path) async {
    print('!!!!!!!!!!!!!!!!!!!!!!!' + path);
    
    var duration = await player.setUrl(path);

    player.play();
  }

  void stopCall() {
    player.stop();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
        
      ]);
  }

  @override
  Widget build(BuildContext context) {
    playFakeMessage(audioPath);
    return Scaffold(
//TODO Incall Look
        backgroundColor: Colors.grey[800],
      
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              _buildCallerInfo(),
              _buildAdditionalButtons(),
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

              CallTimeCounter(),
              // Text(
              //   '0:45', 
              //   style: TextStyle(color: Colors.white, fontSize: 15,),
              // ),

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





  Widget _buildAdditionalButtons() {
      return 
      Padding(
        padding: EdgeInsets.only(left: 50.0, right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 30),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  child: Icon(Icons.volume_up, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                MaterialButton(
                  child: Icon(Icons.mic, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                MaterialButton(
                  child: Icon(Icons.add_call, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                
              ],
            ),
            
            SizedBox(height: 20),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  child: Icon(Icons.dialpad, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                MaterialButton(
                  child: Icon(Icons.pause, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                MaterialButton(
                  child: Icon(Icons.person, color: Colors.white, size: 32,),
                  shape: CircleBorder(),
                  minWidth: 50,
                  onPressed: (){},
                ),
                
              ],
            ),

          ],
        ),
      );
      
  }



  Widget _buildCallButtons(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Center(
          child: MaterialButton(
              height: 65,
              child: Icon(Icons.call_end, color: Colors.white, size: 30,),
              color: Colors.red,
              shape: CircleBorder(),
              onPressed: (){
                stopCall(); 
                Navigator.pop(context);
                if (Navigator.canPop(context)) {Navigator.pop(context);}
              },
            ),
        )
      );
  }



}

class CallTimeCounter extends StatefulWidget {
  @override
  State<CallTimeCounter> createState() => CallTimeCounterState();

}

class CallTimeCounterState extends State<CallTimeCounter> {

  int min = 42;
  int sec = 42;
  // static CallTimeCounterState callTimer;

  // CallTimeCounterState() {
  //   min = 0;
  //   sec = 0;
  //   callTimer = this;
  // }

  // static _incrementCounter() {
  //   if (sec < 60) {
  //     sec++;
  //   } else {
  //     min++;
  //     sec = 0;
  //   }
  //   callTimer.setState(() {});
  // }

  // Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {_incrementCounter();});

  @override
  Widget build(BuildContext context) {
    
    return Text(
      min.toString() + ':' + sec.toString(),
      style: TextStyle(color: Colors.white, fontSize: 15,),
    );
  }
  
}

//TODO IncomingCallView