import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  void turnOn() async {
    await Firestore.instance
        .collection('devices')
        .document('ventilador')
        .setData({ 'on': true, "updated": (new DateTime.now())}).then((_) {
      print('Transaction  committed.');
    });
  }

    void turnOff() async {
    await Firestore.instance
        .collection('devices')
        .document('ventilador')
        .setData({ 'on': false, "updated": (new DateTime.now())}).then((_) {
      print('Transaction  committed.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Turn on device'),
              onPressed: () {
                turnOn();
              },
            ),
            RaisedButton(
              child: Text('Turn off device'),
              onPressed: () {
                turnOff();
              },
            ),
          ],
        ),
      ),
    );
  }
}
