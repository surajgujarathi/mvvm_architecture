import 'package:flutter/cupertino.dart';

String convertToKMB(numValue) {
  String resultValue = '0';
  if (numValue > 999 && numValue < 99999) {
    resultValue = "${(numValue / 1000).toStringAsFixed(2)} K";
  } else if (numValue > 99999 && numValue < 999999) {
    resultValue = "${(numValue / 1000000).toStringAsFixed(2)} M";
  } else if (numValue > 999999 && numValue < 999999999) {
    resultValue = "${(numValue / 1000000).toStringAsFixed(2)} M";
  } else if (numValue > 999999999) {
    resultValue = "${(numValue / 1000000000).toStringAsFixed(2)} B";
  } else {
    resultValue = numValue.toString();
  }
  debugPrint('convertToKMB ==> $numValue $resultValue');
  return resultValue;
}
