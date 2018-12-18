import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/extras/com_calendar_carousel.dart';
import 'package:pit_components/pit_components.dart';

class ComDatePickerPage extends StatefulWidget {
  final List<DateTime> currentDate;
  final List<MarkedDate> markedDates;
  final SelectionType selectionType;

  ComDatePickerPage({this.currentDate = const[], this.markedDates = const[], this.selectionType});

  @override
  State createState() => new _ComDatePickerPageState();
}

class _ComDatePickerPageState extends State<ComDatePickerPage>
    with SingleTickerProviderStateMixin {
  List<DateTime> _currentDate;
  SelectionType _selectionType;

  @override
  void initState() {
    super.initState();
    _selectionType = widget.selectionType ?? SelectionType.single;
    _currentDate = widget.currentDate ?? [DateTime.now()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(PitComponents.datePickerTitle),
        backgroundColor: PitComponents.datePickerToolbarColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: ComCalendarCarousel(
          selectionType: _selectionType,
          weekDays: PitComponents.weekdaysArray,
          onDayPressed: (List<DateTime> dates) async {
            this.setState(() => _currentDate = dates);
            await new Future.delayed(const Duration(milliseconds: 200));
            Navigator.pop(context, _currentDate);
          },
          thisMonthDayBorderColor: Colors.grey,
          selectedDateTimes: _currentDate,
          daysHaveCircularBorder: false,
          markedDates: widget.markedDates,
        ),
      ),
    );
  }
}
