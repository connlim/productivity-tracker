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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/db/database.dart';

class ProjectSelector extends StatefulWidget {
  final void Function(Project newProject) onSelectionChange;
  final Project initialSelection;

  ProjectSelector(
      {@required this.onSelectionChange, Key key, this.initialSelection})
      : super(key: key);

  @override
  _ProjectSelectorState createState() =>
      _ProjectSelectorState(initialSelection);
}

class _ProjectSelectorState extends State<ProjectSelector> {
  Project _selectedProject;

  _ProjectSelectorState(this._selectedProject);

  Widget _buildDropDown() {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoadSuccess) {
          return DropdownButton<Project>(
            value: _selectedProject,
            hint: Text('Select Project'),
            icon: Icon(Icons.arrow_drop_down_circle),
            isExpanded: true,
            onChanged: (newProject) => setState(() {
              _selectedProject = newProject;
              widget.onSelectionChange(newProject);
            }),
            items: state.projects
                .map(
                  (project) => DropdownMenuItem(
                    value: project,
                    child: Text(project.name),
                  ),
                )
                .toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: _buildDropDown(),
          ),
        ),
      ],
    );
  }
}
