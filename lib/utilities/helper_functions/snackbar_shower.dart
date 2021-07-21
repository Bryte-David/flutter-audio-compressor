import 'package:flutter/material.dart';

showSnacbar({GlobalKey<ScaffoldState> scaffoldKey, String message}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}
