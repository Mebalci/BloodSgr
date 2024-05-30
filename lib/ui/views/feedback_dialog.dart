import 'package:flutter/material.dart';

class FeedbackDialog extends StatelessWidget {
  final String message;

  const FeedbackDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Geribildirim"),
      content: Text(message),
      backgroundColor: Color(0xff43dddc),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialog ekranını kapat
          },
          child: Text("Tamam",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}
