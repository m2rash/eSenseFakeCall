import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';


class InCallView extends StatelessWidget {

  String path;
  final player = AudioPlayer();


  InCallView(String path) {
    this.path = path;
  }
  

 


  Future<void> playFakeMessage(String path) async {
    print(path);
    
    var duration = await player.setUrl(path);

    player.play();
  }

  void stopCall() {
    player.stop();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    playFakeMessage(path);
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: (){
                        stopCall(); 
                        Navigator.pop(context);
                      },
      ),
    );
  }
  
}