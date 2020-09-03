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
import 'package:productivity_tracker/widgets/time_picker.dart';

class EditSessionScreen extends StatefulWidget {
  static const String _title = "Edit Session";
  final Session session;

  EditSessionScreen({Key key, @required this.session}) : super(key: key);

  @override
  _EditSessionScreenState createState() {
    return _EditSessionScreenState(session.end == null);
  }
}

//TODO: Implement DateTime validation
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

  TableRow _buildDateTimeRow({
    @required String title,
    @required DateTime datetime,
    @required void Function(DateTime) onDateTimeChange,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        TableCell(
          child: _TimeWidget(
            date: datetime,
            onTimeChange: (newDateTime) => onDateTimeChange(newDateTime),
          ),
        ),
        TableCell(
          child: _DateWidget(
            date: datetime,
            onDateChange: (newDateTime) => onDateTimeChange(newDateTime),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sessionInProgress
            ? Container()
            : Text(
                formatTimerDuration(_end.difference(_start)),
                style: Theme.of(context).textTheme.headline2,
              ),
        Divider(height: 30.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 5.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Set Date and Time',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: 10.0),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                  2: IntrinsicColumnWidth(),
                },
                children: [
                  _buildDateTimeRow(
                      title: 'Start',
                      datetime: _start,
                      onDateTimeChange: (newDateTime) => setState(() {
                            _start = newDateTime;
                          })),
                  if (!sessionInProgress)
                    _buildDateTimeRow(
                      title: 'End',
                      datetime: _end,
                      onDateTimeChange: (newDateTime) => setState(() {
                        _end = newDateTime;
                      }),
                    )
                ],
              ),
            ],
          ),
        ),
        Divider(height: 30.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Project',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Prevent button from touching select project text
              SizedBox(width: 10.0),
              Flexible(
                fit: FlexFit.loose,
                child: _LargeFlatButton(
                  text: _selectedProject?.name ?? "No Project Selected",
                  onTap: () {
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
              ),
            ],
          ),
        ),
        Divider(height: 30.0),
      ],
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
      body: widget.session == null
          ? Container()
          : Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              child: _buildContent(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ThemedFAB(
        iconData: Icons.save,
        title: 'Save',
        onTap: _onSave,
      ),
    );
  }
}

class _DateWidget extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onDateChange;

  const _DateWidget({
    @required this.date,
    @required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return _LargeFlatButton(
      text: DateFormat.MMMd().format(date),
      onTap: () => showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
        lastDate: DateTime.parse("3000-01-01"),
      ).then((newDateTime) {
        if (newDateTime != null) {
          onDateChange(
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
    );
  }
}

class _TimeWidget extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onTimeChange;

  const _TimeWidget({
    @required this.date,
    @required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return _LargeFlatButton(
      text: DateFormat.jms().format(date),
      onTap: () => showCustomTimePicker(
        context: context,
        initialTime: date,
      ).then((newTime) {
        if (newTime != null) {
          onTimeChange(
            DateTime(
              date.year,
              date.month,
              date.day,
              newTime.hour,
              newTime.minute,
              newTime.second,
            ),
          );
        }
      }),
    );
  }
}

class _LargeFlatButton extends StatelessWidget {
  final String text;
  final void Function() onTap;

  _LargeFlatButton({@required this.text, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
