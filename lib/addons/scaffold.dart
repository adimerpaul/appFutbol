import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

void success(context,description) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(description),
       backgroundColor: Colors.green,
     ),
   );
}
 void error(context,description) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(description),
       backgroundColor: Colors.red,
     ),
   );
}