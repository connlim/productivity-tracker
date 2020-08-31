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
import 'package:intl/intl.dart';
import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/utils/date_utils.dart';

class SessionsListItem extends StatelessWidget {
  final void Function() onTap;
  final Session session;
  final bool showProjectName;
  final bool showDividers;
  final bool isFirstItem;

  SessionsListItem({
    Key key,
    this.showProjectName = true,
    this.showDividers = true,
    this.isFirstItem = false,
    @required this.session,
    @required this.onTap,
  }) : super(key: key);

  String _formatStartEndDates(DateTime start, DateTime end) {
    final String startText =
        DateFormat.MMMd().addPattern('jm', ', ').format(session.start);

    String endText;
    if (end == null) {
      endText = 'Present';
    } else if (start.day != end.day ||
        start.month != end.month ||
        start.year != end.year) {
      // Start and end date fall on different days
      // Add month and day to the end text
      endText = DateFormat.MMMd().addPattern('jm', ', ').format(session.end);
    } else {
      endText = DateFormat.jm().format(session.end);
    }
    return '$startText – $endText';
  }

  @override
  Widget build(BuildContext context) {
    final borderSide = Divider.createBorderSide(
      context,
      color: Colors.grey[300],
    );
    final bool showingProject = showProjectName && session.projectId != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: isFirstItem ? borderSide : BorderSide.none,
          bottom: borderSide,
        ),
      ),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30.0,
            showingProject ? 20.0 : 22.0,
            30.0,
            showingProject ? 20.0 : 22.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showingProject) ...[
                    _BuildProjectName(session: session),
                    const SizedBox(height: 5.0),
                  ],
                  Text(_formatStartEndDates(session.start, session.end)),
                ],
              ),
              session.end != null
                  ? Text(formatTimerDuration(
                      session.end.difference(session.start),
                    ))
                  : Text(
                      'In Progress',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildProjectName extends StatelessWidget {
  final Session session;

  _BuildProjectName({@required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoadSuccess) {
          return Text(
            state.getProject(session.projectId).name,
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.ellipsis,
          );
        }
        return Container();
      },
    );
  }
}
