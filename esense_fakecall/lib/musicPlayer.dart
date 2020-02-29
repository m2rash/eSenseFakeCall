import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';


class InCallView extends StatelessWidget {
  
  String path = "/data/user/0/com.example.esense_fakecall/cache/Doctor Who Theme 5.mp3";
  final player = AudioPlayer();

 


  Future<void> playFakeMessage(String path) async {
    
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