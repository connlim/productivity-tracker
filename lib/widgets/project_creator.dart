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
import 'package:moor/moor.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/db/tables/projects.dart';
import 'package:provider/provider.dart';

class ProjectCreator extends StatefulWidget {
  @override
  _ProjectCreatorState createState() => _ProjectCreatorState();
}

class _ProjectCreatorState extends State<ProjectCreator> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDialog(context) {
    final projectDao = Provider.of<ProjectDao>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create new project'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            labelText: 'Project name',
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              projectDao.insertProject(
                ProjectsCompanion(
                  name: Value(_controller.text),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create New Project'),
      onPressed: () => _showDialog(context),
    );
  }
}
