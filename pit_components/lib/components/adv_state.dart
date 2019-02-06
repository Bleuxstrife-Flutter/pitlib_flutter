import 'package:flutter/material.dart';

abstract class AdvState<T extends StatefulWidget> extends State<T> {
  bool _firstRun = true;
  bool _processing = false;

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

  bool isProcessing() => _processing;

  Future<void> process(Function f) async {
    setState(() {
      _processing = true;
    });
    await f();
    if (this.mounted) {
      setState(() {
        _processing = false;
      });
    }
  }
}