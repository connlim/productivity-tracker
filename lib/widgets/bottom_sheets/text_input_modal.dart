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
import 'package:productivity_tracker/widgets/bottom_sheets/bottom_sheet_globals.dart';

Future<String> showTextInputModal({
  @required BuildContext context,
  @required String title,
  String label,
  String initial,
}) {
  return showModalBottomSheet<String>(
    context: context,
    shape: bottomSheetShape,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => _TextInputModal(
      title: title,
      label: label,
      initial: initial,
    ),
  );
}

class _TextInputModal extends StatefulWidget {
  final String title;
  final String label;
  final String initial;

  _TextInputModal({@required this.title, this.label, this.initial});

  @override
  _TextInputModalState createState() => _TextInputModalState();
}

class _TextInputModalState extends State<_TextInputModal> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initial);
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
          BottomSheetTitle(title: widget.title, showHandle: false),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.label,
              ),
            ),
          ),
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
                  Navigator.pop<String>(context, _controller.text);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
