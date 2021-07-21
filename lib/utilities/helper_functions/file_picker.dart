import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

pickFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      File file = File(result.files.single.path);
      print('printing from file pickere: '+file.path);

      return {
        "filePath": file.path,
        "baseName": basename(file.path),
        "directoryPath": appDocDir.path
      };
    } else {
      // User canceled the picker
    }
  }