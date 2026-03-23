import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notesassignment/AppConstants/TxtStyles.dart';

class AppToastMessages {
  static successMessage({msg}) {
    return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
      textColor: whiteColor,
      gravity: ToastGravity.TOP,
    );
  }

  static failMessage({msg}) {
    return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      textColor: whiteColor,
      gravity: ToastGravity.TOP,
    );
  }

  static warningMessage({msg}) {
    return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.deepOrangeAccent,
      textColor: whiteColor,
      gravity: ToastGravity.TOP,
    );
  }

}
