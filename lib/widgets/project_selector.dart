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
import 'package:productivity_tracker/db/database.dart';
import 'package:provider/provider.dart';

class ProjectSelector extends StatefulWidget {
  @override
  _ProjectSelectorState createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  Project _selectedProject;
  StreamBuilder<List<Project>> _buildDropDown(BuildContext context) {
    final projectDao = Provider.of<ProjectDao>(context);
    return StreamBuilder(
      stream: projectDao.watchAllProjects(),
      builder: (context, snapshot) {
        final projects = snapshot.data ?? List();

        return DropdownButton<Project>(
          value: _selectedProject,
          hint: Text('Select Project'),
          icon: Icon(Icons.arrow_drop_down_circle),
          isExpanded: true,
          onChanged: (newProject) => setState(() {
            _selectedProject = newProject;
          }),
          items: projects
              .map(
                (project) => DropdownMenuItem(
                  value: project,
                  child: Text(project.name),
                ),
              )
              .toList(),
        );
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
            child: _buildDropDown(context),
          ),
        ),
      ],
    );
  }
}
