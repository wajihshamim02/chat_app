
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class date_utis {
  static String getformattedtime({required BuildContext context, required String time}) {
    
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time) );
    return TimeOfDay.fromDateTime(date).format(context);
  }
}

