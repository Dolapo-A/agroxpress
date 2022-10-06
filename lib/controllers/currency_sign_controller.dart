import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getCurrency() {
  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'GHS ');
  // print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
  // print("CURRENCY NAME ${format.currencyName}"); // USD
  return format.currencySymbol;
}
