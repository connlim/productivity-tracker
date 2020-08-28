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
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/widgets/timer.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({@required this.title});

  Widget _buildSessionsOverview() {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        if (state is SessionsLoadInProgress) {
          return Container(child: Text('Loading...'));
        } else if (state is SessionsLoadSuccess) {
          final sessions = state.sessions;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final Session session = sessions[index];
              return ListTile(
                title: Text(
                  session.toString(),
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  Router.editSessionRoute,
                  arguments: EditSessionRouteArguments(
                      session: session,
                      onSave: (start, end, project) {
                        final updatedSession = Session(
                          id: session.id,
                          start: start,
                          end: end,
                          projectId: project?.id,
                        );
                        BlocProvider.of<SessionsBloc>(context).add(
                          SessionUpdated(
                            session: updatedSession,
                          ),
                        );
                      },
                      onDelete: () {
                        BlocProvider.of<SessionsBloc>(context).add(
                          SessionDeleted(session: session),
                        );
                      }),
                ),
              );
            },
          );
        } else {
          return Container(child: Text('Failed'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Timer(),
            // ProjectSelector(),
            // ProjectCreator(),
            Expanded(
              child: _buildSessionsOverview(),
            ),
          ],
        ),
      ),
    );
  }
}
