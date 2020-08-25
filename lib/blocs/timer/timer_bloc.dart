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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker ticker;
  final SessionsBloc sessionsBloc;
  DateTime _startTime;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required this.ticker, @required this.sessionsBloc})
      : assert(ticker != null),
        super(TimerInitial());

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerStopped) {
      yield* _mapTimerStoppedToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    _startTime = DateTime.now();
    yield TimerRunInProgress(0);
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker
        .tick(ticks: 0)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerStoppedToState(TimerStopped stop) async* {
    _tickerSubscription?.cancel();
    yield TimerInitial();
    sessionsBloc.add(SessionAdded(Session(
      id: null,
      start: _startTime,
      end: _startTime.add(
        Duration(seconds: stop.duration),
      ),
    )));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield TimerRunInProgress(tick.duration);
  }
}

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks + x + 1);
  }
}
