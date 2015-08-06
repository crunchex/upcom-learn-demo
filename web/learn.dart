library updroid_learn;

import 'dart:async';
import 'dart:html';

import 'package:upcom-api/web/tab/tab_controller.dart';

class UpDroidLearn extends TabController {
  static final List<String> names = ['upcom-learn-demo', 'UpDroid Learn', 'Learn'];

  static List getMenuConfig() {
    List menu = [
      {'title': 'File', 'items': [
        {'type': 'toggle', 'title': 'Close Tab'}]}
    ];
    return menu;
  }

  UpDroidLearn() :
  super(UpDroidLearn.names, getMenuConfig(), 'tabs/upcom-console/console.css') {

  }

  void setUpController() {

  }

  void registerMailbox() {

  }

  void registerEventHandlers() {

  }

  Element get elementToFocus => null;

  Future<bool> preClose() {
    Completer c = new Completer();
    c.complete(true);
    return c.future;
  }

  void cleanUp() {

  }
}