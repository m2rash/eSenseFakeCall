
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewState();
 
}



  class _HomeViewState extends State<HomeView> {
      final TextStyle dropdownMenuItem = TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  final List<Map> callList = [
    {
      "name": "Hamster tot",
      "audioLocation": "path",
      "callerNameLocation": "callerName",
      "picLocation": "pic",
    },
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: Card (
          elevation: 6.0,
          margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),

          child: ListTile(
              leading: Icon(Icons.https),
              title: Text('Test', 
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21),),
              subtitle: Text("Subtitle"),
              trailing: Icon(Icons.more_vert),
            ),
        ),
      );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 85,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(



        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              /*image: DecorationImage(
                  image: CachedNetworkImageProvider(schoolLists[index]['logoText']),
                  fit: BoxFit.fill),*/
            ),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  callList[index]['name'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}