import 'package:flutter/material.dart';
import 'package:nodemcucontroller/models/JsonDevices.dart';

Future displayDialog(BuildContext context, String deviceId) async {
  TextEditingController _textFieldController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename device'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: deviceId),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                renameDevice(deviceId, _textFieldController.value.text);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
