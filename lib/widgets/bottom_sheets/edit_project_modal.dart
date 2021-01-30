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
import 'package:productivity_tracker/db/tables/projects.dart';
import 'package:productivity_tracker/widgets/bottom_sheets/bottom_sheet_globals.dart';
import 'package:tuple/tuple.dart';

Future<Tuple2<String, Status>> showEditProjectModal({
  @required BuildContext context,
  String initial,
  Status status,
}) {
  return showModalBottomSheet<Tuple2<String, Status>>(
    context: context,
    shape: bottomSheetShape,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => _EditProjectModal(
      initial: initial,
      status: status,
    ),
  );
}

class _EditProjectModal extends StatefulWidget {
  final String initial;
  final Status status;

  _EditProjectModal({this.initial, this.status});

  @override
  _EditProjectModalState createState() => _EditProjectModalState();
}

class _EditProjectModalState extends State<_EditProjectModal> {
  TextEditingController _controller;
  Status _dropdownValue;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initial);
    _dropdownValue = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        10.0,
        20.0,
        10.0,
        MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTitle(title: "Edit Project", showHandle: false),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: DropdownButton<Status>(
                value: _dropdownValue,
                onChanged: (Status newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items: Status.values.map<DropdownMenuItem<Status>>(
                  (Status value) {
                    return DropdownMenuItem<Status>(
                      value: value,
                      child: Text(StatusName[value]),
                    );
                  },
                ).toList(),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  Navigator.pop<Tuple2<String, Status>>(
                    context,
                    Tuple2<String, Status>(
                      _controller.text,
                      _dropdownValue,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
