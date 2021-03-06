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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productivity_tracker/app.dart';
import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/blocs/timer/timer_cubit.dart';
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/db/database.dart';

final db = Database();
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SessionsBloc(
            sessionDao: db.sessionDao,
          )..add(SessionsLoaded()),
        ),
        BlocProvider(
          create: (context) => ProjectsBloc(
            projectDao: db.projectDao,
          )..add(ProjectsLoaded()),
        ),
        BlocProvider(
          create: (context) => TimerCubit(
            ticker: Ticker(),
            sessionsBloc: BlocProvider.of<SessionsBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Productivity Tracker',
        theme: lightTheme,
        home: App(),
        onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      ),
    );
  }
}
