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

part 'filtered_sessions_state.dart';

class FilteredSessionsCubit extends Cubit<FilteredSessionsState> {
  final Project projectFilter;
  final SessionsBloc sessionsBloc;
  StreamSubscription sessionsSubscription;

  FilteredSessionsCubit({
    @required this.projectFilter,
    @required this.sessionsBloc,
  }) : super(FilteredSessionsLoadInProgress()) {
    // Initial update of current projects filter
    final currentState = sessionsBloc.state;
    if (currentState is SessionsLoadSuccess) {
      _updateFilteredProjects(currentState.sessions);
    }
    // Subscribe for future changes
    sessionsSubscription = sessionsBloc.listen((state) {
      if (state is SessionsLoadSuccess) {
        _updateFilteredProjects(state.sessions);
      }
    });
  }

  void _updateFilteredProjects(List<Session> newSessions) {
    final filteredSessions = newSessions
        .where(
          (session) => session.projectId == projectFilter.id,
        )
        .toList();
    emit(FilteredSessionsLoadSuccess(filteredSessions: filteredSessions));
  }

  @override
  Future<void> close() {
    sessionsSubscription.cancel();
    return super.close();
  }
}
