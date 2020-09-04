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
import 'package:intl/intl.dart';

import 'package:productivity_tracker/widgets/large_flat_button.dart';

class EditableDate extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onDateChange;

  const EditableDate({
    @required this.date,
    @required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return LargeFlatButton(
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
