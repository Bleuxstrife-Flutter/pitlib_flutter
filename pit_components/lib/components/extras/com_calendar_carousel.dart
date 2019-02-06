import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A Calculator.
import 'package:intl/intl.dart' show DateFormat;
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_visibility.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';

/// A Calculator.

/// A Calculator.

const int _kAnimationDuration = 300;

enum PickType {
  day,
  month,
  year,
}

class CalendarStyle {
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
  final Color todayBorderColor = PitComponents.datePickerTodayColor;
  final Color todayButtonColor = PitComponents.datePickerTodayColor;
  final Color selectedDayButtonColor = PitComponents.datePickerSelectedColor;

//  final Color selectedDayBorderColor = PitComponents.datePickerSelectedColor;

  final List<String> weekDays;
  final double viewportFraction;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final Color dayButtonColor;
  final bool daysHaveCircularBorder;
  final Color iconColor;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;

  CalendarStyle({
    this.weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
    this.viewportFraction = 1.0,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.dayButtonColor = Colors.transparent,
    this.daysHaveCircularBorder,
    this.iconColor = Colors.blueAccent,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
  });
}

class CalendarCarousel extends StatefulWidget {
  final PickType pickType;
  final List<DateTime> selectedDateTimes;
  final Function(List<DateTime>) onDayPressed;
  final List<MarkedDate> markedDates;
  final SelectionType selectionType;
  final CalendarStyle calendarStyle;

  CalendarCarousel({
    PickType pickType,
    List<String> weekDays = const [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thur',
      'Fri',
      'Sat'
    ],
    double viewportFraction = 1.0,
    Color prevMonthDayBorderColor = Colors.transparent,
    Color thisMonthDayBorderColor = Colors.transparent,
    Color nextMonthDayBorderColor = Colors.transparent,
    double dayPadding = 2.0,
    Color dayButtonColor = Colors.transparent,
    this.selectedDateTimes,
    bool daysHaveCircularBorder,
    this.onDayPressed,
    Color iconColor = Colors.blueAccent,
    List<MarkedDate> markedDates = const [],
    this.selectionType = SelectionType.single,
    EdgeInsets headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    double childAspectRatio = 1.0,
    EdgeInsets weekDayMargin = const EdgeInsets.only(bottom: 4.0),
  })  : this.pickType = pickType ?? PickType.day,
        this.markedDates = markedDates ?? const [],
        this.calendarStyle = CalendarStyle(
          weekDays: weekDays,
          viewportFraction: viewportFraction,
          prevMonthDayBorderColor: prevMonthDayBorderColor,
          thisMonthDayBorderColor: thisMonthDayBorderColor,
          nextMonthDayBorderColor: nextMonthDayBorderColor,
          dayPadding: dayPadding,
          dayButtonColor: dayButtonColor,
          daysHaveCircularBorder: daysHaveCircularBorder,
          iconColor: iconColor,
          headerMargin: headerMargin,
          childAspectRatio: childAspectRatio,
          weekDayMargin: weekDayMargin,
        );

  @override
  _CalendarCarouselState createState() => _CalendarCarouselState();
}

class _CalendarCarouselState extends State<CalendarCarousel>
    with TickerProviderStateMixin {
  GlobalKey<DayCalendarState> _dayKey = GlobalKey<DayCalendarState>();
  GlobalKey<MonthCalendarState> _monthKey = GlobalKey<MonthCalendarState>();
  GlobalKey<YearCalendarState> _yearKey = GlobalKey<YearCalendarState>();
  AnimationController _dayMonthAnim;
  AnimationController _monthYearAnim;

  @override
  void initState() {
    super.initState();
    _dayMonthAnim = AnimationController(
        duration: Duration(milliseconds: _kAnimationDuration), vsync: this);
    _monthYearAnim = AnimationController(
        duration: Duration(milliseconds: _kAnimationDuration),
        vsync: this,
        value: 1.0);
  }

  @override
  dispose() {
    _dayMonthAnim.dispose();
    _monthYearAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> _selectedDateTimes = widget.selectedDateTimes
        .map((DateTime dateTime) =>
        DateTime(dateTime.year, dateTime.month, dateTime.day))
        .toList();

    return Column(children: [
      Expanded(
        child: Builder(builder: (BuildContext context) {
          List<Widget> children = [
            YearCalendar(
              mainContext: context,
              key: _yearKey,
              pickType: widget.pickType,
              monthKey: _monthKey,
              calendarStyle: widget.calendarStyle,
              monthYearAnim: _monthYearAnim,
              selectedDateTimes: _selectedDateTimes,
              onDayPressed: widget.onDayPressed,
              markedDates: widget.markedDates,
              selectionType: widget.selectionType,
            ),
          ];

          if (widget.pickType == PickType.month ||
              widget.pickType == PickType.day) {
            children.add(
              MonthCalendar(
                mainContext: context,
                key: _monthKey,
                pickType: widget.pickType,
                dayKey: _dayKey,
                yearKey: _yearKey,
                calendarStyle: widget.calendarStyle,
                dayMonthAnim: _dayMonthAnim,
                monthYearAnim: _monthYearAnim,
                selectedDateTimes: _selectedDateTimes,
                onDayPressed: widget.onDayPressed,
                markedDates: widget.markedDates,
                selectionType: widget.selectionType,
              ),
            );
          }

          if (widget.pickType == PickType.day) {
            children.add(
              DayCalendar(
                mainContext: context,
                key: _dayKey,
                pickType: widget.pickType,
                monthKey: _monthKey,
                calendarStyle: widget.calendarStyle,
                dayMonthAnim: _dayMonthAnim,
                selectedDateTimes: _selectedDateTimes,
                onDayPressed: widget.onDayPressed,
                markedDates: widget.markedDates,
                selectionType: widget.selectionType,
              ),
            );
          }

          return Stack(children: children);
        }),
      ),
      AnimatedBuilder(
          animation: _dayMonthAnim,
          builder: (BuildContext context, Widget child) {
            return AdvVisibility(
                visibility: widget.selectionType == SelectionType.multi &&
                    _dayMonthAnim.value != 1.0
                    ? VisibilityFlag.visible
                    : VisibilityFlag.invisible,
                child: Opacity(
                  opacity: 1.0 - _dayMonthAnim.value,
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: AdvButton(
                        "Submit",
                        width: double.infinity,
                        buttonSize: ButtonSize.large,
                        onPressed: () {
                          switch (widget.pickType) {
                            case PickType.year:
                              _yearKey.currentState._handleSubmitTapped();
                              break;
                            case PickType.month:
                              _monthKey.currentState._handleSubmitTapped();
                              break;
                            case PickType.day:
                              _dayKey.currentState._handleSubmitBottonTapped();
                              break;
                          }
                        },
                      )),
                ));
          }),
    ]);
  }
}

class DayCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<MonthCalendarState> monthKey;
  final AnimationController dayMonthAnim;
  final CalendarStyle calendarStyle;
  final PickType pickType;
  final SelectionType selectionType;
  final List<MarkedDate> markedDates;
  final List<DateTime> selectedDateTimes;
  final Function(List<DateTime>) onDayPressed;

  DayCalendar({
    this.mainContext,
    Key key,
    this.monthKey,
    this.dayMonthAnim,
    this.calendarStyle,
    this.pickType,
    this.selectionType,
    this.markedDates,
    this.selectedDateTimes,
    this.onDayPressed,
  }) : super(key: key);

  @override
  DayCalendarState createState() => DayCalendarState();
}

class DayCalendarState extends State<DayCalendar> {
  /// The first run, this will be shown (0.0 [widget.dayMonthAnim]'s value)
  ///
  /// When this title is tapped [_handleDayTitleTapped], we will give this the
  /// fade out animation ([widget.dayMonthAnim]'s value will gradually change
  /// from 0.0 to 1.0)
  ///
  /// When one of [MonthCalendar]'s boxes is tapped [_handleMonthBoxTapped],
  /// we will give this the fade in animation ([widget.dayMonthAnim]'s value
  /// will gradually change from 1.0 to 0.0)

  // Page Controller
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous month,
  /// 2 is for next month
  List<DateTime> _pageDates = List(3);

  /// Used to mark start and end of week days for rendering boxes purpose
  int _startWeekday = 0;
  int _endWeekday = 0;

  /// Selected DateTime
  List<DateTime> _selectedDateTimes = [];

  /// Marks whether the date range [SelectionType.range] is selected on both ends
  bool _selectRangeIsComplete = false;

  /// Transition that this Widget will go whenever this' title is tapped
  /// [_handleDayTitleTapped] or one of [MonthCalendar]'s boxes is tapped
  /// [_handleMonthBoxTapped]
  ///
  /// This tween will always begin from full expanded offset and size
  /// and end to one of [MonthCalendar]'s boxes offset and size
  Tween<Rect> rectTween;

  @override
  initState() {
    super.initState();

    /// Whenever day to month animation is finished, reset rectTween to null
    widget.dayMonthAnim.addListener(() {
      if (widget.dayMonthAnim.status == AnimationStatus.completed ||
          widget.dayMonthAnim.status == AnimationStatus.dismissed) {
        rectTween = null;
      }
    });

    _selectedDateTimes = widget.selectedDateTimes;

    _selectRangeIsComplete = widget.selectionType == SelectionType.range &&
        _selectedDateTimes.length % 2 == 0;

    /// setup pageController
    _pageCtrl = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.calendarStyle.viewportFraction,
    );

    /// set _pageDates for the first time
    this._setPage();
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
//    timeDilation = 5.0;
    Widget dayContent = _buildDayContent(parentContext);

    return AnimatedBuilder(
        animation: widget.dayMonthAnim,
        builder: (BuildContext context, Widget child) {
          if (rectTween == null)
            return AdvVisibility(
                visibility: widget.dayMonthAnim.value == 1.0
                    ? VisibilityFlag.gone
                    : VisibilityFlag.visible,
                child: dayContent);

          /// rect tween set when one of these two occasions occurs
          /// 1. Day Title tapped so it has to be squeezed inside month boxes
          ///
          ///     See also [_handleDayTitleTapped]
          /// 2. One of month boxes is tapped, so Day content should be expanded
          ///     See also [_handleDayBoxTapped]

          /// calculate lerp of destination rect according to current widget.dayMonthAnim.value
          final Rect destRect = rectTween.evaluate(widget.dayMonthAnim);

          /// minus padding for each horizontal and vertical axis
          final Size destSize = Size(
              destRect.size.width - (widget.calendarStyle.dayPadding * 2),
              destRect.size.height - (widget.calendarStyle.dayPadding * 2));
          final double top = destRect.top + widget.calendarStyle.dayPadding;
          final double left = destRect.left + widget.calendarStyle.dayPadding;

          double xFactor = destSize.width / rectTween.begin.width;
          double yFactor = destSize.height / rectTween.begin.height;

          /// scaling the content inside
          final Matrix4 transform = Matrix4.identity()
            ..scale(xFactor, yFactor, 1.0);

          /// keep the initial size, so we can achieve destination scale
          /// example :
          /// rectTween.begin.width * destSize.width / rectTween.begin.width => destSize.width

          /// For the Opacity :
          /// as the scaling goes from 0.0 to 1.0, we progressively change the opacity from 1.0 to 0.0
          return Positioned(
              top: top,
              width: rectTween.begin.width,
              height: rectTween.begin.height,
              left: left,
              child: Opacity(
                  opacity: 1.0 - widget.dayMonthAnim.value,
                  child: Transform(transform: transform, child: dayContent)));
        });
  }

  Widget _buildDayContent(BuildContext context) {
    return Column(
      children: <Widget>[
        AdvRow(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          children: <Widget>[
            IconButton(
              onPressed: () => _setPage(page: 0),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: widget.calendarStyle.iconColor,
              ),
            ),
            Builder(builder: (BuildContext childContext) {
              String title = DateFormat.yMMM().format(this._pageDates[1]);
              return Expanded(
                child: InkWell(
                  child: Container(
                    padding: widget.calendarStyle.headerMargin,
                    child: Text(
                      '$title',
                      textAlign: TextAlign.center,
                      style: widget.calendarStyle.defaultHeaderTextStyle,
                    ),
                  ),
                  onTap: () => _handleDayTitleTapped(context),
                ),
              );
            }),
            IconButton(
              padding: widget.calendarStyle.headerMargin,
              onPressed: () => _setPage(page: 2),
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: widget.calendarStyle.iconColor,
              ),
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this._renderWeekDays(),
          ),
        ),
        Expanded(
          child: PageView.builder(
            itemCount: 3,
            onPageChanged: (value) {
              this._setPage(page: value);
            },
            controller: _pageCtrl,
            itemBuilder: (context, index) {
              return _buildCalendar(index);
            },
          ),
        ),
      ],
    );
  }

  _buildCalendar(int slideIndex) {
    int totalItemCount = DateTime(
      this._pageDates[slideIndex].year,
      this._pageDates[slideIndex].month + 1,
      0,
    ).day +
        this._startWeekday +
        (7 - this._endWeekday);
    int year = this._pageDates[slideIndex].year;
    int month = this._pageDates[slideIndex].month;

    /// build calendar and marked dates notes
    return AdvColumn(
      children: <Widget>[
        Container(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            childAspectRatio: widget.calendarStyle.childAspectRatio,
            padding: EdgeInsets.zero,
            children: List.generate(totalItemCount, (index) {
              DateTime currentDate =
              DateTime(year, month, index + 1 - this._startWeekday);
              bool isToday = DateTime.now().day == currentDate.day &&
                  DateTime.now().month == currentDate.month &&
                  DateTime.now().year == currentDate.year;
              bool isSelectedDay = (widget.selectionType !=
                  SelectionType.range &&
                  _selectedDateTimes.length > 0 &&
                  _selectedDateTimes.indexOf(currentDate) >= 0) ||
                  (widget.selectionType == SelectionType.range &&
                      _selectedDateTimes.length == 2 &&
                      currentDate.difference(_selectedDateTimes[0]).inDays >
                          0 &&
                      _selectedDateTimes.last.difference(currentDate).inDays >
                          0);

              /// this is for range selection type
              bool isStartEndDay = _selectedDateTimes.length > 0 &&
                  ((_selectedDateTimes.indexOf(currentDate) == 0 ||
                      _selectedDateTimes.indexOf(currentDate) ==
                          _selectedDateTimes.length - 1) ||
                      (widget.selectionType != SelectionType.range &&
                          _selectedDateTimes.indexOf(currentDate) >= 0));

              bool isPrevMonthDay = index < this._startWeekday;
              bool isNextMonthDay = index >=
                  (DateTime(year, month + 1, 0).day) + this._startWeekday;
              bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

              TextStyle textStyle;
              Color borderColor;
              if (isPrevMonthDay) {
                textStyle = isSelectedDay || isStartEndDay
                    ? widget.calendarStyle.defaultSelectedDayTextStyle
                    : widget.calendarStyle.defaultPrevDaysTextStyle;
                borderColor = widget.calendarStyle.prevMonthDayBorderColor;
              } else if (isThisMonthDay) {
                textStyle = isSelectedDay || isStartEndDay
                    ? widget.calendarStyle.defaultSelectedDayTextStyle
                    : isToday
                    ? widget.calendarStyle.defaultTodayTextStyle
                    : widget.calendarStyle.defaultDaysTextStyle;
                borderColor = isToday
                    ? widget.calendarStyle.todayBorderColor
                    : widget.calendarStyle.nextMonthDayBorderColor;
              } else if (isNextMonthDay) {
                textStyle = isSelectedDay || isStartEndDay
                    ? widget.calendarStyle.defaultSelectedDayTextStyle
                    : widget.calendarStyle.defaultNextDaysTextStyle;
                borderColor = widget.calendarStyle.nextMonthDayBorderColor;
              }

              Color boxColor;
              if (isStartEndDay &&
                  widget.calendarStyle.selectedDayButtonColor != null) {
                boxColor = widget.calendarStyle.selectedDayButtonColor;
              } else if (isSelectedDay &&
                  widget.calendarStyle.selectedDayButtonColor != null) {
                boxColor =
                    widget.calendarStyle.selectedDayButtonColor.withAlpha(150);
              } else if (isToday &&
                  widget.calendarStyle.todayBorderColor != null) {
                boxColor = widget.calendarStyle.todayButtonColor;
              } else {
                boxColor = widget.calendarStyle.dayButtonColor;
              }
              print(
                  "(${currentDate}, ${isSelectedDay}, ${isStartEndDay}) widget.selectedDateTimes ~> ${widget.selectedDateTimes}");
              print("_selectedDateTimes ~> ${_selectedDateTimes}");

              return Container(
                margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
                child: FlatButton(
                  color: boxColor,
                  onPressed: () => _handleDayBoxTapped(currentDate),
                  padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
                  shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                      ? CircleBorder(side: BorderSide(color: borderColor))
                      : RoundedRectangleBorder(
                      side: BorderSide(color: borderColor)),
                  child: Stack(children: <Widget>[
                    Center(
                      child: Text(
                        '${currentDate.day}',
                        style: (index % 7 == 0 || index % 7 == 6) &&
                            !isSelectedDay &&
                            !isStartEndDay &&
                            !isToday
                            ? widget.calendarStyle.defaultWeekendTextStyle
                            : isToday
                            ? widget.calendarStyle.defaultTodayTextStyle
                            : textStyle,
                        maxLines: 1,
                      ),
                    ),
                    _renderMarked(currentDate),
                  ]),
                ),
              );
            }),
          ),
        ),
        Visibility(
            visible: widget.markedDates
                .where((markedDate) =>
            markedDate.date.month == month &&
                markedDate.date.year == year)
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
                    .where((markedDate) =>
                markedDate.date.month == month &&
                    markedDate.date.year == year)
                    .toList()
                    .map((markedDate) {
                  return Text(
                    markedDate.note,
                    style: widget.calendarStyle.defaultNotesTextStyle,
                  );
                }).toList())),
      ],
    );
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    for (var weekDay in widget.calendarStyle.weekDays) {
      list.add(
        Expanded(
            child: Container(
              margin: widget.calendarStyle.weekDayMargin,
              child: Center(
                child: Text(
                  weekDay,
                  style: widget.calendarStyle.daysLabelTextStyle,
                ),
              ),
            )),
      );
    }
    return list;
  }

  /// draw a little dot inside the each boxes (only if it's one of the
  /// [widget.markedDates] and slightly below day text
  Widget _renderMarked(DateTime now) {
    if (widget.markedDates != null &&
        widget.markedDates.length > 0 &&
        widget.markedDates
            .where((markedDate) => markedDate.date == now)
            .toList()
            .length >
            0) {
      return widget.calendarStyle.defaultMarkedDateWidget;
    }

    return Container();
  }

  void _handleSubmitBottonTapped() {
    if (widget.onDayPressed != null) widget.onDayPressed(_selectedDateTimes);
  }

  void _handleDayTitleTapped(BuildContext context) {
    /// unless the whole content is fully expanded, cannot tap on title
    if (widget.dayMonthAnim.value != 0.0) return;

    RenderBox fullRenderBox = context.findRenderObject();
    var fullSize = fullRenderBox.size;
    var fullOffset = Offset.zero;

    Rect fullRect = Rect.fromLTWH(
        fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);
    Rect boxRect = widget.monthKey.currentState
        .getBoxRectFromIndex(this._pageDates[1].month - 1);

    rectTween = RectTween(begin: fullRect, end: boxRect);

    setState(() {
      widget.dayMonthAnim.forward();
    });
  }

  void _handleDayBoxTapped(DateTime currentDate) {
    /// unless the whole content is fully expanded, cannot tap on date
    if (widget.dayMonthAnim.value != 0.0) return;

    if (widget.selectionType == SelectionType.single) {
      _selectedDateTimes.clear();
      _selectedDateTimes.add(currentDate);
      if (widget.onDayPressed != null) widget.onDayPressed(_selectedDateTimes);
    } else if (widget.selectionType == SelectionType.multi) {
      if (_selectedDateTimes.where((date) => date == currentDate).length == 0) {
        _selectedDateTimes.add(currentDate);
      } else {
        _selectedDateTimes.remove(currentDate);
      }
    } else if (widget.selectionType == SelectionType.range) {
      if (!_selectRangeIsComplete) {
        var dateDiff = _selectedDateTimes[0].difference(currentDate).inDays;
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

      _selectRangeIsComplete = !_selectRangeIsComplete;
    }

    setState(() {});

    widget.monthKey.currentState.updateSelectedDateTimes(_selectedDateTimes);
  }

  void _setPage({int page}) {
    /// for initial set
    if (page == null) {
      DateTime date0 =
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      DateTime date1 = DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime date2 =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

      this.setState(() {
        _startWeekday = date1.weekday;
        _endWeekday = date2.weekday;
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
        dates[1] = DateTime(dates[0].year, dates[0].month, 1);
        dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
        dates[1] = DateTime(dates[2].year, dates[2].month, 1);
        dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
        page = page - 1;
      }

      this.setState(() {
        _startWeekday = dates[page].weekday;
        _endWeekday = dates[page + 1].weekday;
        this._pageDates = dates;
      });

      /// animate to page right away after reset the values
      _pageCtrl.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }

    /// set current month and year in the [MonthCalendar] and
    /// [YearCalendar (via MonthCalendar)]
    widget.monthKey.currentState
        .setMonth(_pageDates[1].month, _pageDates[1].year);
    widget.monthKey.currentState.setYear(_pageDates[1].year);
  }

  /// an open method for [MonthCalendar] to trigger whenever it itself changes
  /// its month value
  void setMonth(
      int month,
      int year,
      ) {
    List<DateTime> dates = List(3);
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    this.setState(() {
      _startWeekday = dates[1].weekday;
      _endWeekday = dates[2].weekday;
      this._pageDates = dates;
    });
  }
}

class MonthCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<DayCalendarState> dayKey;
  final GlobalKey<YearCalendarState> yearKey;
  final AnimationController dayMonthAnim;
  final AnimationController monthYearAnim;
  final CalendarStyle calendarStyle;
  final PickType pickType;
  final SelectionType selectionType;
  final List<MarkedDate> markedDates;
  final List<DateTime> selectedDateTimes;
  final Function(List<DateTime>) onDayPressed;

  MonthCalendar({
    this.mainContext,
    Key key,
    this.dayKey,
    this.yearKey,
    this.dayMonthAnim,
    this.monthYearAnim,
    this.calendarStyle,
    this.pickType,
    this.selectionType,
    this.markedDates,
    this.selectedDateTimes,
    this.onDayPressed,
  }) : super(key: key);

  @override
  MonthCalendarState createState() => MonthCalendarState();
}

class MonthCalendarState extends State<MonthCalendar>
    with TickerProviderStateMixin {
  /// The first run, this will be shown (0.0 [widget.dayMonthAnim]'s value)
  ///
  /// After the first run, when [widget.dayMonthAnim]'s value is 0.0, this will
  /// be gone
  ///
  /// When the [DayCalendar]'s title is tapped [_handleDayTitleTapped],
  /// we will give this the fade in animation ([widget.dayMonthAnim]'s value
  /// will gradually change from 0.0 to 1.0)
  ///
  /// When one of this' boxes is tapped [_handleMonthBoxTapped], we will give
  /// this the fade out animation ([widget.dayMonthAnim]'s value will gradually
  /// change from 1.0 to 0.0)
  ///
  /// When this title is tapped [_handleMonthTitleTapped],
  /// we will give this the fade out animation ([widget.monthYearAnim]'s value
  /// will gradually change from 1.0 to 0.0)
  ///
  /// When one of [YearCalendar]'s boxes is tapped [_handleYearBoxTapped],
  /// we will give this the fade in animation ([widget.monthYearAnim]'s value
  /// will gradually change from 0.0 to 1.0)

  /// Page Controller
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous year,
  /// 2 is for next year
  List<DateTime> _pageDates = List(3);

  /// Selected DateTime
  List<DateTime> _selectedDateTimes = [];

  /// Marks whether the date range [SelectionType.range] is selected on both ends
  bool _selectRangeIsComplete = false;

  /// Array for each boxes position and size
  ///
  /// each boxes position and size is stored for the first time and after they
  /// are rendered, since their size and position at full extension is always
  /// the same. Later will be used by [DayCalender] to squeezed its whole content
  /// as big as one of these boxes and in its position, according to its month
  /// value
  List<Rect> boxRects = List(12);

  /// Opacity controller for [MonthCalender]
  AnimationController opacityCtrl;

  /// Transition that this Widget will go whenever [DayCalendar]' title is tapped
  /// [_handleDayTitleTapped] or one of this' boxes is tapped [_handleMonthBoxTapped]
  ///
  /// or
  ///
  /// whenever this' title is tapped [_handleMonthTitleTapped] or one of
  /// [YearCalendar]'s boxes is tapped [_handleYearBoxTapped]
  ///
  /// This tween will always begin from one of [YearCalendar]'s boxes offset and size
  /// and end to full expanded offset and size
  Tween<Rect> rectTween;

  /// On the first run, [MonthCalendar] will need to be drawn so [boxRects] will
  /// be set
  bool _firstRun = true;

  @override
  initState() {
    super.initState();

    /// if the [pickType] is month, then show [MonthCalendar] as front page,
    /// (there will be no [DayCalendar], otherwise, hide [MonthCalendar] and
    /// wait until [DayCalendar] request to be shown
    ///
    /// See [_handleDayTitleTapped]
    opacityCtrl = AnimationController(
        duration: Duration(milliseconds: _kAnimationDuration),
        vsync: this,
        value: widget.pickType == PickType.month ? 1.0 : 0.0);

    /// Change opacity controller's value equals month year controller's value
    widget.dayMonthAnim.addListener(() {
      opacityCtrl.value = widget.dayMonthAnim.value;
    });

    /// Whenever month to year animation is finished, reset rectTween to null
    /// Also change opacity controller's value equals month year controller's value
    widget.monthYearAnim.addListener(() {
      opacityCtrl.value = widget.monthYearAnim.value;

      if (widget.monthYearAnim.status == AnimationStatus.completed ||
          widget.monthYearAnim.status == AnimationStatus.dismissed) {
        rectTween = null;
      }
    });

    _selectedDateTimes = widget.selectedDateTimes;

    _selectRangeIsComplete = widget.selectionType == SelectionType.range &&
        _selectedDateTimes.length % 2 == 0;

    /// setup pageController
    _pageCtrl = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.calendarStyle.viewportFraction,
    );

    /// set _pageDates for the first time
    this._setPage();

    /// Switch firstRun's value to false after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstRun = false;
    });
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    Widget monthContent = _buildMonthContent(parentContext);

    return AnimatedBuilder(
        animation: opacityCtrl,
        builder: (BuildContext context, Widget child) {
          if (rectTween == null)
            return AdvVisibility(
                visibility: opacityCtrl.value == 0.0 && !_firstRun
                    ? VisibilityFlag.gone
                    : VisibilityFlag.visible,
                child:
                Opacity(opacity: opacityCtrl.value, child: monthContent));

          /// rect tween set when one of these two occasions occurs
          /// 1. Month Title tapped so it has to be squeezed inside year boxes
          ///
          ///     See also [_handleMonthTitleTapped]
          /// 2. One of year boxes is tapped, so Month content should be expanded
          ///     See also [_handleMonthBoxTapped]

          /// calculate lerp of destination rect according to current
          /// widget.dayMonthAnim.value or widget.monthYearAnim.value
          final Rect destRect = rectTween.evaluate(opacityCtrl);

          /// minus padding for each horizontal and vertical axis
          final Size destSize = Size(
              destRect.size.width - (widget.calendarStyle.dayPadding * 2),
              destRect.size.height - (widget.calendarStyle.dayPadding * 2));
          final double top = destRect.top + widget.calendarStyle.dayPadding;
          final double left = destRect.left + widget.calendarStyle.dayPadding;

          double xFactor = destSize.width / rectTween.end.width;
          double yFactor = destSize.height / rectTween.end.height;

          final Matrix4 transform = Matrix4.identity()
            ..scale(xFactor, yFactor, 1.0);

          /// For the Width and Height :
          /// keep the initial size, so we can achieve destination scale
          /// example :
          /// rectTween.end.width * destSize.width / rectTween.end.width => destSize.width

          /// For the Opacity :
          /// as the scaling goes from 0.0 to 1.0, we progressively change the opacity
          ///
          /// Note: to learn how these animations controller's value work,
          /// read the documentation at start of this State's script
          return Positioned(
              top: top,
              width: rectTween.end.width,
              height: rectTween.end.height,
              left: left,
              child: Opacity(
                  opacity: opacityCtrl.value,
                  child: Transform(transform: transform, child: monthContent)));
        });
  }

  _buildMonthContent(BuildContext parentContext) {
    return Column(
      children: <Widget>[
        AdvRow(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () => _setPage(page: 0),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: widget.calendarStyle.iconColor,
              ),
            ),
            Builder(builder: (BuildContext childContext) {
              return Expanded(
                child: InkWell(
                  child: Container(
                    margin: widget.calendarStyle.headerMargin,
                    child: Text(
                      '${this._pageDates[1].year}',
                      textAlign: TextAlign.center,
                      style: widget.calendarStyle.defaultHeaderTextStyle,
                    ),
                  ),
                  onTap: () => _handleMonthTitleTapped(parentContext),
                ),
              );
            }),
            IconButton(
              onPressed: () => _setPage(page: 2),
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: widget.calendarStyle.iconColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: PageView.builder(
            itemCount: 3,
            onPageChanged: (value) {
              this._setPage(page: value);
            },
            controller: _pageCtrl,
            itemBuilder: (context, index) {
              return _buildCalendar(index);
            },
          ),
        ),
      ],
    );
  }

  _buildCalendar(int slideIndex) {
    int year = this._pageDates[slideIndex].year;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: widget.calendarStyle.childAspectRatio,
      padding: EdgeInsets.zero,
      children: List.generate(12, (index) {
        DateTime currentDate = DateTime(year, index + 1, 1);
        int currentDateInt = int.tryParse("$year${index + 1}");
        bool isToday = DateTime.now().month == currentDate.month &&
            DateTime.now().year == currentDate.year;

        DateTime firstDate =
        _selectedDateTimes.length == 2 ? _selectedDateTimes.first : null;
        int firstDateInt = _selectedDateTimes.length == 2
            ? int.tryParse("${firstDate.year}${firstDate.month}")
            : 0;

        DateTime lastDate =
        _selectedDateTimes.length == 2 ? _selectedDateTimes.last : null;
        int lastDateInt = _selectedDateTimes.length == 2
            ? int.tryParse("${lastDate.year}${lastDate.month}")
            : 0;

        bool isSelectedDay = (widget.selectionType != SelectionType.range &&
            _selectedDateTimes.length > 0 &&
            _selectedDateTimes
                .where((loopDate) =>
            loopDate.month == currentDate.month &&
                loopDate.year == currentDate.year)
                .length >
                0) ||
            (widget.selectionType == SelectionType.range &&
                _selectedDateTimes.length == 2 &&
                currentDateInt > firstDateInt &&
                currentDateInt < lastDateInt);

        bool isStartEndDay = _selectedDateTimes.length > 0 &&
            ((widget.selectionType == SelectionType.range &&
                _selectedDateTimes.length == 2 &&
                ((_selectedDateTimes.first.month == currentDate.month &&
                    _selectedDateTimes.first.year ==
                        currentDate.year) ||
                    (_selectedDateTimes.last.month == currentDate.month &&
                        _selectedDateTimes.last.year ==
                            currentDate.year))) ||
                (widget.selectionType != SelectionType.range &&
                    _selectedDateTimes.length > 0 &&
                    _selectedDateTimes
                        .where((loopDate) =>
                    loopDate.month == currentDate.month &&
                        loopDate.year == currentDate.year)
                        .length >
                        0));

        TextStyle textStyle;
        Color borderColor;

        Color boxColor;
        if (isStartEndDay &&
            widget.calendarStyle.selectedDayButtonColor != null) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isSelectedDay) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor.withAlpha(150);
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isToday) {
          textStyle = widget.calendarStyle.defaultTodayTextStyle;
          boxColor = widget.calendarStyle.todayButtonColor;
          borderColor = widget.calendarStyle.todayBorderColor;
        } else {
          textStyle = widget.calendarStyle.defaultDaysTextStyle;
          boxColor = widget.calendarStyle.dayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        }

        return Builder(
          builder: (BuildContext context) {
            /// if [index]' boxRect is still null, set post frame callback to
            /// set boxRect after first render
            if (boxRects[index] == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                RenderBox renderBox = context.findRenderObject();
                RenderBox mainRenderBox = widget.mainContext.findRenderObject();
                var offset = renderBox.localToGlobal(Offset.zero,
                    ancestor: mainRenderBox);
                var size = renderBox.size;
                Rect rect = Rect.fromLTWH(
                    offset.dx, offset.dy, size.width, size.height);
                boxRects[index] = rect;
              });
            }

            return Container(
              margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
              child: FlatButton(
                color: boxColor,
                onPressed: () =>
                    _handleMonthBoxTapped(context, index + 1, year),
                padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
                shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                    ? CircleBorder(
                  side: BorderSide(color: borderColor),
                )
                    : RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                ),
                child: Center(
                  child: Text(
                    '${PitComponents.monthsArray[currentDate.month - 1]}',
                    style: textStyle,
                    maxLines: 1,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _handleSubmitTapped() {
    if (widget.onDayPressed != null) widget.onDayPressed(_selectedDateTimes);
  }

  void _handleMonthTitleTapped(BuildContext context) {
    /// unless the whole content is fully expanded, cannot tap on title
    if (widget.monthYearAnim.value != 1.0) return;

    int yearMod = this._pageDates[1].year % 12;
    Rect boxRect = widget.yearKey.currentState
        .getBoxRectFromIndex((yearMod == 0 ? 12 : yearMod) - 1);

    RenderBox fullRenderBox = context.findRenderObject();
    var fullSize = fullRenderBox.size;
    var fullOffset = Offset.zero;

    Rect fullRect = Rect.fromLTWH(
        fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

    rectTween = RectTween(begin: boxRect, end: fullRect);

    setState(() {
      widget.monthYearAnim.reverse();
    });
  }

  void _handleMonthBoxTapped(BuildContext context, int month, int year) {
    /// check if whether this picker is enabled to pick only month and year
    if (widget.pickType != PickType.month) {
      /// unless the whole content is fully expanded, cannot tap on month
      if (widget.dayMonthAnim.value != 1.0 ||
          widget.dayMonthAnim.status != AnimationStatus.completed) return;
      if (widget.monthYearAnim.value != 1.0 ||
          widget.monthYearAnim.status != AnimationStatus.completed) return;

      DayCalendarState dayState = widget.dayKey.currentState;

      RenderBox monthBoxRenderBox = context.findRenderObject();
      Size monthBoxSize = monthBoxRenderBox.size;
      Offset monthBoxOffset = monthBoxRenderBox.localToGlobal(Offset.zero,
          ancestor: widget.mainContext.findRenderObject());
      Rect monthBoxRect = Rect.fromLTWH(monthBoxOffset.dx, monthBoxOffset.dy,
          monthBoxSize.width, monthBoxSize.height);

      RenderBox fullRenderBox = widget.mainContext.findRenderObject();
      var fullSize = fullRenderBox.size;
      var fullOffset = Offset.zero;
      Rect fullRect = Rect.fromLTWH(
          fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

      dayState.setState(() {
        dayState.setMonth(month, year);
        dayState.rectTween = RectTween(begin: fullRect, end: monthBoxRect);
        widget.dayMonthAnim.reverse();
      });
    } else {
      //pick month
      DateTime currentDate = DateTime(year, month);

      if (widget.selectionType == SelectionType.single) {
        _selectedDateTimes.clear();
        _selectedDateTimes.add(currentDate);
        if (widget.onDayPressed != null)
          widget.onDayPressed(_selectedDateTimes);
      } else if (widget.selectionType == SelectionType.multi) {
        if (_selectedDateTimes.where((date) => date == currentDate).length ==
            0) {
          _selectedDateTimes.add(currentDate);
        } else {
          _selectedDateTimes.remove(currentDate);
        }
      } else if (widget.selectionType == SelectionType.range) {
        if (!_selectRangeIsComplete) {
          var dateDiff = _selectedDateTimes[0].difference(currentDate).inDays;
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

        _selectRangeIsComplete = !_selectRangeIsComplete;
      }

      setState(() {});
    }
  }

  void _setPage({int page}) {
    /// for initial set
    if (page == null) {
      DateTime date0 = DateTime(DateTime.now().year - 1);
      DateTime date1 = DateTime(DateTime.now().year);
      DateTime date2 = DateTime(DateTime.now().year + 1);

      this.setState(() {
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        dates[2] = DateTime(dates[0].year + 1);
        dates[1] = DateTime(dates[0].year);
        dates[0] = DateTime(dates[0].year - 1);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        dates[0] = DateTime(dates[2].year - 1);
        dates[1] = DateTime(dates[2].year);
        dates[2] = DateTime(dates[2].year + 1);
        page = page - 1;
      }

      this.setState(() {
        this._pageDates = dates;
      });

      /// animate to page right away after reset the values
      _pageCtrl.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));

      /// set year on [YearCalendar]
      widget.yearKey.currentState.setYear(_pageDates[1].year);
    }
  }

  /// an open method for [DayCalendar] to trigger whenever it itself changes
  /// its month value
  void setMonth(int month, int year) {
    List<DateTime> dates = List(3);
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  /// an open method for [DayCalendar] or [YearCalendar] to trigger whenever it
  /// itself changes its month value
  void setYear(int year) {
    List<DateTime> dates = List(3);
    int month = _pageDates[1].month;
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  void updateSelectedDateTimes(List<DateTime> selectedDateTimes) {
    setState(() {
      _selectedDateTimes = selectedDateTimes;
    });

    widget.yearKey.currentState.updateSelectedDateTimes(selectedDateTimes);
  }

  /// get boxes size by index
  Rect getBoxRectFromIndex(int index) => boxRects[index];
}

class YearCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<MonthCalendarState> monthKey;
  final AnimationController monthYearAnim;
  final CalendarStyle calendarStyle;
  final PickType pickType;
  final SelectionType selectionType;
  final List<MarkedDate> markedDates;
  final List<DateTime> selectedDateTimes;
  final Function(List<DateTime>) onDayPressed;

  YearCalendar({
    this.mainContext,
    Key key,
    this.monthKey,
    this.monthYearAnim,
    this.calendarStyle,
    this.pickType,
    this.selectionType,
    this.markedDates,
    this.selectedDateTimes,
    this.onDayPressed,
  }) : super(key: key);

  @override
  YearCalendarState createState() => YearCalendarState();
}

class YearCalendarState extends State<YearCalendar>
    with SingleTickerProviderStateMixin {
  /// The first run, this will be hidden (1.0 [widget.monthYearAnim]'s value)
  ///
  /// When the [MonthCalendar]'s title is tapped [_handleMonthTitleTapped],
  /// we will give this the fade in animation ([widget.monthYearAnim]'s value
  /// will gradually change from 1.0 to 0.0)
  ///
  /// When one of this' boxes is tapped [_handleYearBoxTapped], we will give
  /// this the fade out animation ([widget.dayMonthAnim]'s value will gradually
  /// change from 0.0 to 1.0)
  ///
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous 12 years,
  /// 2 is for next 12 years
  List<DateTime> _pageDates = List(3);

  /// Selected DateTime
  List<DateTime> _selectedDateTimes = [];

  /// Marks whether the date range [SelectionType.range] is selected on both ends
  bool _selectRangeIsComplete = false;

  /// Array for each boxes position and size
  ///
  /// each boxes position and size is stored for the first time and after they
  /// are rendered, since their size and position at full extension is always
  /// the same. Later will be used by [MonthCalender] to squeezed its whole content
  /// as big as one of these boxes and in its position, according to its year
  /// value
  List<Rect> boxRects = List(12);

  /// Opacity controller for this
  ///
  /// This Opacity Controller is kinda different from [MonthCalendar]'s
  /// Since this AnimationController's value is reversed from [MonthCalendar]
  /// Explanation:
  /// [MonthCalendar.dayMonthAnim]'s 0.0 value would mean hidden for [MonthCalendar]
  /// and
  /// [MonthCalendar.dayMonthAnim]'s 1.0 value would mean shown for [MonthCalendar]
  ///
  /// therefore
  ///
  /// [MonthCalendar.opacityCtrl]'s 0.0 value would mean hidden for [MonthCalendar]
  /// and
  /// [MonthCalendar.opacityCtrl]'s 1.0 value would mean shown for [MonthCalendar]
  ///
  /// in order for [MonthCalendar]'s title can be tapped, it has to be in its full
  /// extension size ([MonthCalendar.opacityCtrl]'s 1.0 value) and when
  /// [MonthCalendar]'s title is tapped (_handleMonthTitleTapped), it has to reverse
  /// [MonthCalendar.opacityCtrl]'s value from 1.0 to 0.0, and if we link it to
  /// [MonthCalendar.monthYearCtrl] which is [this.monthYearCtrl] also,
  /// 0.0 would mean shown for this, thus, 1.0 would mean hidden.
  ///
  /// therefore
  ///
  /// this' opacity would be [1.0 - opacityCtrl.value]
  AnimationController opacityCtrl;

  @override
  initState() {
    super.initState();

    /// if the [pickType] is year, then show this as front page,
    /// (there will be no [DayCalendar] and [MonthCalendar], otherwise,
    /// hide this and wait until [MonthCalendar] request to be shown
    ///
    /// See [_handleMonthTitleTapped]
    opacityCtrl = AnimationController(
        duration: Duration(milliseconds: _kAnimationDuration),
        vsync: this,
        value: widget.pickType == PickType.year ? 0.0 : 1.0);

    /// Change opacity controller's value equals month year controller's value
    widget.monthYearAnim.addListener(() {
      opacityCtrl.value = widget.monthYearAnim.value;
    });

    _selectedDateTimes = widget.selectedDateTimes;

    _selectRangeIsComplete = widget.selectionType == SelectionType.range &&
        _selectedDateTimes.length % 2 == 0;

    /// setup pageController
    _pageCtrl = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.calendarStyle.viewportFraction,

      /// width percentage
    );

    /// set _pageDates for the first time
    this._setPage();
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ccontext) {
    return AnimatedBuilder(
        animation: opacityCtrl,
        builder: (BuildContext parentContext, Widget child) {
          /// this opacity is kinda different from [MonthCalendar]
          ///
          /// See [opacityCtrl]
          return Opacity(
            opacity: 1.0 - opacityCtrl.value,
            child: Column(
              children: <Widget>[
                Container(
                  margin: widget.calendarStyle.headerMargin,
                  child: DefaultTextStyle(
                    style: widget.calendarStyle.defaultHeaderTextStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _setPage(page: 0),
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: widget.calendarStyle.iconColor,
                          ),
                        ),
                        Container(
                          child: Text(
                            '${this._pageDates[1].year + 1} - ${this._pageDates[1].year + 12}',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _setPage(page: 2),
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: widget.calendarStyle.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (value) {
                      this._setPage(page: value);
                    },
                    controller: _pageCtrl,
                    itemBuilder: (context, index) {
                      return _buildCalendar(index);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildCalendar(int slideIndex) {
    int year = this._pageDates[slideIndex].year;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: widget.calendarStyle.childAspectRatio,
      padding: EdgeInsets.zero,
      children: List.generate(12, (index) {
        bool isToday = DateTime.now().year == year + index + 1;
        DateTime currentDate = DateTime(year + index + 1);
        bool isSelectedDay = (widget.selectionType != SelectionType.range &&
            _selectedDateTimes.length > 0 &&
            _selectedDateTimes
                .where((loopDate) => loopDate.year == currentDate.year)
                .length >
                0) ||
            (widget.selectionType == SelectionType.range &&
                _selectedDateTimes.length == 2 &&
                currentDate.year > _selectedDateTimes.first.year &&
                currentDate.year < _selectedDateTimes.last.year);
        bool isStartEndDay = _selectedDateTimes.length > 0 &&
            ((widget.selectionType == SelectionType.range &&
                ((_selectedDateTimes.first.year == currentDate.year) ||
                    (_selectedDateTimes.last.year == currentDate.year))) ||
                (widget.selectionType != SelectionType.range &&
                    _selectedDateTimes.length > 0 &&
                    _selectedDateTimes
                        .where(
                            (loopDate) => loopDate.year == currentDate.year)
                        .length >
                        0));

        TextStyle textStyle;
        Color borderColor;
        Color boxColor;
        if (isStartEndDay &&
            widget.calendarStyle.selectedDayButtonColor != null) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isSelectedDay) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor.withAlpha(150);
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isToday) {
          textStyle = widget.calendarStyle.defaultTodayTextStyle;
          boxColor = widget.calendarStyle.todayButtonColor;
          borderColor = widget.calendarStyle.todayBorderColor;
        } else {
          textStyle = widget.calendarStyle.defaultDaysTextStyle;
          boxColor = widget.calendarStyle.dayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        }

        return Builder(builder: (BuildContext context) {
          /// if [index]' boxRect is still null, set post frame callback to
          /// set boxRect after first render
          if (boxRects[index] == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              RenderBox renderBox = context.findRenderObject();
              RenderBox mainRenderBox = widget.mainContext.findRenderObject();
              var offset =
              renderBox.localToGlobal(Offset.zero, ancestor: mainRenderBox);
              var size = renderBox.size;
              Rect rect =
              Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
              boxRects[index] = rect;
            });
          }

          return Container(
            margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
            child: FlatButton(
              color: boxColor,
              onPressed: () => _handleYearBoxTapped(context, currentDate.year),
              padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
              shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                  ? CircleBorder(
                side: BorderSide(color: borderColor),
              )
                  : RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
              ),
              child: Center(
                child: Text(
                  "${currentDate.year}",
                  style: isToday
                      ? widget.calendarStyle.defaultTodayTextStyle
                      : textStyle,
                  maxLines: 1,
                ),
              ),
            ),
          );
        });
      }),
    );
  }

  void _handleSubmitTapped() {
    if (widget.onDayPressed != null) widget.onDayPressed(_selectedDateTimes);
  }

  void _handleYearBoxTapped(BuildContext context, int year) {
    /// check if whether this picker is enabled to pick only year
    if (widget.pickType != PickType.year) {
      /// unless the whole content is shown, cannot tap on year
      if (widget.monthYearAnim.value != 0.0 ||
          widget.monthYearAnim.status != AnimationStatus.dismissed) return;

      MonthCalendarState monthState = widget.monthKey.currentState;

      RenderBox yearBoxRenderBox = context.findRenderObject();
      Size yearBoxSize = yearBoxRenderBox.size;
      Offset yearBoxOffset = yearBoxRenderBox.localToGlobal(Offset.zero,
          ancestor: widget.mainContext.findRenderObject());
      Rect yearBoxRect = Rect.fromLTWH(yearBoxOffset.dx, yearBoxOffset.dy,
          yearBoxSize.width, yearBoxSize.height);

      RenderBox fullRenderBox = widget.mainContext.findRenderObject();
      Offset fullOffset = Offset.zero;
      Size fullSize = fullRenderBox.size;
      Rect fullRect = Rect.fromLTWH(
          fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

      monthState.setState(() {
        monthState.setYear(year);
        monthState.rectTween = RectTween(begin: yearBoxRect, end: fullRect);
        widget.monthYearAnim.forward();
      });
    } else {
      //pick year
      DateTime currentDate = DateTime(year);
      if (widget.selectionType == SelectionType.single) {
        _selectedDateTimes.clear();
        _selectedDateTimes.add(currentDate);
        if (widget.onDayPressed != null)
          widget.onDayPressed(_selectedDateTimes);
      } else if (widget.selectionType == SelectionType.multi) {
        if (_selectedDateTimes.where((date) => date == currentDate).length ==
            0) {
          _selectedDateTimes.add(currentDate);
        } else {
          _selectedDateTimes.remove(currentDate);
        }
      } else if (widget.selectionType == SelectionType.range) {
        if (!_selectRangeIsComplete) {
          var dateDiff = _selectedDateTimes[0].difference(currentDate).inDays;
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

        _selectRangeIsComplete = !_selectRangeIsComplete;
      }

      setState(() {});
    }
  }

  void _setPage({int page}) {
    /// for initial set
    if (page == null) {
      int year = (DateTime.now().year / 12).floor();

      DateTime date0 = DateTime((year - 1) * 12);
      DateTime date1 = DateTime(year * 12);
      DateTime date2 = DateTime((year + 1) * 12);

      this.setState(() {
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        int year = (dates[0].year / 12).floor();
        dates[2] = DateTime((year + 1) * 12);
        dates[1] = DateTime(year * 12);
        dates[0] = DateTime((year - 1) * 12);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        int year = (dates[2].year / 12).floor();
        dates[0] = DateTime((year - 1) * 12);
        dates[1] = DateTime(year * 12);
        dates[2] = DateTime((year + 1) * 12);
        page = page - 1;
      }

      this.setState(() {
        this._pageDates = dates;
      });

      /// animate to page right away after reset the values
      _pageCtrl.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }
  }

  /// an open method for [MonthCalendar] to trigger whenever it itself changes
  /// its year value
  void setYear(int year) {
    int pageYear = (year / 12).floor();

    List<DateTime> dates = List(3);
    dates[0] = DateTime((pageYear - 1) * 12);
    dates[1] = DateTime(pageYear * 12);
    dates[2] = DateTime((pageYear + 1) * 12);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  void updateSelectedDateTimes(List<DateTime> selectedDateTimes) {
    setState(() {
      _selectedDateTimes = selectedDateTimes;
    });
  }

  /// get boxes size by index
  Rect getBoxRectFromIndex(int index) => boxRects[index];
}
