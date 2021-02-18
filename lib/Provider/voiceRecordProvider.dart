import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class VoiceRecordProvider with ChangeNotifier {
  bool ifTap;
  FlutterSoundRecorder _recorder;

  VoiceRecordProvider() {
    _recorder = FlutterSoundRecorder();
    ifTap = false;
  }
}
