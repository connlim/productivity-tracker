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

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class ProjectsLoaded extends ProjectsEvent {}

class ProjectCreated extends ProjectsEvent {
  final String name;
  final Status status;

  const ProjectCreated(this.name, [this.status = Status.none]);

  @override
  List<Object> get props => [name];
}

class ProjectAdded extends ProjectsEvent {
  final Project project;

  const ProjectAdded(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectUpdated extends ProjectsEvent {
  final Project project;

  const ProjectUpdated({@required this.project});

  @override
  List<Object> get props => [project];
}

class ProjectDeleted extends ProjectsEvent {
  final Project project;

  const ProjectDeleted({@required this.project});

  @override
  List<Object> get props => [project];
}
