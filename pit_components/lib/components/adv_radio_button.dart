import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;

typedef RadioGroupCallback = void Function(String data);
typedef ContentGetterCallback = Widget Function(String data);

class RadioGroupItem {
  String data;
  Widget activeItem;
  Widget inactiveItem;

  RadioGroupItem(this.data, {this.activeItem, this.inactiveItem});
}

class AdvRadioGroup extends StatefulWidget {
  final AdvRadioGroupController controller;
  final String title;
  final RadioGroupCallback callback;
  final Axis direction;
  final double divider;

  AdvRadioGroup(
      {this.title,
      String checkedValue,
      List<RadioGroupItem> itemList,
      AdvRadioGroupController controller,
      this.callback,
      Axis direction,
      this.divider = 0.0})
      : assert(
            controller == null || (checkedValue == null && itemList == null)),
        this.direction = direction ?? Axis.horizontal,
        this.controller = controller ??
            new AdvRadioGroupController(
                checkedValue: checkedValue ?? "", itemList: itemList ?? []);

  @override
  State<StatefulWidget> createState() => _AdvRadioGroupState();
}

class _AdvRadioGroupState extends State<AdvRadioGroup> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (this.mounted) {
        if (widget.callback != null)
          widget.callback(widget.controller.checkedValue);
        setState(() {});
      }
    });
  }

  handleClick(data) {
    widget.controller.checkedValue = data;
    if (widget.callback != null) widget.callback(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<RadioGroupItem> stringChildren = widget.controller.itemList;
    List<Widget> children = [];

    Widget _title = widget.title == null
        ? Container()
        : Container(
            child: Text(
              widget.title,
              style: ts.fs16
                  .merge(ts.fw600)
                  .copyWith(color: PitComponents.radioButtonTitleColor),
            ),
          );

    stringChildren.forEach((radioGroupItem) {
      AdvListTile item = AdvListTile(
          onTap: () {
            handleClick(radioGroupItem.data);
          },
          padding: EdgeInsets.all(0.0),
          start: AbsorbPointer(child: RoundCheckbox(
              activeColor: PitComponents.radioButtonColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (b) {
                handleClick(radioGroupItem.data);
              },
              value: radioGroupItem.data == widget.controller.checkedValue),),
          end: radioGroupItem.data == widget.controller.checkedValue
              ? radioGroupItem.activeItem
              : radioGroupItem.inactiveItem);

      children.add(item);
    });

    return AdvColumn(divider: ColumnDivider(widget.divider), crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title,
      widget.direction == Axis.horizontal
          ? AdvRow(
              divider: RowDivider(widget.divider),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children)
          : AdvColumn(
              divider: ColumnDivider(widget.divider),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children)
    ]);
  }
}

class AdvRadioGroupController extends ValueNotifier<AdvRadioGroupEditingValue> {
  String get checkedValue => value.checkedValue;

  set checkedValue(String newCheckedValue) {
    value =
        value.copyWith(checkedValue: newCheckedValue, itemList: this.itemList);
  }

  List<RadioGroupItem> get itemList => value.itemList;

  set itemList(List<RadioGroupItem> newItemList) {
    value =
        value.copyWith(checkedValue: this.checkedValue, itemList: newItemList);
  }

  AdvRadioGroupController({String checkedValue, List<RadioGroupItem> itemList})
      : super(checkedValue == null && itemList == null
            ? AdvRadioGroupEditingValue.empty
            : new AdvRadioGroupEditingValue(
                checkedValue: checkedValue, itemList: itemList));

  AdvRadioGroupController.fromValue(AdvRadioGroupEditingValue value)
      : super(value ?? AdvRadioGroupEditingValue.empty);

  void clear() {
    value = AdvRadioGroupEditingValue.empty;
  }
}

@immutable
class AdvRadioGroupEditingValue {
  const AdvRadioGroupEditingValue({this.checkedValue = '', this.itemList});

  final String checkedValue;
  final List<RadioGroupItem> itemList;

  static const AdvRadioGroupEditingValue empty =
      const AdvRadioGroupEditingValue();

  AdvRadioGroupEditingValue copyWith(
      {String checkedValue, List<RadioGroupItem> itemList}) {
    return new AdvRadioGroupEditingValue(
        checkedValue: checkedValue ?? this.checkedValue,
        itemList: itemList ?? this.itemList);
  }

  AdvRadioGroupEditingValue.fromValue(AdvRadioGroupEditingValue copy)
      : this.checkedValue = copy.checkedValue,
        this.itemList = copy.itemList;

  @override
  String toString() =>
      '$runtimeType(checkedValue: \u2524$checkedValue\u251C, valueList: \u2524$itemList\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvRadioGroupEditingValue) return false;
    final AdvRadioGroupEditingValue typedOther = other;
    return typedOther.checkedValue == checkedValue &&
        typedOther.itemList == itemList;
  }

  @override
  int get hashCode => hashValues(checkedValue.hashCode, itemList.hashCode);
}
