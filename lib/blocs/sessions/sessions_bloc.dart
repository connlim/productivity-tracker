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
import 'package:productivity_tracker/db/tables/sessions.dart';

part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionDao sessionDao;

  SessionsBloc({this.sessionDao}) : super(SessionsLoadInProgress()) {
    this
        .sessionDao
        .watchAllSessions()
        .listen((sessions) => add(SessionsLoaded()));
  }

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
    } else if (event is SessionStarted) {
      yield* _mapSessionStartedToState(event);
    } else if (event is SessionEnded) {
      yield* _mapSessionEndedToState(event);
    }
  }

  Stream<SessionsState> _mapSessionsLoadedToState() async* {
    try {
      final sessions = await this.sessionDao.getAllSessions();
      yield SessionsLoadSuccess(
        sessions: sessions,
        inProgressSession: null,
      );
    } catch (_) {
      yield SessionsLoadFailure();
    }
  }

  Stream<SessionsState> _mapSessionAddedToState(SessionAdded event) async* {
    if (state is SessionsLoadSuccess) {
      final successState = (state as SessionsLoadSuccess);
      final session = await sessionDao.createAndInsertSession(
        start: event.session.start,
        end: event.session.end,
        notes: event.session.notes,
        projectId: event.session.projectId,
      );
      final List<Session> updatedSessions = [session] + successState.sessions;
      yield SessionsLoadSuccess(
        sessions: updatedSessions,
        inProgressSession: successState.inProgressSession,
      );
    }
  }

  Stream<SessionsState> _mapSessionUpdatedToState(SessionUpdated event) async* {
    if (state is SessionsLoadSuccess) {
      final successState = (state as SessionsLoadSuccess);
      List<Session> updatedSessions;
      Session newInProgressSession;

      // Check if the new session is the in progress session
      if (event.session.id == successState.inProgressSession?.id) {
        // Only update the in progress session
        updatedSessions = successState.sessions;
        newInProgressSession = event.session;
      } else {
        // Only update the list of sessions
        updatedSessions = successState.sessions.map(
          (session) {
            return session.id == event.session.id ? event.session : session;
          },
        ).toList();
        newInProgressSession = successState.inProgressSession;
      }

      yield SessionsLoadSuccess(
        sessions: updatedSessions,
        inProgressSession: newInProgressSession,
      );
      sessionDao.updateSession(event.session);
    }
  }

  Stream<SessionsState> _mapSessionDeletedToState(SessionDeleted event) async* {
    if (state is SessionsLoadSuccess) {
      final successState = (state as SessionsLoadSuccess);
      final List<Session> updatedSessions = successState.sessions
          .where((session) => session.id != event.session.id)
          .toList();
      yield SessionsLoadSuccess(
        sessions: updatedSessions,
        inProgressSession: successState.inProgressSession,
      );
      sessionDao.deleteSession(event.session);
    }
  }

  Stream<SessionsState> _mapSessionStartedToState(SessionStarted event) async* {
    if (state is SessionsLoadSuccess) {
      yield SessionsLoadSuccess(
        sessions: (state as SessionsLoadSuccess).sessions,
        inProgressSession: Session(id: null, start: event.start),
      );
    }
  }

  Stream<SessionsState> _mapSessionEndedToState(SessionEnded event) async* {
    if (state is SessionsLoadSuccess) {
      final successState = (state as SessionsLoadSuccess);
      final inProgressSession = successState.inProgressSession;
      final newSession = await sessionDao.createAndInsertSession(
        start: inProgressSession.start,
        end: event.end,
        notes: inProgressSession.notes,
        projectId: inProgressSession.projectId,
      );
      yield SessionsLoadSuccess(
        sessions: successState.sessions + [newSession],
        inProgressSession: null,
      );
    }
  }
}
