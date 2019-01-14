import 'package:flutter/material.dart';

typedef void ResetFunction();
typedef Widget WidgetBuilder(BuildContext context);
typedef Future<bool> FutureExecutor(BuildContext context);

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
  bool _futureExecuted = false;

  @override
  void initState() {
    super.initState();

    widget.remote?.reset = () {
      _futureExecuted = false;
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_futureExecuted) {
      _futureExecuted = true;
      widget.futureExecutor(context).then((needRedraw) {
        if (needRedraw) {
          setState(() {
          });
        }
      });
    }

    return widget.widgetBuilder(context);
  }
}
