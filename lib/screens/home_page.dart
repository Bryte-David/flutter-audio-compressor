import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_test/utilities/helper_functions/get_file_size.dart';
import 'package:flutter_app_test/utilities/helper_functions/snackbar_shower.dart';
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

  pickFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
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
                onPressed: pickFile,
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
                      showSnacbar(
                        scaffoldKey: _scaffoldKey,
                        message: 'File saved to: $directoryPath/$baseName.mp3',
                      );
                      // _scaffoldKey.currentState.showSnackBar(SnackBar(
                      //     content: Text(
                      //         'File saved to: $directoryPath/$baseName.mp3')));
                    } else {
                      showSnacbar(
                        scaffoldKey: _scaffoldKey,
                        message: 'Some error occured.',
                      );
                      // _scaffoldKey.currentState.showSnackBar(
                      //     SnackBar(content: Text('Some error occured.')));
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
