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
import 'package:productivity_tracker/blocs/sessions/sessions_bloc.dart';
import 'package:productivity_tracker/db/database.dart';
import 'package:sprintf/sprintf.dart';

typedef OnSaveCallback = Function(
    {@required DateTime start, @required DateTime end});

class EditSessionScreen extends StatefulWidget {
  static const String _title = "Edit Session";

  final OnSaveCallback callback;
  final Session session;

  EditSessionScreen({Key key, @required this.session, @required this.callback})
      : super(key: key);

  @override
  _EditSessionScreenState createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  DateTime _start, _end;

  @override
  void initState() {
    super.initState();

    _start = widget.session?.start;
    _end = widget.session?.end;
  }

  String _formatDuration(Duration duration) {
    return sprintf(
      "%02d:%02d:%02d",
      [duration.inHours, duration.inMinutes % 60, duration.inSeconds % 60],
    );
  }

  Widget _dateTimeItem(
      String title, DateTime date, Function(DateTime) onNewDateTime) {
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
            onTap: () => showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
              lastDate: DateTime.parse("3000-01-01"),
            ),
            child: Ink(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  DateFormat.MMMd().format(date),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
          InkWell(
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
            child: Ink(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  DateFormat.jms().format(date),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _dateTimeItem(
            'Start',
            _start,
            (newDateTime) => setState(() {
              _start = newDateTime;
            }),
          ),
          _dateTimeItem(
            'End',
            _end,
            (newDateTime) => setState(() {
              _end = newDateTime;
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(EditSessionScreen._title),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.save),
            label: Text('SAVE'),
            onPressed: () {
              widget.callback(
                start: _start,
                end: _end,
              );
              Navigator.pop(context);
            },
          ),
          body: widget.session == null
              ? Container()
              : Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        _formatDuration(_end.difference(_start)),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      _buildDateField(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
