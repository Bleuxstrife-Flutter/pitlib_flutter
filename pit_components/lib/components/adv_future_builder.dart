import 'package:flutter/material.dart';

typedef void ResetFunction();
typedef Widget WidgetBuilder(BuildContext context);
typedef Future<bool> FutureExecutor(BuildContext context, int attempt);

class ResetRemote {
  ResetFunction reset;
}

class AdvFutureBuilder extends StatefulWidget {
  final ResetRemote remote;
  final WidgetBuilder widgetBuilder;
  final FutureExecutor futureExecutor;

  AdvFutureBuilder({this.widgetBuilder, this.futureExecutor, this.remote})
      : assert(widgetBuilder != null),
        assert(futureExecutor != null);

  @override
  State<StatefulWidget> createState() => _AdvFutureBuilderState();
}

class _AdvFutureBuilderState extends State<AdvFutureBuilder> {
  int executionAttempt = 1;

  @override
  void initState() {
    super.initState();

    widget.remote?.reset = () {
      executionAttempt = 1;
    };
  }

  @override
  Widget build(BuildContext context) {
    widget.futureExecutor(context, executionAttempt).then((available) {
      if (available) {
        setState(() {
          executionAttempt++;
        });
      }
    });

    return widget.widgetBuilder(context);
  }
}
