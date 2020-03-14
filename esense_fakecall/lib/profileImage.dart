import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {

  String path;
  String callerName;
  double fontsize;

  ///path: path to image
  ///callerName: Name of the caller (for default without image)
  ///size: needed for fontsize (0 is small, 1 big)
  ProfileImage(String path, String callerName, int size) {
    this.path = path;
    this.callerName = callerName;
    switch (size) {
      case 0:
        this.fontsize = 17;
        break;
      case 1:
        this.fontsize = 50;
        break;
      default:
        this.fontsize = 10;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
          child: FutureBuilder(
              future: File(this.path).exists(),
              builder: (context, snapshot) {
                if(snapshot.connectionState != ConnectionState.done) {
                  return loadNoImage();
                }
                if(snapshot.hasError) {
                  return loadNoImage();
                }
                bool isImageValid = snapshot.data;

                if (isImageValid) {
                  return loadImage();
                } else {
                  return loadNoImage();
                }
              }
          ),
    );        
  }



  CircleAvatar loadImage() {
      return CircleAvatar(
        backgroundImage: FileImage(File(this.path)),
        radius: 80,
      );
  }


  CircleAvatar loadNoImage() {

    var possibleColors = [Colors.blue, Colors.brown, Colors.green, Colors.red, Colors.purple, Colors.orange, Colors.orange];

      return CircleAvatar(
        backgroundColor: possibleColors[new Random(callerName.hashCode).nextInt(possibleColors.length)],
        child: Text(callerName.substring(0, min(2, callerName.length)), 
                style: TextStyle(
                  fontSize: this.fontsize,
                  fontWeight: FontWeight.bold,
                ),
        ),
        radius: 80,
      );
  }  
}