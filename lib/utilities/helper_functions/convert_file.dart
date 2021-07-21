import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utilities/helper_functions/get_file_size.dart';
import 'package:flutter_app_test/utilities/helper_functions/snackbar_shower.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

convertFile(
    {GlobalKey<ScaffoldState> scaffoldKey,
    String filePath,
    String directoryPath,
    String baseName}) async {
  print('started');

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  bool doesExists = await File("$directoryPath/$baseName.mp3").exists();

  if (doesExists) {
    print(await getFileSize("$directoryPath/$baseName.mp3", 1));
    await File("$directoryPath/$baseName.mp3").delete();
  }

  print(filePath);

  int status = await _flutterFFmpeg
      .execute("-i $filePath -b:a 64k $directoryPath/$baseName.mp3");
  print(status);
  print('completed');
  print(await getFileSize("$directoryPath/$baseName.mp3", 1));

  if (status == 0) {
    showSnacbar(
      scaffoldKey: scaffoldKey,
      message: 'File saved to: $directoryPath/$baseName.mp3',
    );
  } else {
    showSnacbar(
      scaffoldKey: scaffoldKey,
      message: 'Some error occured.',
    );
  }
}
