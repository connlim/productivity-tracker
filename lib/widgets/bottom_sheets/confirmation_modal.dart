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

Future<bool> showConfirmationDialog({
  @required BuildContext context,
  @required String message,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    shape: bottomSheetShape,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => ConfirmationModal(message),
  );
}

class ConfirmationModal extends StatelessWidget {
  final String message;

  ConfirmationModal(this.message);

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
          BottomSheetTitle(title: message, showHandle: false),
          Padding(padding: EdgeInsets.all(20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop<bool>(context, false);
                },
              ),
              FlatButton(
                child: Text('Accept'),
                onPressed: () {
                  Navigator.pop<bool>(context, true);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
