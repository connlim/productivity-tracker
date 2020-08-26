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
import 'package:sprintf/sprintf.dart';

class Timer extends StatelessWidget {
  String _formatDuration(int duration) {
    return sprintf(
      "%02d:%02d:%02d",
      [duration ~/ 360, duration ~/ 60, duration % 60],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
        ticker: Ticker(),
        sessionsBloc: BlocProvider.of<SessionsBloc>(context),
      ),
      child: Column(
        children: [
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Text(
                _formatDuration(state.duration),
                style: Theme.of(context).textTheme.headline1,
              );
            },
          ),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) => _TimerControl(),
          ),
        ],
      ),
    );
  }
}

class _TimerControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _mapStateToControlButton(BlocProvider.of<TimerBloc>(context));
  }

  Widget _mapStateToControlButton(TimerBloc timerBloc) {
    final TimerState state = timerBloc.state;
    if (state is TimerInitial) {
      return RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Start Timer'),
            ),
          ],
        ),
        color: Colors.green,
        onPressed: () => timerBloc.add(TimerStarted()),
      );
    } else if (state is TimerRunInProgress) {
      return RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stop),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Stop Timer'),
            ),
          ],
        ),
        color: Colors.red,
        onPressed: () {
          timerBloc.add(TimerStopped(duration: state.duration));
        },
      );
    } else {
      return Container();
    }
  }
}
