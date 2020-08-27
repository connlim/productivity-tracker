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

part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsLoadInProgress extends ProjectsState {}

class ProjectsLoadSuccess extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoadSuccess([this.projects = const []]);

  Project getProject(int id) {
    if (projects.length == 0) return null;
    return projects.firstWhere((project) => project.id == id, orElse: null);
  }

  @override
  List<Object> get props => [Projects];
}

class ProjectsLoadFailure extends ProjectsState {}
