import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String filePath = '';
  String directoryPath = '';
  String baseName = '';

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                baseName,
                style: TextStyle(color: Colors.black),
              ),
              FlatButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  directoryPath = appDocDir.path;

                  FilePickerResult result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', 'wav'],
                  );

                  if (result != null) {
                    File file = File(result.files.single.path);

                    setState(() {
                      filePath = file.path;
                      baseName = basename(filePath);
                    });
                  } else {
                    // User canceled the picker
                  }
                },
                child: Text('Select audio'),
              ),
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    print('started');

                    bool doesExists =
                        await File("$directoryPath/$baseName.mp3").exists();

                    if (doesExists) {
                      print(
                          await getFileSize("$directoryPath/$baseName.mp3", 1));
                      await File("$directoryPath/$baseName.mp3").delete();
                    }

                    int status = await _flutterFFmpeg.execute(
                        "-i $filePath -b:a 64k $directoryPath/$baseName.mp3");
                    print(status);
                    print('completed');
                    print(await getFileSize("$directoryPath/$baseName.mp3", 1));

                    if (status == 0) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'File saved to: $directoryPath/$baseName.mp3')));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Some error occured.')));
                    }
                  },
                  child: Text('Convert'))
            ],
          ),
        ),
      ),
    );
  }
}
