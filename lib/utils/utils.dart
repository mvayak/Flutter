import 'package:flutter/material.dart';

showAlert(BuildContext context, String msg, {Function? onClick}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(msg),
          actions: [
            ElevatedButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();

                if (onClick != null) {
                  onClick();
                }
              },
            )
          ],
        );
      });
}
