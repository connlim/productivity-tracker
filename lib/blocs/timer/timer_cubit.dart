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

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final Ticker ticker;
  final SessionsBloc sessionsBloc;

  StreamSubscription _tickerSubscription;
  StreamSubscription sessionsSubscription;

  TimerCubit({@required this.ticker, @required this.sessionsBloc})
      : assert(ticker != null),
        super(TimerRunStopped()) {
    sessionsSubscription = sessionsBloc.listen((sessionState) {
      if (sessionState is SessionsLoadSuccess) {
        final sessionStart = sessionState.inProgressSession.start;
        if (sessionStart != state.start) {
          emit(TimerRunInProgress(
            sessionStart,
            DateTime.now().difference(sessionStart).inSeconds,
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    sessionsSubscription.cancel();
    return super.close();
  }

  void startTimer() {
    final start = DateTime.now();
    emit(TimerRunInProgress(start, 0));
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker.tick().listen(
          (x) => emit(
            TimerRunInProgress(
              state.start,
              state.duration + 1,
            ),
          ),
        );
    sessionsBloc.add(SessionStarted(start: start));
  }

  void stopTimer() {
    _tickerSubscription?.cancel();
    sessionsBloc.add(
      SessionEnded(end: state.start.add(Duration(seconds: state.duration))),
    );
    emit(TimerRunStopped());
  }

  // void setStartTime(DateTime start) {
  //   if (state is TimerRunInProgress) {
  //     emit(TimerRunInProgress(start, state.duration));
  //   }
  // }
}

class Ticker {
  Stream tick() {
    return Stream.periodic(Duration(seconds: 1));
  }
}
