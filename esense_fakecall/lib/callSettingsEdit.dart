import 'package:eSenseFC/profileImage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'incomingCall.dart';
import 'storage.dart';


class CallSettingsEditView extends StatelessWidget{

  StorageHandler sh = new StorageHandler();
  int settingIndex;
  List<String> setting;
  FloatingButton floatingButton;
  AudioPathField audioPathField;
  ImageField imageField;


  CallSettingsEditView (int settingIndex) {
      this.settingIndex = settingIndex;
  }


  Future<int> _saveSetting(BuildContext context) async {
    int error = 0;

    sh.setAudioPath(setting, audioPathField.path);
    sh.setImageLocation(setting, imageField.path);

    return await sh.storeSetting(setting, settingIndex);
  }


  _exit(BuildContext context) {
    Navigator.pop(context);
    if (Navigator.canPop(context)) {Navigator.pop(context);}
  }

  //shows error message
  _showAlert(BuildContext context, int errorCode) {

    var errorMessages = ['', 
                         'SettingName is not allowed!',
                         'CallerName is not allowed!',
                         'Invlaid AuioPath'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("ERROR!!!"),
          content: new Text(errorMessages[errorCode]),
          actions: <Widget>[
            MaterialButton(
              child: Text("I understood"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: sh.getColor(setting),
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
            this.audioPathField = AudioPathField(sh.getAudioLocation(setting), sh.getColor(setting));
            this.imageField = ImageField(sh.getPicLocation(setting), sh.getCallerName(setting), sh.getColor(setting));
            this.floatingButton = FloatingButton(setting, this.audioPathField);
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
                        this.floatingButton._update(setting);
                      },
                ),
                actions: <Widget>[
                  MaterialButton(
                    child: Text("Save"),
                    shape: StadiumBorder(),
                    textTheme: ButtonTextTheme.primary,
                    onPressed: (){
                      _saveSetting(context).then((value) => {
                        value == 0 ? _exit(context) : _showAlert(context, value)
                      });
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
                                suffixIcon: Icon(Icons.edit),
                            ),
                            onSubmitted: (String value) async {
                              sh.setCallerName(setting, value);
                              imageField.updateCallerName(value, sh.getColor(setting));
                              audioPathField._updateColor(sh.getColor(setting));
                              this.floatingButton._update(setting);
                            },
                        )
                      ),
                  ),
        
                  audioPathField,
                  
                ],
              ),



              floatingActionButton: floatingButton
            );
      } 
      );
  }
}


class FloatingButton extends StatefulWidget {

  List<String> setting;
  AudioPathField audioPathField;

  FloatingButtonState fs;

  FloatingButton(this.setting, this.audioPathField);

  _update(List<String> setting) {
    fs._update(setting);
  }

  @override
  State<StatefulWidget> createState() => fs = FloatingButtonState(this.setting, this.audioPathField);
  
}

class FloatingButtonState extends State<FloatingButton> {

  List<String> setting;
  StorageHandler sh = StorageHandler();
  AudioPathField audioPathField;

  FloatingButtonState(this.setting, this.audioPathField);

  _update(List<String> setting) {
      this.setState(() {
        this.setting = setting;
      });
  }


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
                backgroundColor: sh.getColor(setting),
                  child: Icon(Icons.play_arrow),
                  onPressed: () async {
                    sh.setAudioPath(setting, audioPathField.path);
                    // print('Path: ' + audioPathField.path);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InComingCallView(this.setting),
                        )
                      );
                  },
              );
  }
  
}




class ImageField extends StatefulWidget {

  String path;
  String callerName;
  Color color;

  ImageFieldState state;

  ImageField(String path, String callerName, Color color) {
    this.path = path;
    this.callerName = callerName;
    this.color = color;
  }

  updateCallerName(String callerName, Color color) {
    state._updateCallerName(callerName, color);
  }

  @override
  State<ImageField> createState() => state = ImageFieldState(this, this.path, this.callerName, this.color);
  
} 

class ImageFieldState extends State<ImageField> {

  ImageField field;
  String path;
  String callerName;
  Color color;

  ImageFieldState(ImageField imageField, String path, String callerName, Color color) {
    this.field = imageField;
    this.path = path;
    this.callerName = callerName;
    this.color = color;
  }

  _updateCallerName(String callerName, Color color) {
    this.setState(() {
        this.callerName = callerName;
        this.color = color;
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
    Future<String> path = FilePicker.getFilePath(type: FileType.image);
       path.then((value) {
          value != null ? _saveImagePath(value) : _saveImagePath('');
       } );
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
              ProfileImage(this.path, this.callerName, this.color, 1)
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 110.0, left: 120.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 25.0,
                    child: new IconButton(
                      icon: Icon(Icons.camera_alt),
                      //color: Colors.white,
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
  Color color;
  AudioPathFieldState as;

  _updateColor(Color color) {
    as._updateColor(color);
  }

  AudioPathField(String path, Color color) {
    this.path = path;
    this.color = color;
  }

  @override
  AudioPathFieldState createState() => as = AudioPathFieldState(path, this.color, this);
  
}

class AudioPathFieldState extends State<AudioPathField> {

  String path;
  Color color;
  AudioPathField field;

  AudioPathFieldState (String path, Color color, AudioPathField field) {
      this.path = path;
      this.field = field;
      this.color = color;
  }

  _saveAudioFilePath(String path) {
    this.setState(() {
        this.path = path;
    });
    field.path = path;
  }

  _setAudioFile() {
    Future<String> path = FilePicker.getFilePath(type: FileType.audio);
      path.then((value) {
        value != null ? _saveAudioFilePath(value) : {};     
      });
  }

  _updateColor(Color color) {
      this.setState(() {this.color = color;});
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
            // TODO Farbe anpassen(dynamisch)
            title: Text('Audio File', style: TextStyle(color: this.color, fontSize: 14.0, fontWeight: FontWeight.bold),),
            subtitle: Text(path, style: TextStyle(fontSize: 19.0),),
            trailing: Icon(Icons.edit),
            onTap: () {_setAudioFile();},
          ),
      );
  }
}