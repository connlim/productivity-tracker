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

part of 'sessions_bloc.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object> get props => [];
}

class SessionsLoadInProgress extends SessionsState {}

class SessionsLoadSuccess extends SessionsState {
  final List<Session> sessions;

  const SessionsLoadSuccess([this.sessions = const []]);

  @override
  List<Object> get props => [sessions];
}

class SessionsLoadFailure extends SessionsState {}
