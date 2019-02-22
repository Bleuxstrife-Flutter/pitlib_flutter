library pit_components;

import 'package:flutter/material.dart';
import 'package:pit_components/consts/textstyles.dart';

class PitComponents {
  static Color textFieldHintColor = Color(0xffa6a6a6);
  static Color textFieldLabelColor = Color(0xff777777);
  static Color textFieldBackgroundColor = Color(0xffffffff);
  static Color textFieldErrorColor = Color(0xffd81920);
  static Color textFieldBorderColor = Color(0xffa6a6a6);
  static Color textFieldLineColor = Color(0xffa6a6a6);
  static Color textFieldButtonColor = Color(0xfff4329a);
  static Color buttonTextColor = Color(0xffffffff);
  static Color buttonBackgroundColor = Color(0xfff4329a);
  static String datePickerTitle = "Pick your date";
  static String datePickerMarkedDatesTitle = "Marked date";
  static String loadingAssetName = "images/nemob_loading.gif";

  static Color datePickerDaysLabelColor = Color(0xff208e5d);
  static Color datePickerTodayTextColor = Color(0xffffffff);
  static Color datePickerTodayColor = Color(0xffff6378);
  static Color datePickerSelectedColor = Color(0xff9bf0ff);
  static Color datePickerSelectedTextColor = Color(0xffffffff);

  static Color datePickerWeekendColor = Color(0xffff235e);
  static Color datePickerWeekdayColor = Color(0xff44363a);
  static Color datePickerToolbarColor = Color(0xfff4329a);
  static Color datePickerHeaderColor = Color(0xfff4329a);

  static Color datePickerPrevDaysColor = Color(0xffa6a6a6);
  static Color datePickerNextDaysDaysColor = Color(0xffa6a6a6);
  static Color datePickerMarkedDaysDaysColor = Colors.blue;
  static Color datePickerBackgroundColor = Color(0xfff7f7f7);
  static Color datePickerBorderColor = Color(0xffa6a6a6);
  static Color datePickerHintColor = Color(0xffa6a6a6);
  static Color datePickerLabelColor = Color(0xff777777);
  static Color datePickerErrorColor = Color(0xffd81920);

  static Color radioButtonTitleColor = Colors.blueGrey;
  static Color radioButtonColor = Colors.blue;

  static Color badgeHeaderColor = Colors.orange;
  static Color badgeBodyColor = Color(0xffc7dbf9);

  static Color groupCheckTitleColor = Colors.blueGrey;
  static Color groupCheckCheckColor = Colors.blue;

  static Color expansionPanelRadioColor = Colors.blue;

  static Color chooserHintColor = Color(0xffa6a6a6);
  static Color chooserLabelColor = Color(0xff777777);
  static Color chooserBackgroundColor = Color(0xfff7f7f7);
  static Color chooserErrorColor = Color(0xffd81920);
  static Color chooserLineColor = Color(0xffa6a6a6);
  static Color chooserBorderColor = Color(0xffa6a6a6);

  static Color dropDownBackgroundColor = Color(0xffFDFDFD);

  static Color ratingBarColor = Color(0xffffc100);

  static Color lerpColor = Color(0xffD1D1D1);
  static Color selectedImagePreviewColor = Colors.orange;

  static String incrementPickerButtonName = "Save";

  static List<String> weekdaysArray = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
  static List<String> monthsArray = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static TextStyle getLabelTextStyle() {
    return fs11.merge(TextStyle(color: PitComponents.textFieldLabelColor));
  }
}
