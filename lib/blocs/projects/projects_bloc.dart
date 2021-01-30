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
import 'package:productivity_tracker/db/tables/projects.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectDao projectDao;

  ProjectsBloc({@required this.projectDao}) : super(ProjectsLoadInProgress());

  @override
  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async* {
    if (event is ProjectsLoaded) {
      yield* _mapProjectsLoadedToState();
    } else if (event is ProjectCreated) {
      yield* _mapProjectCreatedToState(event);
    } else if (event is ProjectAdded) {
      yield* _mapProjectAddedToState(event);
    } else if (event is ProjectUpdated) {
      yield* _mapProjectUpdatedToState(event);
    } else if (event is ProjectDeleted) {
      yield* _mapProjectDeletedToState(event);
    }
  }

  Stream<ProjectsState> _mapProjectsLoadedToState() async* {
    try {
      final projects = await this.projectDao.getAllProjects();
      yield ProjectsLoadSuccess(projects);
    } catch (_) {
      yield ProjectsLoadFailure();
    }
  }

  Stream<ProjectsState> _mapProjectCreatedToState(ProjectCreated event) async* {
    if (state is ProjectsLoadSuccess) {
      final project = await projectDao.createAndInsertProject(
        name: event.name,
        status: event.status,
      );
      final List<Project> updatedProjects =
          [project] + (state as ProjectsLoadSuccess).projects;
      yield ProjectsLoadSuccess(updatedProjects);
    }
  }

  Stream<ProjectsState> _mapProjectAddedToState(ProjectAdded event) async* {
    if (state is ProjectsLoadSuccess) {
      projectDao.insertProject(event.project);
      final List<Project> updatedProjects =
          [event.project] + (state as ProjectsLoadSuccess).projects;
      yield ProjectsLoadSuccess(updatedProjects);
    }
  }

  Stream<ProjectsState> _mapProjectUpdatedToState(ProjectUpdated event) async* {
    if (state is ProjectsLoadSuccess) {
      final List<Project> updatedProjects =
          (state as ProjectsLoadSuccess).projects.map(
        (project) {
          return project.id == event.project.id ? event.project : project;
        },
      ).toList();
      yield ProjectsLoadSuccess(updatedProjects);
      projectDao.updateProject(event.project);
    }
  }

  Stream<ProjectsState> _mapProjectDeletedToState(ProjectDeleted event) async* {
    if (state is ProjectsLoadSuccess) {
      final List<Project> updatedProjects = (state as ProjectsLoadSuccess)
          .projects
          .where((project) => project.id != event.project.id)
          .toList();
      yield ProjectsLoadSuccess(updatedProjects);
      projectDao.deleteProject(event.project);
    }
  }
}
