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
import 'package:productivity_tracker/models/sessions.dart';
import 'package:productivity_tracker/screens/overview.dart';
import 'package:productivity_tracker/themes.dart';
import 'package:productivity_tracker/widgets/timer.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: HomePage(title: 'Productivity Tracker'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var sessionModel = SessionModel();

  void _onTimerStopped(DateTime start, DateTime end) {
    sessionModel.addSession(Session(start: start, end: end));
  }

  void _deleteCallback(Session session) {
    sessionModel.removeSession(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TimerWidget(
              onTimerStopped: _onTimerStopped,
            ),
            Expanded(
              child: ChangeNotifierProvider.value(
                value: sessionModel,
                child: Overview(_deleteCallback),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
