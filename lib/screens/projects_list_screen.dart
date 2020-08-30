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
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/screens/project_overview_screen.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/widgets/create_project_modal.dart';

class ProjectsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: SafeArea(
        child: _ProjectsListView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Create New Project'.toUpperCase()),
        icon: Icon(Icons.add),
        onPressed: () {
          return showModalBottomSheet<String>(
            context: context,
            shape: bottomSheetShape,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) => CreateProjectModal(),
          ).then(
            (String name) {
              if (name != null) {
                BlocProvider.of<ProjectsBloc>(context)
                    .add(ProjectCreated(name));
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ProjectsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoadInProgress) {
          return Container(child: Text('Loading...'));
        } else if (state is ProjectsLoadSuccess) {
          final projects = state.projects;
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) => _ProjectListItem(
              project: projects[index],
              onTap: () => Navigator.pushNamed(
                context,
                Router.projectOverviewRoute,
                arguments: projects[index],
              ),
            ),
          );
        } else {
          return Container(child: Text('Failed to load projects'));
        }
      },
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final void Function() onTap;
  final Project project;

  _ProjectListItem({Key key, @required this.project, @required this.onTap})
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
