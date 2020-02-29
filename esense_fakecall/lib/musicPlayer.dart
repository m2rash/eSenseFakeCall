import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';


class InCallView extends StatelessWidget {

  final player = AudioPlayer();

  Future<void> playFakeMessage() async {
    
    var duration = await player.setUrl('https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3');

    player.play();
  }

  void stopCall() {
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    playFakeMessage();
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){stopCall();},
      ),
    );
  }
  
}