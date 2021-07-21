import 'package:flutter/material.dart';
import 'package:flutter_app_test/utilities/helper_functions/convert_file.dart';
import 'package:flutter_app_test/utilities/helper_functions/file_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String filePath = '';
  String directoryPath = '';
  String baseName = '';

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
                  final result = await pickFile();
                  setState(() {
                    filePath = result["filePath"];
                    baseName = result["baseName"];
                    directoryPath = result["directoryPath"];
                  });
                },
                child: Text('Select audio'),
              ),
              FlatButton(
                color: Colors.blueAccent,
                onPressed: () => convertFile(
                    scaffoldKey: _scaffoldKey,
                    filePath: filePath,
                    directoryPath: directoryPath,
                    baseName: baseName),
                child: Text('Convert'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
