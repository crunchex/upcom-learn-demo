library updroid_learn;

import 'dart:async';
import 'dart:html';

import 'package:upcom-api/web/tab/tab_controller.dart';
import 'package:upcom-api/tab_frontend.dart';

part 'templates.dart';

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
  ButtonElement manipulationButton, navigationButton, joypadButton;
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
      ..classes.add('updroid-onearm-img');
    containerDiv.children.add(image);

    HeadingElement title = new HeadingElement.h1()
      ..classes.add('upcom-learn-title')
      ..text = 'Lesson 1: Pick and Place';
    containerDiv.children.add(title);

    const String lessonText = 'Commanding a robot to pick up an object requires (3) separate actions involving manipulation, navigation, and teleoperation. You can choose from one of these three to work on with the buttons below.';
    ParagraphElement lessonTextParagraph = new ParagraphElement()
      ..classes.add('upcom-learn-lesson-text')
      ..text = lessonText;
    containerDiv.children.add(lessonTextParagraph);

    DivElement buttonGroup = new DivElement()
      ..classes.add('upcom-learn-button-group');
    containerDiv.children.add(buttonGroup);

    manipulationButton = new ButtonElement()
      ..classes.addAll(['btn-primary', 'upcom-learn-manipulation-button'])
      ..text = 'manipulation';

    navigationButton = new ButtonElement()
      ..classes.addAll(['btn-primary', 'upcom-learn-navigation-button'])
      ..text = 'navigation';

    joypadButton = new ButtonElement()
      ..classes.addAll(['btn-primary', 'upcom-learn-joypad-button'])
      ..text = 'joypad';

    buttonGroup.children.addAll([manipulationButton, navigationButton, joypadButton]);
  }

  void registerMailbox() {

  }

  void registerEventHandlers() {
    window.onResize.listen((e) => _setDimensions());

    manipulationButton.onClick.listen((e) => _requestOpenEditor(UpDroidLearnCode.manipulation));
    navigationButton.onClick.listen((e) => _requestOpenEditor(UpDroidLearnCode.navigation));
    joypadButton.onClick.listen((e) => _requestOpenEditor(UpDroidLearnCode.joypad));
  }

  void _requestOpenEditor(String code) {
    Msg m = new Msg('REQUEST_TAB', 'upcom-editor:$code');
    mailbox.ws.send(m.toString());
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

  Element get elementToFocus => containerDiv;

  Future<bool> preClose() {
    Completer c = new Completer();
    c.complete(true);
    return c.future;
  }

  void cleanUp() {

  }
}