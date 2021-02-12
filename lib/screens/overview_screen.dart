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
import 'package:productivity_tracker/blocs/timer/timer_cubit.dart';
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/widgets/sessions_list.dart';
import 'package:productivity_tracker/widgets/themed_fab.dart';
import 'package:productivity_tracker/widgets/timer.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  Timer timer;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    timer = Timer();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        title: Text('Overview'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
                margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFDDDDDD),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      alignment: Alignment.center,
                      child: timer,
                    ),
                    SizedBox(height: 10.0),
                    FlatButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Create Session'),
                      onPressed: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(
                        AppRouter.createSessionRoute,
                      ),
                    ),
                  ],
                ),
              ),
              _SessionsListView(scrollController),
            ],
          ),
        ),
      ),
      floatingActionButton: _TimerControlFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SessionsListView extends StatelessWidget {
  final ScrollController scrollController;

  _SessionsListView(this.scrollController);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        if (state is SessionsLoadInProgress) {
          return Container(child: Text('Loading...'));
        } else if (state is SessionsLoadSuccess) {
          final sessions = state.allSessions;
          return SessionsList(
            sessions: sessions,
            scrollController: scrollController,
          );
        } else {
          return Container(child: Text('Failed'));
        }
      },
    );
  }
}

class _TimerControlFAB extends StatelessWidget {
  Widget _buildFAB({
    @required void Function() onTap,
    @required bool isStarted,
  }) {
    return ThemedFAB(
      title: isStarted ? 'Stop Timer' : 'Start Timer',
      iconData: isStarted ? Icons.stop : Icons.play_arrow,
      backgroundColor: isStarted ? Colors.red : Colors.green,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        final TimerState state = BlocProvider.of<TimerCubit>(context).state;
        if (state is TimerRunStopped) {
          return _buildFAB(
            isStarted: false,
            onTap: () => BlocProvider.of<TimerCubit>(context).startTimer(),
          );
        } else if (state is TimerRunInProgress) {
          return _buildFAB(
            isStarted: true,
            onTap: () {
              BlocProvider.of<TimerCubit>(context).stopTimer();
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
