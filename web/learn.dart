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

  DivElement containerDiv;
  ImageElement image;
  int _width = 667;
  int _height = 527;

  UpDroidLearn() :
  super(UpDroidLearn.names, getMenuConfig(), 'tabs/upcom-learn-demo/learn.css') {

  }

  void setUpController() {
    // Dummy div so that teleop fits with the onFocus API from tab controller.
    containerDiv = new DivElement()
      ..classes.add('upcom-learn-container');
    view.content.children.add(containerDiv);

    view.content.contentEdge.height = new Dimension.percent(100);

    // TODO: compress this svg (use that OS X tool).
    image = new ImageElement(src:'tabs/$refName/updroid-onearm.png')
      ..style.position = 'absolute'
      ..style.top = '50%'
      ..style.right = '0'
      ..style.transform = 'translateY(-50%)';
    containerDiv.children.add(image);
  }

  void registerMailbox() {

  }

  void registerEventHandlers() {
    window.onResize.listen((e) => _setDimensions());
  }

  void _setDimensions() {
    var width = (view.content.contentEdge.width - 13);

    if (width <= _width) {
      image.width = width;
    } else {
      image.width = _width;
    }
    image.height = (image.width * _height / _width).toInt();
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