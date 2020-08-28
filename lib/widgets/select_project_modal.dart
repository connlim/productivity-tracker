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
import 'package:productivity_tracker/theme/styles.dart';

class SelectProjectModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 350.0,
        maxHeight: 750.0,
      ),
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoadInProgress) {
            return Container(child: Text('Loading...'));
          } else if (state is ProjectsLoadSuccess) {
            final projects = state.projects;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: OutlineButton(
                    child: Text('Create New Project'),
                    onPressed: () => showModalBottomSheet<String>(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => CreateProjectModal(),
                    ).then((String name) {
                      if (name != null) {
                        BlocProvider.of<ProjectsBloc>(context)
                            .add(ProjectCreated(name));
                      }
                    }),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return ProjectListItem(
                      project: projects[index],
                      onTap: () => Navigator.pop<Project>(
                        context,
                        projects[index],
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Container(child: Text('Error Loading Projects'));
          }
        },
      ),
    );
  }
}

class ProjectListItem extends StatelessWidget {
  final void Function() onTap;
  final Project project;

  ProjectListItem({Key key, @required this.project, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        child: Text(
          project.name,
          style: Theme.of(context).textTheme.subtitle1,
          softWrap: true,
        ),
      ),
    );
  }
}

class CreateProjectModal extends StatefulWidget {
  @override
  _CreateProjectModalState createState() => _CreateProjectModalState();
}

class _CreateProjectModalState extends State<CreateProjectModal> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        10.0,
        20.0,
        10.0,
        MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create New Project',
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Project name',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  Navigator.pop<String>(context, _controller.text);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
