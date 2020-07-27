import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar myFlushBar(BuildContext context,String text) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    message:
    text,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.white,
    ),
    duration: Duration(seconds: 3),
  )..show(context);
}