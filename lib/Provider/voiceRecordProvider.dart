import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:uuid/uuid.dart';

class VoiceRecordProvider with ChangeNotifier {
  bool ifTap;
  FlutterSoundPlayer _mPlayer;
  FlutterSoundRecorder _mRecorder;
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String fileName;
  @override
  void dispose() {
    _mRecorder.stopRecorder();
    if (_mRecorder != null) {
      _mRecorder.closeAudioSession();
      _mRecorder = null;
    }
    super.dispose();
  }

  VoiceRecordProvider() {
    _mRecorder = FlutterSoundRecorder();
    _mRecorder.openAudioSession();
    ifTap = false;
  }

  beginRecord() async {
    ifTap = true;
    fileName = Uuid().v4().toString();
    // String fileType = '';
    // if (Platform.isIOS) {
    //   fileType = '.m4a';
    // } else {
    //   fileType = '.mp4';
    // }
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;

    // filePath = p.join(appDocPath, fileName + fileType);
    _mRecorder.startRecorder(
      toFile: fileName,
    );
    notifyListeners();
  }

  stopRecord() async {
    ifTap = false;
    String anURL = await _mRecorder.stopRecorder();
    notifyListeners();
  }

  cancelRecord() async {
    ifTap = false;
    String anURL = await _mRecorder.stopRecorder();
    if (File(anURL).existsSync()) {
      File(anURL).delete();
    }
    notifyListeners();
  }
}
