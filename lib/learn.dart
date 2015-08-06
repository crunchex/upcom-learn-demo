library cmdr_learn;

import 'dart:isolate';

import 'package:upcom-api/tab_backend.dart';
import 'package:upcom-api/debug.dart';

class CmdrLearn extends Tab {
  static final List<String> names = ['upcom-learn-demo', 'UpDroid Learn', 'Learn'];

  CmdrLearn(SendPort sp, List args) :
  super(CmdrLearn.names, sp, args) {

  }

  void registerMailbox() {

  }

  void cleanup() {

  }
}