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
import 'package:productivity_tracker/blocs/filtered_sessions/filtered_sessions_cubit.dart';
import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/router.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/widgets/bottom_sheets/confirmation_modal.dart';
import 'package:productivity_tracker/widgets/bottom_sheets/text_input_modal.dart';
import 'package:productivity_tracker/widgets/sessions_list_item.dart';

class ProjectOverviewScreen extends StatefulWidget {
  final Project project;

  ProjectOverviewScreen({Key key, @required this.project}) : super(key: key);

  @override
  _ProjectOverviewScreenState createState() => _ProjectOverviewScreenState(
        project: project,
      );
}

class _ProjectOverviewScreenState extends State<ProjectOverviewScreen> {
  Project project;

  _ProjectOverviewScreenState({@required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showTextInputModal(
                context: context,
                title: "Edit Project",
                label: "Name",
                initial: project.name,
              ).then((name) {
                if (project.name != name && name != null) {
                  // Project name updated
                  setState(() {
                    project = project.copyWith(name: name);
                    BlocProvider.of<ProjectsBloc>(context).add(ProjectUpdated(
                      project: project,
                    ));
                  });
                }
              });
            },
          ),
          PopupMenuButton(
            onSelected: (_) {
              showConfirmationDialog(
                context: context,
                message: "Delete ${project.name}?",
              ).then((value) {
                if (value) {
                  BlocProvider.of<ProjectsBloc>(context).add(ProjectDeleted(
                    project: project,
                  ));
                  Navigator.pop(context);
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "",
                child: Text("Delete"),
              )
            ],
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => FilteredSessionsCubit(
            projectFilter: project,
            sessionsBloc: BlocProvider.of<SessionsBloc>(context),
          ),
          child: _SessionsListView(),
        ),
      ),
    );
  }
}

class _SessionsListView extends StatelessWidget {
  void _handleEditSession(BuildContext context, Session session) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouter.editSessionRoute,
      arguments: EditSessionRouteArguments(session: session),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredSessionsCubit, FilteredSessionsState>(
      builder: (context, state) {
        if (state is FilteredSessionsLoadInProgress) {
          return Container(child: Text('Loading...'));
        } else if (state is FilteredSessionsLoadSuccess) {
          final sessions = state.filteredSessions;
          sessions.sort((s1, s2) {
            return s2.start.compareTo(s1.start);
          });
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) => SessionsListItem(
              session: sessions[index],
              showProjectName: false,
              onTap: () => _handleEditSession(context, sessions[index]),
            ),
          );
        } else {
          return Container(child: Text('Failed to load projects'));
        }
      },
    );
  }
}
