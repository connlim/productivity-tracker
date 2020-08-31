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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/utils/date_utils.dart';
import 'package:productivity_tracker/widgets/select_project_modal.dart';
import 'package:productivity_tracker/widgets/themed_fab.dart';
import 'package:productivity_tracker/widgets/timer.dart';

class EditSessionScreen extends StatefulWidget {
  static const String _title = "Edit Session";
  final Session session;

  EditSessionScreen({Key key, @required this.session}) : super(key: key);

  @override
  _EditSessionScreenState createState() {
    return _EditSessionScreenState(session.end == null);
  }
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  DateTime _start, _end;
  Project _selectedProject;
  final bool sessionInProgress;

  _EditSessionScreenState(this.sessionInProgress);

  @override
  void initState() {
    super.initState();

    _start = widget.session.start;
    _end = widget.session.end;

    var projectsBlocState = BlocProvider.of<ProjectsBloc>(context).state;
    if (projectsBlocState is ProjectsLoadSuccess)
      _selectedProject = projectsBlocState.getProject(widget.session.projectId);
  }

  void _onDelete() {
    BlocProvider.of<SessionsBloc>(context).add(
      SessionDeleted(session: widget.session),
    );
    Navigator.pop(context);
  }

  void _onSave() {
    final updatedSession = Session(
      id: widget.session.id,
      start: _start,
      end: sessionInProgress ? null : _end,
      projectId: _selectedProject?.id,
    );
    BlocProvider.of<SessionsBloc>(context).add(
      SessionUpdated(
        session: updatedSession,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildContent() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          sessionInProgress
              ? Container()
              : Text(
                  formatTimerDuration(_end.difference(_start)),
                  style: Theme.of(context).textTheme.headline3,
                ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _DateTimeItem(
                  title: 'Start',
                  date: _start,
                  onNewDateTime: (newDateTime) => setState(() {
                    _start = newDateTime;
                  }),
                ),
                if (!sessionInProgress)
                  _DateTimeItem(
                    title: 'End',
                    date: _end,
                    onNewDateTime: (newDateTime) => setState(() {
                      _end = newDateTime;
                    }),
                  ),
                Text(_selectedProject?.name ?? "No Project Selected"),
                FlatButton(
                  child: Text('Choose Project'),
                  onPressed: () {
                    showModalBottomSheet<Project>(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) => SelectProjectModal(),
                    ).then((project) {
                      if (project != null) {
                        setState(() {
                          _selectedProject = project;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EditSessionScreen._title),
        actions: [
          if (!sessionInProgress)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _onDelete,
            ),
        ],
      ),
      body: widget.session == null ? Container() : _buildContent(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ThemedFAB(
        iconData: Icons.save,
        title: 'Save',
        onTap: _onSave,
      ),
    );
  }
}

class _DateTimeItem extends StatelessWidget {
  const _DateTimeItem({
    Key key,
    @required this.title,
    @required this.date,
    @required this.onNewDateTime,
  }) : super(key: key);

  final String title;
  final DateTime date;
  final void Function(DateTime p1) onNewDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () => showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
              lastDate: DateTime.parse("3000-01-01"),
            ).then((newDateTime) {
              if (newDateTime != null) {
                onNewDateTime(
                  DateTime(
                    newDateTime.year,
                    newDateTime.month,
                    newDateTime.day,
                    date.hour,
                    date.minute,
                    date.second,
                  ),
                );
              }
            }),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                DateFormat.MMMd().format(date),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () => showTimePicker(
              context: context,
              helpText: 'Select new time',
              confirmText: 'SAVE',
              initialTime: TimeOfDay.fromDateTime(date),
            ).then((timeOfDay) {
              if (timeOfDay != null) {
                onNewDateTime(
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    timeOfDay.hour,
                    timeOfDay.minute,
                    date.second,
                  ),
                );
              }
            }),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                DateFormat.jms().format(date),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
