import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;

typedef GroupCheckCallback = void Function(String data);

class GroupCheckItem {
  String data;
  String display;
  Widget icon;

  GroupCheckItem(this.data, this.display, {this.icon});
}

class AdvGroupCheck extends StatefulWidget {
  final AdvGroupCheckController controller;
  final String title;
  final GroupCheckCallback callback;
  Completer c;
  AdvGroupCheck(
      {this.title,
        String checkedValue,
        List<GroupCheckItem> itemList,
        AdvGroupCheckController controller,
        this.callback})
      : assert(
  controller == null || (checkedValue == null && itemList == null)),
        this.controller = controller ??
            new AdvGroupCheckController(
                checkedValue: checkedValue ?? "", itemList: itemList ?? []);

  @override
  State<StatefulWidget> createState() => _AdvGroupCheckState();
}

class _AdvGroupCheckState extends State<AdvGroupCheck> {
  @override
  void initState() {
    widget.controller.addListener(() {
      if (this.mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  bool _checkedValue = true;

  @override
  Widget build(BuildContext context) {
    List<GroupCheckItem> stringChildren = widget.controller.itemList;
    List<Widget> children = [];

    stringChildren.forEach((groupCheckItem) {
      children.add(Container(child: AdvListTile(
          onTap: () {
            _checkedValue = false;
            widget.controller.checkedValue = groupCheckItem.data;
            setState(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _checkedValue = true;

                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return Container();
                      }
                  ));

                  Timer(Duration(milliseconds: 300), () {
                    Navigator.pop(context);
                    if (widget.callback != null)
                      widget.callback(groupCheckItem.data);
                  });
                });
              });
            });
          },
          padding: EdgeInsets.all(16.0),
          start: groupCheckItem.icon,
          expanded: Text(groupCheckItem.display),
          end: groupCheckItem.data == widget.controller.checkedValue
              ? AbsorbPointer(
              child: RoundCheckbox(
                onChanged: (value) {},
                value: _checkedValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: PitComponents.groupCheckCheckColor,
              ))
              : Container())));
    });

    return Container(
        child: AdvColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.title == null
                ? Container()
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0, bottom: 4.0),
              child: Text(
                widget.title,
                style: ts.fs18
                    .merge(ts.fw700)
                    .copyWith(color: PitComponents.groupCheckTitleColor),
              ),
            ),
            Container(
              child: AdvColumn(
                  divider: Container(
                    height: 1.0,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Theme.of(context).dividerColor,
                  ),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children),
            )
          ],
        ));
  }
}

class AdvGroupCheckController extends ValueNotifier<AdvGroupCheckEditingValue> {
  String get checkedValue => value.checkedValue;

  set checkedValue(String newCheckedValue) {
    value =
        value.copyWith(checkedValue: newCheckedValue, itemList: this.itemList);
  }

  List<GroupCheckItem> get itemList => value.itemList;

  set itemList(List<GroupCheckItem> newItemList) {
    value =
        value.copyWith(checkedValue: this.checkedValue, itemList: newItemList);
  }

  AdvGroupCheckController({String checkedValue, List<GroupCheckItem> itemList})
      : super(checkedValue == null && itemList == null
      ? AdvGroupCheckEditingValue.empty
      : new AdvGroupCheckEditingValue(
      checkedValue: checkedValue, itemList: itemList));

  AdvGroupCheckController.fromValue(AdvGroupCheckEditingValue value)
      : super(value ?? AdvGroupCheckEditingValue.empty);

  void clear() {
    value = AdvGroupCheckEditingValue.empty;
  }
}

@immutable
class AdvGroupCheckEditingValue {
  const AdvGroupCheckEditingValue({this.checkedValue = '', this.itemList});

  final String checkedValue;
  final List<GroupCheckItem> itemList;

  static const AdvGroupCheckEditingValue empty =
  const AdvGroupCheckEditingValue();

  AdvGroupCheckEditingValue copyWith(
      {String checkedValue, List<GroupCheckItem> itemList}) {
    return new AdvGroupCheckEditingValue(
        checkedValue: checkedValue,
        itemList: itemList);
  }

  AdvGroupCheckEditingValue.fromValue(AdvGroupCheckEditingValue copy)
      : this.checkedValue = copy.checkedValue,
        this.itemList = copy.itemList;

  @override
  String toString() =>
      '$runtimeType(checkedValue: \u2524$checkedValue\u251C, valueList: \u2524$itemList\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvGroupCheckEditingValue) return false;
    final AdvGroupCheckEditingValue typedOther = other;
    return typedOther.checkedValue == checkedValue &&
        typedOther.itemList == itemList;
  }

  @override
  int get hashCode => hashValues(checkedValue.hashCode, itemList.hashCode);
}
