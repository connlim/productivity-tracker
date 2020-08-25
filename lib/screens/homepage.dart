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
import 'package:moor/moor.dart' hide Column;
import 'package:productivity_tracker/utils/database.dart';
import 'package:productivity_tracker/widgets/project_creator.dart';
import 'package:productivity_tracker/widgets/project_selector.dart';
import 'package:productivity_tracker/widgets/timer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Project _selectedProject;

  void _onTimerStopped(DateTime start, DateTime end) {
    final sessionDao = Provider.of<SessionDao>(context, listen: false);
    final session = SessionsCompanion(
      start: Value(start),
      end: Value(end),
      project: Value(_selectedProject?.id),
    );
    sessionDao.insertSession(session);
  }

  StreamBuilder<List<Session>> _buildSessionsList(BuildContext context) {
    final sessionDao = Provider.of<SessionDao>(context);
    return StreamBuilder(
      stream: sessionDao.watchAllSessions(),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? List();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: sessions.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              sessions[index].toString(),
            ),
            onTap: () => sessionDao.deleteSession(sessions[index]),
          ),
        );
      },
    );
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
            ProjectSelector(),
            ProjectCreator(),
            Expanded(
              child: _buildSessionsList(context),
            ),
          ],
        ),
      ),
    );
  }
}
