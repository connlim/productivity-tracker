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

abstract class SessionsEvent extends Equatable {
  const SessionsEvent();

  @override
  List<Object> get props => [];
}

class SessionsLoaded extends SessionsEvent {}

class SessionAdded extends SessionsEvent {
  final Session session;

  const SessionAdded(this.session);

  @override
  List<Object> get props => [session];
}

class SessionUpdated extends SessionsEvent {
  final Session session;

  const SessionUpdated({@required this.session});

  @override
  List<Object> get props => [session];
}

class SessionDeleted extends SessionsEvent {
  final Session session;

  const SessionDeleted({@required this.session});

  @override
  List<Object> get props => [session];
}

class SessionStarted extends SessionsEvent {
  final DateTime start;

  const SessionStarted({@required this.start});

  @override
  List<Object> get props => [start];
}

class SessionEnded extends SessionsEvent {
  final DateTime end;

  const SessionEnded({@required this.end});

  @override
  List<Object> get props => [end];
}
