// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_theming.dart';
import '../themes/blueprint_theme.dart';

ThemeData createTheme(Color color, Brightness brightness) {
  return blueprintTheme(
    ColorScheme.fromSeed(
      seedColor: color,
      brightness: brightness,
    ),
  );
}

ThemeData getTheme(AppColor appColor, Brightness brightness) =>
    switch (appColor) {
      AppColor.blue => createTheme(
          AppColor.blue.color,
          brightness,
        ),
      AppColor.teal => createTheme(
          AppColor.teal.color,
          brightness,
        ),
      AppColor.pastelBlue => createTheme(
          AppColor.pastelBlue.color,
          brightness,
        ),
      AppColor.pastelTeal => createTheme(
          AppColor.pastelTeal.color,
          brightness,
        ),
      AppColor.pastelOcean => createTheme(
          AppColor.pastelOcean.color,
          brightness,
        ),
    };

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../api/v1/date_summary/grand_total.dart';
// import '../api/v2/all_time_stats/all_time_stats_model.dart';
// import '../enums/settings_enums.dart';
// import '../models/project_model.dart';
// import '../providers/settings_providers.dart';

// String formatDate(DateTime date) => DateFormat('EEE, MMM d').format(date);

// /// add selected duration format in shared preferences
// Future writeDurationFormat(DurationFormat durationFormat) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   log(
//     '$durationFormat',
//     name: 'helper_functions.dart:writeDurationFormat',
//   );
//   prefs.setString('durationFormat', '$durationFormat');
// }

/// add selected date format in shared preferences
Future writeAppearance(Appearance appearance) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('appearance', '$appearance');
  log(
    '$appearance',
    name: 'helper_functions.dart:appearance',
  );
}

// /// read selected date format from shared preferences
// /// and set it as the current date format
// Future readDurationFormat(WidgetRef ref) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? durationFormat = prefs.getString('durationFormat');
//   if (durationFormat != null) {
//     ref.read(durationFormatProvider.notifier).state =
//         DurationFormat.values.firstWhere(
//       (e) => e.toString() == durationFormat,
//     );
//   }
//   // log(
//   //   durationFormat ?? 'null',
//   //   name: 'helper_functions.dart:readDurationFormat',
// }

Future readAppearance(Appearance appearance) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString('appearance');
  if (value != null) {
    appearance = Appearance.values.firstWhere(
      (e) => e.toString() == value,
    );
  }
  log(
    value ?? 'null',
    name: 'helper_functions.dart:readAppearance',
  );
}

// Future writeHourlyRate(double hourlyRate) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   log(
//     '$hourlyRate',
//     name: 'helper_functions.dart:writeHourlyRate',
//   );
//   prefs.setDouble('hourlyRate', hourlyRate);
// }

// Future readHourlyRate(WidgetRef ref) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   double? hourlyRate = prefs.getDouble('hourlyRate');
//   if (hourlyRate != null) {
//     ref.read(hourlyRateProvider.notifier).state = hourlyRate;
//   }
//   // log(
//   //   hourlyRate?.toString() ?? 'null',
//   //   name: 'helper_functions.dart:readHourlyRate',
//   // );
// }

// String projectDurationFormat({
//   required DurationFormat durationFormat,
//   required ProjectModel projectModel,
//   required double hourlyRate,
// }) {
//   String subtitleString = projectModel.project.decimal ?? '0';
//   switch (durationFormat) {
//     case DurationFormat.currency:
//       double price = double.parse(subtitleString) * hourlyRate;
//       subtitleString = NumberFormat.simpleCurrency(
//         decimalDigits: 2,
//         name: 'EUR',
//       ).format(price);
//       break;
//     case DurationFormat.decimal:
//       subtitleString = '${projectModel.project.decimal} hours';
//       break;
//     case DurationFormat.digital:
//       subtitleString = '${projectModel.project.digital}';
//       break;
//     case DurationFormat.text:
//       subtitleString = '${projectModel.project.text}';
//       break;
//     default:
//       subtitleString = '${projectModel.project.text}';
//       break;
//   }
//   // log(projectModel.toString(), name: 'helper_functions.dart:duration');
//   return subtitleString;
// }

// String grandTotalDurationFormat({
//   required DurationFormat durationFormat,
//   required GrandTotal grandTotal,
//   required double hourlyRate,
// }) {
//   String subtitleString = grandTotal.decimal ?? '0';
//   switch (durationFormat) {
//     case DurationFormat.currency:
//       double price = double.parse(subtitleString) * hourlyRate;
//       subtitleString = NumberFormat.simpleCurrency(
//         decimalDigits: 2,
//         name: 'EUR',
//       ).format(price);
//       break;
//     case DurationFormat.decimal:
//       subtitleString = '${grandTotal.decimal} hours';
//       break;
//     case DurationFormat.digital:
//       subtitleString = '${grandTotal.digital}';
//       break;
//     case DurationFormat.text:
//       subtitleString = '${grandTotal.text}';
//       break;
//     default:
//       subtitleString = '${grandTotal.text}';
//       break;
//   }
//   // log(projectModel.toString(), name: 'helper_functions.dart:duration');
//   return subtitleString;
// }

// String allTimeDurationFormat({
//   required DurationFormat durationFormat,
//   required AllTimeStatsModel allTimeStatsModel,
//   required double hourlyRate,
// }) {
//   String subtitleString = allTimeStatsModel.decimal ?? '0';
//   switch (durationFormat) {
//     case DurationFormat.currency:
//       double price = double.parse(subtitleString) * hourlyRate;
//       subtitleString = NumberFormat.simpleCurrency(
//         decimalDigits: 2,
//         name: 'EUR',
//       ).format(price);
//       break;
//     case DurationFormat.decimal:
//       subtitleString = '${allTimeStatsModel.decimal} hours';
//       break;
//     case DurationFormat.digital:
//       subtitleString = '${allTimeStatsModel.digital}';
//       break;
//     case DurationFormat.text:
//       subtitleString = '${allTimeStatsModel.text}';
//       break;
//     default:
//       subtitleString = '${allTimeStatsModel.text}';
//       break;
//   }
//   // log(projectModel.toString(), name: 'helper_functions.dart:duration');
//   return subtitleString;
// }

// DateTime cleanDate(DateTime date) {
//   return DateTime(date.year, date.month, date.day);
// }
