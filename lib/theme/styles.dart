// Copyright (C) 2020 Connor Lim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

final bottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);

final ThemeData lightTheme = _buildLightTheme();

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline3: base.headline2.copyWith(
      fontFamily: 'GoogleSans',
      fontWeight: FontWeight.normal,
    ),
    headline6: base.headline6.copyWith(
      fontFamily: 'GoogleSans',
    ),
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF1178d0);
  const Color primaryVariant = Color(0xFF004d9e);
  const Color secondaryColor = Color(0xFF00b0ff);

  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    primaryVariant: primaryVariant,
    secondary: secondaryColor,
  );

  final ThemeData base = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    accentColor: secondaryColor,
    splashFactory: InkRipple.splashFactory,
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
