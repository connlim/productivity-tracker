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
import 'package:productivity_tracker/screens/homepage.dart';
import 'package:productivity_tracker/themes.dart';
import 'package:productivity_tracker/utils/database.dart';
import 'package:provider/provider.dart';

final db = Database();
void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => db.projectDao),
        Provider(create: (_) => db.sessionDao),
      ],
      child: MaterialApp(
        title: 'Productivity Tracker',
        theme: lightTheme,
        home: HomePage(title: 'Productivity Tracker'),
      ),
    );
  }
}
