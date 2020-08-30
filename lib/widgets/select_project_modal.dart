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
import 'package:productivity_tracker/widgets/bottomsheet_title.dart';
import 'package:productivity_tracker/widgets/create_project_modal.dart';

class SelectProjectModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        // Disable the glowing effect when user overscrolls modal
        overscroll.disallowGlow();
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => LayoutBuilder(
          builder: (context, constraint) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetTitle(
                  title: 'Select Project',
                  showHandle: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: _CreateProjectButton(),
                ),
                _ProjectsListView(scrollController: scrollController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateProjectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text('Create New Project'),
      onPressed: () => showModalBottomSheet<String>(
        context: context,
        shape: bottomSheetShape,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => CreateProjectModal(),
      ).then(
        (String name) {
          if (name != null) {
            BlocProvider.of<ProjectsBloc>(context).add(ProjectCreated(name));
          }
        },
      ),
    );
  }
}

class _ProjectsListView extends StatelessWidget {
  final ScrollController scrollController;

  _ProjectsListView({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoadInProgress) {
            return Container(child: Text('Loading...'));
          } else if (state is ProjectsLoadSuccess) {
            final projects = state.projects;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return _ProjectListItem(
                  project: projects[index],
                  onTap: () => Navigator.pop<Project>(
                    context,
                    projects[index],
                  ),
                );
              },
            );
          } else {
            return Container(child: Text('Error Loading Projects'));
          }
        },
      ),
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
      splashFactory: InkRipple.splashFactory,
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
