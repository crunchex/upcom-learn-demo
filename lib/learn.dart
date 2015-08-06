library cmdr_learn;

import 'dart:async';
import 'dart:isolate';

import 'package:upcom-api/tab_backend.dart';

class CmdrLearn extends Tab {
  static final List<String> names = ['upcom-learn-demo', 'UpDroid Learn', 'Learn'];

  String _codeWaitingForEditor;

  CmdrLearn(SendPort sp, List args) :
  super(CmdrLearn.names, sp, args) {

  }

  void registerMailbox() {
    mailbox.registerMessageHandler('REQUEST_TAB', _requestTab);
    mailbox.registerMessageHandler('REQUEST_FULFILLED', _requestFulfilled);
  }

  void _requestTab(String m) {
    int indexOfSeparator = m.indexOf(':');
    String tabToRequest = m.substring(0, indexOfSeparator);
    _codeWaitingForEditor = m.substring(indexOfSeparator + 1, m.length);
    mailbox.relay(Tab.upcomName, -1, new Msg('REQUEST_TAB', '${names[0]}:$id:$tabToRequest'));
  }

  void _requestFulfilled(String requestedTabId) {
    List<String> split = requestedTabId.split(':');

    // TODO: replace this timer with logic to implement the relay with callbacks.
    // Basically, we must find out when the Editor is done loading.
    new Timer(new Duration(milliseconds: 1000), () {
      mailbox.relay(split[0], int.parse(split[1]), new Msg('OPEN_TEXT', _codeWaitingForEditor));
    });
  }

  void cleanup() {

  }
}