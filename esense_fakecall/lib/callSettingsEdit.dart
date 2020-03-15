import 'package:eSenseFC/inCall.dart';
import 'package:eSenseFC/profileImage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'storage.dart';


class CallSettingsEditView extends StatelessWidget{

  StorageHandler sh = new StorageHandler();
  int settingIndex;
  List<String> setting;
  AudioPathField audioPathField;
  ImageField imageField;


  CallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex;
  }


  Future<bool> _saveSetting() {
    sh.setAudioPath(setting, audioPathField.path);
    sh.setImageLocation(setting, imageField.path);
    return sh.storeSetting(setting, settingIndex);
  }

  _exit (BuildContext context) {
    Navigator.pop(context);
    if (Navigator.canPop(context)) {Navigator.pop(context);}
  }



  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: sh.getSetting(settingIndex),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done) {
                return Center(child: Text('Loading.....'));
              }
              if(snapshot.hasError) {
                return Center(child: Text('Error!!!!!'));
              }
            this.setting = snapshot.data ?? [];
            this.audioPathField = AudioPathField(sh.getAudioLocation(setting));
            this.imageField = ImageField(sh.getPicLocation(setting), sh.getCallerName(setting));
            print('EditView Setting: ' + setting.toString());

            return Scaffold(
              appBar: AppBar(
                title: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                      decoration: InputDecoration(
                          
                          hintText: sh.getSettingName(setting),
                          suffixIcon: Icon(Icons.edit)
                      ),
                      onSubmitted: (String value) {
                        sh.setSettingName(setting, value);
                      },
                ),
                actions: <Widget>[
                  MaterialButton(
                    child: Text("Save"),
                    shape: StadiumBorder(),
                    textTheme: ButtonTextTheme.primary,
                    onPressed: (){
                      _saveSetting().then((value) => {_exit(context)});
                    },
                )
              ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),



              body: ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.5, 0.9],
                        colors: [
                          Colors.transparent,
                          Colors.transparent
                        ]
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        imageField,
                      ],
                    ),
                  ),


                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: .0),
                    child:
                      ListTile(
                        leading: Container(
                          width: 40, // can be whatever value you want
                          alignment: Alignment.center,
                          child: Icon(Icons.person, size: 27,),
                        ),
                        title: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                            decoration: InputDecoration(
                                hintText: sh.getCallerName(setting),
                            ),
                            onSubmitted: (String value) async {
                              sh.setCallerName(setting, value);
                              imageField.updateCallerName(value);
                            },
                        )
                      ),
                  ),
        
                  audioPathField,
                  
                ],
              ),



              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    sh.setAudioPath(setting, audioPathField.path);
                    print('Path: ' + audioPathField.path);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InCallView(this.setting),
                        )
                      );
                  },
              ),
            );
      } 
      );
  }
}


class ImageField extends StatefulWidget {

  String path;
  String callerName;

  ImageFieldState state;

  ImageField(String path, String callerName) {
    this.path = path;
    this.callerName = callerName;
  }

  updateCallerName(String callerName) {
    state._updateCallerName(callerName);
  }

  @override
  State<ImageField> createState() => state = ImageFieldState(this, this.path, this.callerName);
  
} 

class ImageFieldState extends State<ImageField> {

  ImageField field;
  String path;
  String callerName;

  ImageFieldState(ImageField imageField, String path, String callerName) {
    this.field = imageField;
    this.path = path;
    this.callerName = callerName;
  }

  _updateCallerName(String callerName) {
    this.setState(() {
        this.callerName = callerName;
    });
    field.callerName = callerName;
  }


  _saveImagePath(String path) {
    this.setState(() {
        this.path = path;
    });
    field.path = path;
  }

  _setImage() {
    Future<String> path = FilePicker.getFilePath(type: FileType.IMAGE);
       path.then((value) => _saveImagePath(value));
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: new Stack(fit: StackFit.loose, children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileImage(this.path, this.callerName, 1)
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 110.0, left: 120.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 25.0,
                    child: new IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: Colors.white,
                      onPressed: () {_setImage();},
                    ),
                  )
                ],
              )),
        ]),
      );
  }
}






class AudioPathField extends StatefulWidget{

  String path;

  AudioPathField(String path) {
    this.path = path;
  }

  @override
  AudioPathFieldState createState() => AudioPathFieldState(path, this);
  
}

class AudioPathFieldState extends State<AudioPathField> {

  String path;
  AudioPathField field;

  AudioPathFieldState (String path, AudioPathField field) {
      this.path = path;
      this.field = field;
  }

  _saveAudioFilePath(String path) {
    this.setState(() {
        this.path = path;
    });
    field.path = path;
  }

  _setAudioFile() {
    Future<String> path = FilePicker.getFilePath(type: FileType.AUDIO);
       path.then((value) => _saveAudioFilePath(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: new EdgeInsets.symmetric(horizontal: .0),
        child:
          ListTile(
            leading: Container(
              width: 40, // can be whatever value you want
              alignment: Alignment.center,
              child: Icon(Icons.play_circle_filled, size: 27,),
            ),
            title: Text('Audio File', style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text(path, style: TextStyle(fontSize: 19.0),),
            onTap: () {_setAudioFile();},
          ),
      );
  }
}