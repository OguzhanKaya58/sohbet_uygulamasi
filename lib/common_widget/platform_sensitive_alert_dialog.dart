import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sohbet_uygulamasi/common_widget/platform_sensitive_widget.dart';

class PlatformSensitiveAlertDialog extends PlatformSensitiveWidget {
  final String head;
  final String content;
  final String mainButtonName;
  final String cancelButtonName;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          );
  }

  PlatformSensitiveAlertDialog({
    @required this.head,
    @required this.content,
    @required this.mainButtonName,
    this.cancelButtonName,
  });

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(head),
      content: Text(content),
      actions: _dialogButtonSetting(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(head),
      content: Text(content),
      actions: _dialogButtonSetting(context),
    );
  }

  List<Widget> _dialogButtonSetting(BuildContext context) {
    final allButton = <Widget>[];
    if (Platform.isIOS) {
      if (cancelButtonName != null) {
        allButton.add(
          CupertinoDialogAction(
            child: Text(cancelButtonName),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
      allButton.add(
        CupertinoDialogAction(
          child: Text(mainButtonName),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonName != null) {
        allButton.add(
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonName),
          ),
        );
      }
      allButton.add(
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(mainButtonName),
        ),
      );
    }
    return allButton;
  }
}
