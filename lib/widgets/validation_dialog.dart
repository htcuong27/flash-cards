import 'package:flutter/material.dart';

void showValidationDialog({
  required BuildContext context,
  required String message,
  bool isSuccess = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Column(
          children: [
            isSuccess ? Icon(Icons.check_circle, color: Colors.green, size: 50) : Icon(Icons.highlight_off, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('Validation Error', textAlign: TextAlign.center),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: isSuccess ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
