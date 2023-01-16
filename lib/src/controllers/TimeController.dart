import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeController {
  /// calculateTime
  ///
  /// Función para calcular el porcentaje entre el presente año y el siguiente
  ///
  calculateTime() {
    final microseconds_year = 31556952000000;
    var present_year = DateTime.now();
    var diff1 = DateTime.now()
        .difference(DateTime(present_year.year, 1, 1))
        .inMicroseconds;
    return (diff1 / microseconds_year * 100);
  }
}
