library flutter_calendar_dooboo;

import 'package:flutter/material.dart';

/// A Calculator.
import 'package:intl/intl.dart' show DateFormat;
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/extras/com_calendar_carousel2.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

/// A Calculator.

class ComCalendarCarousel extends StatefulWidget {
  final TextStyle defaultHeaderTextStyle =
      ts.fs20.copyWith(color: PitComponents.datePickerHeaderColor);
  final TextStyle defaultPrevDaysTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerPrevDaysColor);
  final TextStyle defaultNextDaysTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerNextDaysDaysColor);
  final TextStyle defaultDaysTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerWeekdayColor);
  final TextStyle defaultTodayTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerTodayTextColor);
  final TextStyle defaultSelectedDayTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerSelectedTextColor);
  final TextStyle daysLabelTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerDaysLabelColor);
  final TextStyle defaultNotesTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerMarkedDaysDaysColor);
  final TextStyle defaultWeekendTextStyle =
      ts.fs14.copyWith(color: PitComponents.datePickerWeekendColor);
  final Widget defaultMarkedDateWidget = Positioned(
    child: Container(
      color: PitComponents.datePickerMarkedDaysDaysColor,
      height: 4.0,
      width: 4.0,
    ),
    bottom: 4.0,
    left: 18.0,
  );

  final List<String> weekDays;
  final double viewportFraction;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final Color dayButtonColor;
  final Color todayBorderColor = PitComponents.datePickerTodayColor;
  final Color todayButtonColor = PitComponents.datePickerTodayColor;
  final List<DateTime> selectedDateTimes;
  final Color selectedDayButtonColor = PitComponents.datePickerSelectedColor;
  final Color selectedDayBorderColor = PitComponents.datePickerSelectedColor;
  final bool daysHaveCircularBorder;
  final Function(List<DateTime>) onDayPressed;
  final Color iconColor;
  final Widget headerText;
  final List<MarkedDate> markedDates;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final SelectionType selectionType;

  ComCalendarCarousel({
    this.weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
    this.viewportFraction = 1.0,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.dayButtonColor = Colors.transparent,
    this.selectedDateTimes,
    this.daysHaveCircularBorder,
    this.onDayPressed,
    this.iconColor = Colors.blueAccent,
    this.headerText,
    List<MarkedDate> markedDates = const [],
    this.selectionType = SelectionType.single,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
  }) : this.markedDates = markedDates ?? const [];

  @override
  _CalendarState createState() => _CalendarState();
}

class BlankRoute extends PageRoute {
  final Widget child;

  BlankRoute(this.child);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class _CalendarState extends State<ComCalendarCarousel>
    with SingleTickerProviderStateMixin {
  PageController _controller;
  List<DateTime> _dates = List(3);
  int _startWeekday = 0;
  int _endWeekday = 0;
  List<DateTime> _selectedDateTimes = [];
  bool rangeIsComplete = false;

  @override
  initState() {
    super.initState();

    for (var selectedDateTime in widget.selectedDateTimes) {
      _selectedDateTimes.add(DateTime(
          selectedDateTime.year, selectedDateTime.month, selectedDateTime.day));
    }

    rangeIsComplete = widget.selectionType == SelectionType.range &&
        _selectedDateTimes.length % 2 == 0;

    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );
    this._setDate();
    _corntrofller = AnimationController(
      value: 0.0,
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  OverlayEntry _overlayEntry;
  AnimationController _corntrofller;
  bool a = true;

  @override
  Widget build(BuildContext context) {
//    timeDilation = 5.0; // 1.0 means normal animation speed.
    return WillPopScope(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: widget.headerMargin,
              child: DefaultTextStyle(
                style: widget.defaultHeaderTextStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _setDate(page: 0),
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: widget.iconColor,
                      ),
                    ),
                    Container(
                      child: widget.headerText != null
                          ? widget.headerText
                          : Text(
                              '${DateFormat.yMMM().format(this._dates[1])}',
                            ),
                    ),
                    IconButton(
                      onPressed: () => _setDate(page: 2),
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: widget.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Builder(builder: (BuildContext context) {
              return Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: widget.childAspectRatio,
                  padding: EdgeInsets.zero,
                  children: List.generate(12, (index) {
                    return Builder(builder: (BuildContext childContext) {

                      return Hero(
                          tag: "${index}23",
                          child: InkWell(
                            onTap: () {
                              RenderBox renderBox = childContext.findRenderObject();
                              print(
                                  "context 1 => ${renderBox.localToGlobal(Offset(0.0, 0.0))}");

//                            if (a) {
//                              this._overlayEntry =
//                                  this._createOverlayEntry(context);
//                              Overlay.of(context).insert(this._overlayEntry);
//                              _corntrofller.forward();
//                            } else {
//                              _corntrofller.reverse();
//                              this._overlayEntry.remove();
//                            }
//                            a = !a;
//                            Navigator.of(context).push(BlankRoute(
//                                ComCalendarCarousel2(
//                                  selectionType: widget.selectionType,
//                                  weekDays: PitComponents.weekdaysArray,
//                                  onDayPressed:  widget.onDayPressed,
//                                  thisMonthDayBorderColor: Colors.grey,
//                                  selectedDateTimes: widget.selectedDateTimes,
//                                  daysHaveCircularBorder: false,
//                                  markedDates: widget.markedDates,)));
                            },
                            child: Container(
                              margin: EdgeInsets.all(widget.dayPadding),
                              alignment: Alignment.center,
                              child: Text(
                                  "${DateFormat.MMM().format(DateTime(2019, index + 1))}"),
                              color: Colors.amber,
                            ),
                          ));
                    });
                  }),
                ),
              );
            }),

//          Expanded(
//            child: Column(children: [
//              Container(
//                child: widget.weekDays == null
//                    ? Container()
//                    : Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: this._renderWeekDays(),
//                      ),
//              ),
//              Expanded(
//                child: PageView.builder(
//                  itemCount: 3,
//                  onPageChanged: (value) {
//                    this._setDate(page: value);
//                  },
//                  controller: _controller,
//                  itemBuilder: (context, index) {
//                    return dateBuilder(index);
//                  },
////              pageSnapping: true,
//                ),
//              ),
//              Visibility(
//                  visible: widget.selectionType == SelectionType.multi,
//                  child: Container(
//                      margin: EdgeInsets.symmetric(vertical: 8.0),
//                      child: AdvButton(
//                        "Submit",
//                        width: double.infinity,
//                        buttonSize: ButtonSize.large,
//                        onPressed: () {
//                          if (widget.onDayPressed != null)
//                            widget.onDayPressed(_selectedDateTimes);
//                        },
//                      ))),
//            ]),
//          ),
          ],
        ),
      ),
      onWillPop: () async {
        _overlayEntry.remove();
        return true;
      },
    );
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    print("size => ${size.width}");
    print("size => ${size.height}");

    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Material(
                  child: Hero(
                tag: "123",
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Column(children: [
                    Container(
                      child: widget.weekDays == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: this._renderWeekDays(),
                            ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        itemCount: 3,
                        onPageChanged: (value) {
                          this._setDate(page: value);
                        },
                        controller: _controller,
                        itemBuilder: (context, index) {
                          return dateBuilder(index);
                        },
//              pageSnapping: true,
                      ),
                    ),
                    Visibility(
                        visible: widget.selectionType == SelectionType.multi,
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: AdvButton(
                              "Submit",
                              width: double.infinity,
                              buttonSize: ButtonSize.large,
                              onPressed: () {
                                if (widget.onDayPressed != null)
                                  widget.onDayPressed(_selectedDateTimes);
                              },
                            ))),
                  ]),
                ),
              )),
            ));
  }

  Widget ccc(BuildContext context) {
//    RenderBox renderBox = context.findRenderObject();
//    var size = renderBox.size;
//    var offset = renderBox.localToGlobal(Offset.zero);
//    print("size => ${size.width}");
//    print("size => ${size.height}");

    return Material(
      child: Hero(
        tag: "123",
        child: Container(
          child: Column(children: [
            Container(
              child: widget.weekDays == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: this._renderWeekDays(),
                    ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: 3,
                onPageChanged: (value) {
                  this._setDate(page: value);
                },
                controller: _controller,
                itemBuilder: (context, index) {
                  return dateBuilder(index);
                },
//              pageSnapping: true,
              ),
            ),
            Visibility(
                visible: widget.selectionType == SelectionType.multi,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: AdvButton(
                      "Submit",
                      width: double.infinity,
                      buttonSize: ButtonSize.large,
                      onPressed: () {
                        if (widget.onDayPressed != null)
                          widget.onDayPressed(_selectedDateTimes);
                      },
                    ))),
          ]),
        ),
      ),
    );
  }

  dateBuilder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          this._dates[slideIndex].year,
          this._dates[slideIndex].month + 1,
          0,
        ).day +
        this._startWeekday +
        (7 - this._endWeekday);
    int year = this._dates[slideIndex].year;
    int month = this._dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: AdvColumn(
        children: <Widget>[
          Container(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              childAspectRatio: widget.childAspectRatio,
              padding: EdgeInsets.zero,
              children: List.generate(totalItemCount,

                  /// last day of month + weekday
                  (index) {
                bool isToday =
                    DateTime.now().day == index + 1 - this._startWeekday &&
                        DateTime.now().month == month &&
                        DateTime.now().year == year;
                DateTime currentDate =
                    DateTime(year, month, index + 1 - this._startWeekday);
                bool isSelectedDay = (widget.selectionType !=
                            SelectionType.range &&
                        _selectedDateTimes.length > 0 &&
                        _selectedDateTimes.indexOf(currentDate) >= 0) ||
                    (widget.selectionType == SelectionType.range &&
                        _selectedDateTimes.length == 2 &&
                        currentDate.difference(_selectedDateTimes[0]).inDays >
                            0 &&
                        _selectedDateTimes[_selectedDateTimes.length - 1]
                                .difference(currentDate)
                                .inDays >
                            0);
                bool isEdgeDay = _selectedDateTimes.length > 0 &&
                    ((_selectedDateTimes.indexOf(currentDate) == 0 ||
                            _selectedDateTimes.indexOf(currentDate) ==
                                _selectedDateTimes.length - 1) ||
                        (widget.selectionType != SelectionType.range &&
                            _selectedDateTimes.indexOf(currentDate) >= 0));
                bool isPrevMonthDay = index < this._startWeekday;
                bool isNextMonthDay = index >=
                    (DateTime(year, month + 1, 0).day) + this._startWeekday;
                bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                DateTime now = DateTime(year, month, 1);
                TextStyle textStyle;
                if (isPrevMonthDay) {
                  now =
                      now.subtract(Duration(days: this._startWeekday - index));
                  textStyle = widget.defaultPrevDaysTextStyle;
                } else if (isThisMonthDay) {
                  now = DateTime(year, month, index + 1 - this._startWeekday);
                  textStyle = isSelectedDay
                      ? widget.defaultSelectedDayTextStyle
                      : isToday
                          ? widget.defaultTodayTextStyle
                          : widget.defaultDaysTextStyle;
                } else {
                  now = DateTime(year, month, index + 1 - this._startWeekday);
                  textStyle = widget.defaultNextDaysTextStyle;
                }
                return Container(
                  margin: EdgeInsets.all(widget.dayPadding),
                  child: FlatButton(
                    color: isEdgeDay && widget.selectedDayButtonColor != null
                        ? widget.selectedDayButtonColor
                        : isSelectedDay && widget.selectedDayButtonColor != null
                            ? widget.selectedDayButtonColor.withAlpha(150)
                            : isToday && widget.todayBorderColor != null
                                ? widget.todayButtonColor
                                : widget.dayButtonColor,
                    onPressed: () {
                      if (widget.selectionType == SelectionType.single) {
                        _selectedDateTimes.clear();
                        _selectedDateTimes.add(currentDate);
                        if (widget.onDayPressed != null)
                          widget.onDayPressed(_selectedDateTimes);
                      } else if (widget.selectionType == SelectionType.multi) {
                        if (_selectedDateTimes
                                .where((date) => date == currentDate)
                                .length ==
                            0) {
                          _selectedDateTimes.add(currentDate);
                        } else {
                          _selectedDateTimes.remove(currentDate);
                        }
                      } else if (widget.selectionType == SelectionType.range) {
                        if (!rangeIsComplete) {
                          var dateDiff = _selectedDateTimes[0]
                              .difference(currentDate)
                              .inDays;
                          DateTime loopDate;
                          DateTime endDate;

                          if (dateDiff > 0) {
                            loopDate = currentDate;
                            endDate = _selectedDateTimes[0];
                          } else {
                            loopDate = _selectedDateTimes[0];
                            endDate = currentDate;
                          }

                          _selectedDateTimes.clear();
                          _selectedDateTimes.add(loopDate);
                          _selectedDateTimes.add(endDate);

                          if (widget.onDayPressed != null)
                            widget.onDayPressed(_selectedDateTimes);
                        } else {
                          _selectedDateTimes.clear();
                          _selectedDateTimes.add(currentDate);
                        }

                        rangeIsComplete = !rangeIsComplete;
                      }

                      setState(() {});
                    },
                    padding: EdgeInsets.all(widget.dayPadding),
                    shape: widget.daysHaveCircularBorder == null
                        ? CircleBorder()
                        : widget.daysHaveCircularBorder
                            ? CircleBorder(
                                side: BorderSide(
                                  color: isPrevMonthDay
                                      ? widget.prevMonthDayBorderColor
                                      : isNextMonthDay
                                          ? widget.nextMonthDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : widget.thisMonthDayBorderColor,
                                ),
                              )
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                  color: isPrevMonthDay
                                      ? widget.prevMonthDayBorderColor
                                      : isNextMonthDay
                                          ? widget.nextMonthDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : widget.thisMonthDayBorderColor,
                                ),
                              ),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Text(
                            '${now.day}',
                            style: (index % 7 == 0 || index % 7 == 6) &&
                                    !isSelectedDay &&
                                    !isToday
                                ? widget.defaultWeekendTextStyle
                                : isToday
                                    ? widget.defaultTodayTextStyle
                                    : textStyle,
                            maxLines: 1,
                          ),
                        ),
                        _renderMarked(now),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Visibility(
              visible: widget.markedDates
                      .where((markedDate) => markedDate.date.month == month)
                      .toList()
                      .length >
                  0,
              child: Container(
                child: Text(
                  PitComponents.datePickerMarkedDatesTitle,
                  style: ts.fs16.merge(ts.fw700),
                ),
                width: double.infinity,
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              )),
          Expanded(
              child: ListView(
                  children: widget.markedDates
                      .where((markedDate) => markedDate.date.month == month)
                      .toList()
                      .map((markedDate) {
            return Text(
              markedDate.note,
              style: widget.defaultNotesTextStyle,
            );
          }).toList())),
        ],
      ),
    );
  }

  void _setDate({
    int page,
  }) {
    if (page == null) {
      /// setup dates
      DateTime date0 =
          DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      DateTime date1 = DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime date2 =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

      this.setState(() {
        /// setup current day
        _startWeekday = date1.weekday;
        _endWeekday = date2.weekday;
        this._dates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      return;
    } else {
      List<DateTime> dates = this._dates;

      if (page == 0) {
        dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
        dates[1] = DateTime(dates[0].year, dates[0].month, 1);
        dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == 2) {
        dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
        dates[1] = DateTime(dates[2].year, dates[2].month, 1);
        dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
        page = page - 1;
      }

      this.setState(() {
        _startWeekday = dates[page].weekday;
        _endWeekday = dates[page + 1].weekday;
        this._dates = dates;
      });

      _controller.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    for (var weekDay in widget.weekDays) {
      list.add(
        Expanded(
            child: Container(
          margin: widget.weekDayMargin,
          child: Center(
            child: Text(
              weekDay,
              style: widget.daysLabelTextStyle,
            ),
          ),
        )),
      );
    }
    return list;
  }

  Widget _renderMarked(DateTime now) {
    if (widget.markedDates != null &&
        widget.markedDates.length > 0 &&
        widget.markedDates
                .where((markedDate) => markedDate.date == now)
                .toList()
                .length >
            0) {
      return widget.defaultMarkedDateWidget;
    }
    return Container();
  }
}
