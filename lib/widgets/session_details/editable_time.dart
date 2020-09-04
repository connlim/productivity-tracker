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
import 'package:productivity_tracker/widgets/time_picker.dart';

class EditableTime extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onTimeChange;

  const EditableTime({
    @required this.date,
    @required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return LargeFlatButton(
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
