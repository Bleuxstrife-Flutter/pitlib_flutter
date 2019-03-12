import 'package:flutter/material.dart';

typedef Future<bool> FutureExecutor(BuildContext context);

abstract class AdvFullState<T extends StatefulWidget> extends State<T> {
  bool _firstRun = true;
  bool _processing = false;
  bool _futureExecuted = false;

  @override
  Widget build(BuildContext context) {
    FutureExecutor futureExecutor = getFutureExecutor();

    if (_firstRun) {
      initStateWithContext(context);
      _firstRun = false;
    }

    if (futureExecutor != null && !_futureExecuted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _futureExecuted = true;
        futureExecutor(context).then((needRedraw) {
          if (this.mounted) {
            setState(() {});
          }
        });
      });
    }

    return buildWidget(context);
  }

  void initStateWithContext(BuildContext context) {}

  Widget buildWidget(BuildContext context);

  FutureExecutor getFutureExecutor() {
    return null;
  }

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

  void refreshFuture() {
    setState(() {
      _futureExecuted = false;
    });
  }
}
