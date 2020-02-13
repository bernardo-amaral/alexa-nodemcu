import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodemcucontroller/components/textfield_alertDialog.dart';
import 'package:nodemcucontroller/models/JsonDevices.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NodeMCU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Automation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  Future<bool> renameDevice(BuildContext context, String deviceId) {
    return displayDialog(context, deviceId);
  }

  void turnOn(String deviceId) async {
    await Firestore.instance
        .collection('devices')
        .document(deviceId)
        .setData({'on': true, "updated": (new DateTime.now())}).then((_) {
      print('Device ${deviceId} turned on..');
    });
  }

  void turnOff(String deviceId) async {
    await Firestore.instance
        .collection('devices')
        .document(deviceId)
        .setData({'on': false, "updated": (new DateTime.now())}).then((_) {
      print('Device ${deviceId} turned off..');
    });
  }

  Widget devicesList() {
    return FutureBuilder<List>(
      future: fetchAllDevices(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || isLoading)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((device) {
                return deviceRow(device);
              })
              .where((w) => w != null)
              .toList(),
        );
      },
    );
  }

  Widget deviceRow(device) {
    if (device['on'] == null) {
      device['on'] = false;
    }
    return Card(
        color: Colors.white,
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              device['id'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.power,
                color: device['on'] ? Colors.green : Colors.red, size: 30.0),
            onLongPress: () async {
              if (await renameDevice(context, device['id'])) {
                setState(() {
                  return null;
                });
              }
            },
            onTap: () {
              setState(() {
                if (device['on']) {
                  turnOff(device['id']);
                } else {
                  turnOn(device['id']);
                }
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    return null;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: devicesList(),
          )
        ],
      ),
    );
  }
}
