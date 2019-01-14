import 'package:flutter/material.dart';

abstract class AdvState<T extends StatefulWidget> extends State<T> {
  bool _firstRun = true;

  @override
  Widget build(BuildContext context) {
    if (_firstRun) {
      initStateWithContext(context);
      _firstRun = false;
    }

    return advBuild(context);
  }

  void initStateWithContext(BuildContext context) {}

  Widget advBuild(BuildContext context);
}