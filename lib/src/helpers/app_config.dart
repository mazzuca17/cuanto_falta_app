import 'package:flutter/material.dart';

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  /// Una función constructora. Se llama cuando se instancia la clase.
  ///
  /// Args:
  ///   _context: El contexto del widget.
  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  /// `appHeight`
  ///
  /// Args:
  ///   v (double): El valor a convertir.
  ///
  /// Returns:
  ///   La altura de la pantalla multiplicada por el valor pasado.
  double appHeight(double v) {
    return _height * v;
  }

  ///
  /// Args:
  ///   v (double): El valor que desea convertir.
  ///
  /// Returns:
  ///   El ancho de la pantalla multiplicado por el valor pasado.
  double appWidth(double v) {
    return _width * v;
  }

  ///
  /// Args:
  ///   v (double): El valor a convertir.
  ///
  /// Returns:
  ///   El valor devuelto es el heightPadding multiplicado por el valor pasado.
  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  ///
  /// Args:
  ///   v (double): El valor que desea convertir.
  ///
  /// Returns:
  ///   Un doble valor.
  double appHorizontalPadding(double v) {
    // int.parse(settingRepo.setting.mainColor.replaceAll("#", "0xFF"));
    return _widthPadding * v;
  }
}

/// Es una clase que devuelve un color basado en una cadena.
class Colors {
  ///
  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color mainColor(double opacity) {
    try {
      return Color(int.parse(
              settingRepo.setting.value.mainColor.replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color secondColor(double opacity) {
    try {
      return Color(int.parse(
              settingRepo.setting.value.secondColor.replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color accentColor(double opacity) {
    try {
      return Color(int.parse(
              settingRepo.setting.value.accentColor.replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color mainDarkColor(double opacity) {
    try {
      return Color(int.parse(
              settingRepo.setting.value.mainDarkColor.replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color secondDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.secondDarkColor
              .replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color accentDarkColor(double opacity) {
    try {
      return Color(
        int.parse(
          settingRepo.setting.value.accentDarkColor.replaceAll("#", "0xFF"),
        ),
      ).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  /// Args:
  ///   opacity (double): La opacidad del color.
  ///
  /// Returns:
  ///   Un objeto Color con la opacidad establecida en el valor pasado.
  Color scaffoldColor(double opacity) {
    // TODO test if brightness is dark or not
    try {
      return Color(
        int.parse(
          settingRepo.setting.value.scaffoldColor.replaceAll("#", "0xFF"),
        ),
      ).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }
}
