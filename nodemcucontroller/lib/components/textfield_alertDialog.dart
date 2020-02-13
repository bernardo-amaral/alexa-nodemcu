import 'package:flutter/material.dart';
import 'package:nodemcucontroller/models/JsonDevices.dart';

Future<bool> displayDialog(BuildContext context, String deviceId) async {
  TextEditingController _textFieldController = TextEditingController();

  return await showDialog<bool>(
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
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    renameDevice(deviceId, _textFieldController.value.text);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }) ??
      false;
}
