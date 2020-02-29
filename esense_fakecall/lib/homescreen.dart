
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewState();
 
}



  class _HomeViewState extends State<HomeView> {
final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  final List<Map> callList = [
    {
      "name": "Hamster tot",
      "location": "path",
    },
    {
      "name": "Schwester tot",
      "location": "path",
    },
    {
      "name": "DU tot",
      "location": "path",
    },
    {
      "name": "Notfall",
      "location": "path",
    },
    {
      "name": "Haus brennt",
      "location": "path",
    },
    {
      "name": "Random",
      "location": "path",
    },
    {
      "name": "Unfall",
      "location": "path",
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


        /*body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 6.0,
                    margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.purple,
                          ),
                          title: Text("Change Password"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change password
                          },
                          
                        ),
                        SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: false,
                        title: Text("Received notification"),
                        onChanged: (val) {},
                      ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),*/
      );
    
    /*return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child:  Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: callList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
            ],
        ),
      ),
    );*/
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