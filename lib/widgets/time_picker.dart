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
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

Future<DateTime> showCustomTimePicker({
  @required BuildContext context,
  @required DateTime initialTime,
}) async {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => _CustomTimePickerDialog(
      initialTime: initialTime,
    ),
  );
}

class _CustomTimePickerDialog extends StatefulWidget {
  final DateTime initialTime;

  _CustomTimePickerDialog({Key key, @required this.initialTime})
      : super(key: key);

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<_CustomTimePickerDialog> {
  DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Time'),
      content: TimePickerSpinner(
        time: _selectedTime,
        is24HourMode: false,
        isShowSeconds: true,
        isForce2Digits: true,
        alignment: Alignment.center,
        itemHeight: 50.0,
        normalTextStyle: TextStyle(fontSize: 18, color: Colors.grey[600]),
        highlightedTextStyle: TextStyle(fontSize: 26),
        onTimeChange: (time) {
          setState(() {
            _selectedTime = time;
          });
        },
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: Text('SAVE'),
          onPressed: () {
            Navigator.of(context).pop(_selectedTime);
          },
        ),
      ],
    );
  }
}
