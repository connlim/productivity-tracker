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

part of 'timer_cubit.dart';

abstract class TimerState extends Equatable {
  final DateTime start;
  final int duration;

  const TimerState(this.start, this.duration);

  @override
  List<Object> get props => [start, duration];
}

class TimerRunStopped extends TimerState {
  const TimerRunStopped() : super(null, 0);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(DateTime start, int duration)
      : super(start, duration);
}
