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

class SessionsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (context, index) => ListTile(
              title: Text(
                sessions[index].toString(),
              ),
              onTap: () => BlocProvider.of<SessionsBloc>(context)
                  .add(SessionDeleted(session: sessions[index])),
            ),
          );
        } else {
          return Container(child: Text('Failed'));
        }
      },
    );
  }
}
