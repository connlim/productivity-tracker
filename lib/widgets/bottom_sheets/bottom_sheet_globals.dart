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

final RoundedRectangleBorder bottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  ),
);

class BottomSheetTitle extends StatelessWidget {
  final String title;
  final bool showHandle;

  BottomSheetTitle({@required this.title, @required this.showHandle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showHandle
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 4.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              )
            : Container(),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
