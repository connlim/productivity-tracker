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
import 'package:productivity_tracker/blocs/timer/timer_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/widgets/sessions_list_item.dart';
import 'package:productivity_tracker/widgets/themed_fab.dart';
import 'package:productivity_tracker/widgets/timer.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            timer,
            // ProjectSelector(),
            // ProjectCreator(),
            Expanded(
              child: _SessionsListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: _TimerControlFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SessionsListView extends StatelessWidget {
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
            itemBuilder: (context, index) {
              final Session session = sessions[index];
              return SessionsListItem(
                session: session,
                onTap: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  Router.editSessionRoute,
                  arguments: EditSessionRouteArguments(session: session),
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
}

class _TimerControlFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final TimerState state = BlocProvider.of<TimerBloc>(context).state;
        if (state is TimerInitial) {
          return _BuildTimerControlFAB(
            isStarted: false,
            onTap: () =>
                BlocProvider.of<TimerBloc>(context).add(TimerStarted()),
          );
        } else if (state is TimerRunInProgress) {
          return _BuildTimerControlFAB(
            isStarted: true,
            onTap: () {
              BlocProvider.of<TimerBloc>(context)
                  .add(TimerStopped(duration: state.duration));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildTimerControlFAB extends StatelessWidget {
  final void Function() onTap;
  final bool isStarted;

  _BuildTimerControlFAB({@required this.onTap, @required this.isStarted});

  @override
  Widget build(BuildContext context) {
    return ThemedFAB(
      title: isStarted ? 'Stop Timer' : 'Start Timer',
      iconData: isStarted ? Icons.stop : Icons.play_arrow,
      backgroundColor: isStarted ? Colors.red : Colors.green,
      onTap: onTap,
    );
  }
}
