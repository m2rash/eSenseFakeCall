
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter_appavailability/flutter_appavailability.dart';

// class MyApp1 extends StatefulWidget {
//   @override
//   _MyAppState1 createState() => new _MyAppState1();
// }

// class _MyAppState1 extends State<MyApp1> {

//   List<Map<String, String>> installedApps;
//   List<Map<String, String>> iOSApps = [
//     {
//       "app_name": "Calendar",
//       "package_name": "calshow://"
//     },
//     {
//       "app_name": "Facebook",
//       "package_name": "fb://"
//     },
//          {
//       "app_name": "Whatsapp",
//       "package_name": "whatsapp://"
//     }
//   ];


//   @override
//   void initState() {
//     super.initState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> getApps() async {
//     List<Map<String, String>> _installedApps;

//     if (Platform.isAndroid) {

//       _installedApps = await AppAvailability.getInstalledApps();

//       print(await AppAvailability.checkAvailability("com.android.chrome"));
//       // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

//       print(await AppAvailability.isAppEnabled("com.android.chrome"));
//       // Returns: true

//     }
//     else if (Platform.isIOS) {
//       // iOS doesn't allow to get installed apps.
//       _installedApps = iOSApps;

//       print(await AppAvailability.checkAvailability("calshow://"));
//       // Returns: Map<String, String>{app_name: , package_name: calshow://, versionCode: , version_name: }

//     }

//     setState(() {
//       installedApps = _installedApps;
//     });

//   }

//   @override
//   Widget build(BuildContext context) {
//     if (installedApps == null)
//       getApps();

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin flutter_appavailability app'),
//         ),
//         body: ListView.builder(
//           itemCount: installedApps == null ? 0 : installedApps.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(installedApps[index]["app_name"]),
//               trailing: IconButton(
//                 icon: const Icon(Icons.open_in_new),
//                 onPressed: () {
//                   Scaffold.of(context).hideCurrentSnackBar();
//                   AppAvailability.launchApp(installedApps[index]["package_name"]).then((_) {
//                     print(installedApps[index]["package_name"]);
//                   }).catchError((err) {
//                     Scaffold.of(context).showSnackBar(SnackBar(
//                         content: Text("App ${installedApps[index]["app_name"]} not found!")
//                     ));
//                     print(err);
//                   });
//                 }
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ListAppsPages()));

class ListAppsPages extends StatefulWidget {
  @override
  _ListAppsPagesState createState() => _ListAppsPagesState();
}

class _ListAppsPagesState extends State<ListAppsPages> {
  bool _showSystemApps = false;
  bool _onlyLaunchableApps = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installed applications"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: 'system_apps', child: Text('Toggle system apps')),
                PopupMenuItem<String>(
                  value: "launchable_apps",
                  child: Text('Toggle launchable apps only'),
                )
              ];
            },
            onSelected: (key) {
              if (key == "system_apps") {
                setState(() {
                  _showSystemApps = !_showSystemApps;
                });
              }
              if (key == "launchable_apps") {
                setState(() {
                  _onlyLaunchableApps = !_onlyLaunchableApps;
                });
              }
            },
          )
        ],
      ),
      body: _ListAppsPagesContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _ListAppsPagesContent extends StatelessWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _ListAppsPagesContent(
      {Key key,
      this.includeSystemApps: false,
      this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: includeSystemApps,
            onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            print(apps);
            return ListView.builder(
                itemBuilder: (context, position) {
                  Application app = apps[position];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: app is ApplicationWithIcon
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(app.icon),
                                backgroundColor: Colors.white,
                              )
                            : null,
                        onTap: () => DeviceApps.openApp(app.packageName),
                        title: Text("${app.appName} (${app.packageName})"),
                        subtitle: Text('Version: ${app.versionName}\nSystem app: ${app.systemApp}\nAPK file path: ${app.apkFilePath}\nData dir : ${app.dataDir}\nInstalled: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMilis).toString()}\nUpdated: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMilis).toString()}'),
                      ),
                      Divider(
                        height: 1.0,
                      )
                    ],
                  );
                },
                itemCount: apps.length);
          }
        });
  }
}