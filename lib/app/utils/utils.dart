import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:home_finder/models/home.dart';
import 'dart:math' as math;
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void switchTheme([String? theme]) {
    if (theme != null) {
      if (theme == 'light') {
        Get.changeTheme(ThemeData.light());
      } else {
        Get.changeTheme(ThemeData.dark());
      }
    } else {
      Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    }
  }

  static double deg2rad(double deg) {
    return deg * (math.pi / 180);
  }

  static double getDistanceFromLatLonInKm(LatLng latlng1, LatLng latlng2) {
    double lat1 = latlng1.latitude;
    double lon1 = latlng1.longitude;
    double lat2 = latlng2.latitude;
    double lon2 = latlng2.longitude;
    double R = 6371.0; // Radius of the earth in km
    double dLat = deg2rad(lat2 - lat1); // deg2rad below
    double dLon = deg2rad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = R * c; // Distance in km
    return d;
  }
}

Stream<List<T>> queryCollection<T>(
    CollectionReference<Map<String, dynamic>> collection,
    {Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
        queryBuilder,
    required T Function(Map<String, dynamic>) objectBuilder,
    int limit = -1,
    bool singleRecord = false}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().map((homeMapSnapshots) => homeMapSnapshots.docs
      .map<T>((snapshot) => objectBuilder(snapshot.data()))
      .toList());
}

extension FFStringExt on String {
  String maybeHandleOverflow({int? maxChars, String replacement = '...'}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;
}

String dateTimeFormat(String format, DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    return timeago.format(dateTime);
  }
  return DateFormat(format).format(dateTime);
}

String chatListItemTime(DateTime? datetime) {
  if (datetime == null) return '';
  final now = DateTime.now();
  if (datetime.year == now.year &&
      datetime.month == now.month &&
      datetime.day == now.day) {
    return datetime
        .toIso8601String()
        .split('T')[1]
        .split('.')[0]
        .substring(0, 5);
  }

  if (isYesterday(datetime)) return 'Yesterday';

  return timeago.format(datetime);
}

bool isToday(DateTime? date) {
  return DateUtils.isSameDay(date, DateTime.now());
}

bool isYesterday(DateTime? date) {
  if (date == null) return false;

  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && now.day > 1) {
    return date.day + 1 == now.day;
  }

  return (DateUtils.addDaysToDate(date, 1).day == now.day);
}

enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

String formatNumber(
  num value, {
  FormatType formatType = FormatType.compact,
  DecimalType decimalType = DecimalType.automatic,
  String? currency,
  bool toLowerCase = false,
  String? format,
  String? locale,
}) {
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          break;
        case DecimalType.commaDecimal:
          formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

DateTime get getCurrentTimestamp => DateTime.now();

DateTime? toDate(dynamic timestamp) {
  if (timestamp.runtimeType == DateTime) return timestamp as DateTime;
  if (timestamp == null) return null;

  final t = timestamp as Timestamp;

  return t.toDate();
}

extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);
  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

String formatMoneyValue(double value) {
  double normalizedValue;
  String suffix = '';
  if (value > 1000000000) {
    normalizedValue = value / 1000000000;
    suffix = 'B';
  } else if (value > 1000000) {
    normalizedValue = value / 1000000;
    suffix = 'M';
  } else if (value > 1000) {
    normalizedValue = value / 1000;
    suffix = 'K';
  } else
    normalizedValue = value;

  return "${normalizedValue.toStringAsFixed(0)}$suffix";
}

// Future launchURL(String url) async {
//   var uri = Uri.parse(url).toString();
//   try {
//     await launch(uri);
//   } catch (e) {
//     throw 'Could not launch $uri: $e';
//   }
// }

String getFileExtension(String filePathOrName, {bool fromFirebase = false}) {
  if (!fromFirebase)
    return filePathOrName.split(".").last;
  else
    return filePathOrName.split("?")[0].split(".").last;
}

bool isDocument(String filePathOrName, [fromFirebase = false]) {
  if (fromFirebase == true)
    return ["pdf", "docx", "doc"]
        .contains(filePathOrName.split("?")[0].split(".").last);
  return ["pdf", "docx", "doc"].contains(filePathOrName.split(".").last);
}

bool isVideo(String filePathOrName, {bool fromFirebase = false}) {
  final extension = getFileExtension(filePathOrName);

  return (['mp4', 'mkv', 'm4v', '3gp'].contains(extension.toLowerCase()));
}

bool searchString(String string1, String lstring) {
  string1 = string1.toLowerCase();
  lstring = lstring.toLowerCase();
  for (int n = 0; n < (lstring.length); n++) {
    if (lstring[n] == string1[0]) {
      if (n + (string1.length) - 1 < lstring.length) {
        // print(string1);
        // print(lstring.substring(n, n + (string1.length)));
        if (string1 == lstring.substring(n, n + (string1.length))) {
          return true;
        }
      }
    }
  }
  return false;
}

// List<Home> homeSearch({String query = "", required List<Home> collection}) {
//   List<Home> temp = [];
//   for (int n = 0; n < (collection.length); n++) {
//     if ((collection[n].name != null &&
//             searchString(query, collection[n].name!)) ||
//         (collection[n].description != null &&
//             searchString(query, collection[n].description!))) {
//       temp.add(collection[n]);
//     }
//   }
//   return temp;
// }
