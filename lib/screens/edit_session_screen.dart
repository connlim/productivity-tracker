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

import 'package:productivity_tracker/blocs/projects/projects_bloc.dart';
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/theme/styles.dart';
import 'package:productivity_tracker/utils/date_utils.dart';
import 'package:productivity_tracker/widgets/session_details/editable_date.dart';
import 'package:productivity_tracker/widgets/session_details/editable_time.dart';
import 'package:productivity_tracker/widgets/session_details/selectable_project.dart';
import 'package:productivity_tracker/widgets/themed_fab.dart';

class EditSessionScreen extends StatefulWidget {
  final String title;
  final Session session;
  final bool createNewSession;

  /// Screen for user to edit session details. Updates session model on save.
  ///
  /// [session] cannot be null.
  /// If [session.end] is [null], then the duration and end datetime fields
  /// will not be shown.
  /// If [createNewSession] is [true], a new session will be created instead of
  /// updating an existing one.
  EditSessionScreen({
    Key key,
    @required this.session,
  })  : assert(session != null),
        createNewSession = false,
        title = 'Edit Session',
        super(key: key);

  EditSessionScreen.createSession({Key key})
      : createNewSession = true,
        title = 'Create New Session',
        session = Session(id: null, start: DateTime.now(), end: DateTime.now()),
        super(key: key);

  @override
  _EditSessionScreenState createState() {
    return _EditSessionScreenState(session.end == null);
  }
}

//TODO: Implement DateTime validation
class _EditSessionScreenState extends State<EditSessionScreen> {
  DateTime _start, _end;
  Project _selectedProject;
  TextEditingController _textEditingController;
  final bool sessionInProgress;

  _EditSessionScreenState(this.sessionInProgress);

  @override
  void initState() {
    super.initState();

    _start = widget.session.start;
    _end = widget.session.end;
    _textEditingController = TextEditingController(text: widget.session.notes);

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
      end: _end,
      projectId: _selectedProject?.id,
      notes: _textEditingController.text,
    );
    BlocProvider.of<SessionsBloc>(context).add(
      widget.createNewSession
          ? SessionAdded(session: updatedSession)
          : SessionUpdated(session: updatedSession),
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
          child: EditableTime(
            date: datetime,
            onTimeChange: (newDateTime) => onDateTimeChange(newDateTime),
          ),
        ),
        TableCell(
          child: EditableDate(
            date: datetime,
            onDateChange: (newDateTime) => onDateTimeChange(newDateTime),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (!sessionInProgress && !widget.createNewSession)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _onDelete,
            ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              // Timer duration
              sessionInProgress
                  ? Container()
                  : Text(
                      formatTimerDuration(_end.difference(_start)),
                      style: Theme.of(context).textTheme.headline2,
                    ),
              Divider(height: 30.0),
              // Start and end times
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
              // Project Selector
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
                      child: SelectableProject(
                        selectedProject: _selectedProject,
                        onSelectionChange: (project) => setState(() {
                          _selectedProject = project;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                ),
              ),
              Divider(height: 30.0),
              SizedBox(height: 20.0),
            ],
          ),
        ),
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
