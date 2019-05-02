import 'package:flutter/material.dart';
import 'package:pit_components/components/extras/roundrect_checkbox.dart';

class AdvCheckbox extends StatefulWidget {
  final ValueNotifier<bool> controller;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  AdvCheckbox({bool value, ValueNotifier<bool> controller, this.onChanged, this.activeColor})
      : assert(controller == null || (value == null)),
        assert(controller == null || (onChanged == null)),
        this.controller = controller ?? ValueNotifier<bool>(value);

  @override
  State<StatefulWidget> createState() => _AdvCheckboxState();
}

class _AdvCheckboxState extends State<AdvCheckbox> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.onChanged == null,
      child: RoundRectCheckbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: widget.activeColor,
          onChanged: (bool value) {
            setState(() {
              widget.controller.value = !widget.controller.value;

              if (widget.onChanged != null) widget.onChanged(widget.controller.value);
            });
          },
          value: widget.controller.value),
    );
  }
}
