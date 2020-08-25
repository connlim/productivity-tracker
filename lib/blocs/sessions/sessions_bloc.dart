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

import 'package:productivity_tracker/db/database.dart';

part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionDao sessionDao;

  SessionsBloc({this.sessionDao}) : super(SessionsLoadInProgress());

  @override
  Stream<SessionsState> mapEventToState(SessionsEvent event) async* {
    if (event is SessionsLoaded) {
      yield* _mapSessionsLoadedToState();
    } else if (event is SessionAdded) {
      yield* _mapSessionAddedToState(event);
    } else if (event is SessionUpdated) {
      yield* _mapSessionUpdatedToState(event);
    } else if (event is SessionDeleted) {
      yield* _mapSessionDeletedToState(event);
    }
  }

  Stream<SessionsState> _mapSessionsLoadedToState() async* {
    try {
      final sessions = await this.sessionDao.getAllSessions();
      yield SessionsLoadSuccess(sessions);
    } catch (_) {
      yield SessionsLoadFailure();
    }
  }

  Stream<SessionsState> _mapSessionAddedToState(SessionAdded event) async* {
    if (state is SessionsLoadSuccess) {
      final session = await sessionDao.createAndInsertSession(
          event.session.start, event.session.end);
      final List<Session> updatedSessions =
          [session] + (state as SessionsLoadSuccess).sessions;
      yield SessionsLoadSuccess(updatedSessions);
    }
  }

  Stream<SessionsState> _mapSessionUpdatedToState(SessionUpdated event) async* {
    if (state is SessionsLoadSuccess) {
      final List<Session> updatedSessions =
          (state as SessionsLoadSuccess).sessions.map(
        (session) {
          return session.id == event.session.id ? event.session : session;
        },
      ).toList();
      yield SessionsLoadSuccess(updatedSessions);
      sessionDao.updateSession(event.session);
    }
  }

  Stream<SessionsState> _mapSessionDeletedToState(SessionDeleted event) async* {
    if (state is SessionsLoadSuccess) {
      final List<Session> updatedSessions = (state as SessionsLoadSuccess)
          .sessions
          .where((session) => session.id != event.session.id)
          .toList();
      yield SessionsLoadSuccess(updatedSessions);
      sessionDao.deleteSession(event.session);
    }
  }
}
