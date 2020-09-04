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

/// Shows a bottomsheet menu list with a title and items.
///
/// Returns a [Future] for the selected [MenuListItem.value]
Future<T> showMenuList<T>({
  @required BuildContext context,
  @required String title,
  @required List<MenuListItem<T>> items,
}) {
  return showModalBottomSheet(
    context: context,
    shape: bottomSheetShape,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => _MenuListBottomSheet(title: title, items: items),
  );
}

class MenuListItem<T> extends StatelessWidget {
  final String title;
  final T value;

  MenuListItem({
    @required this.title,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop<T>(
        context,
        value,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}

class _MenuListBottomSheet extends StatelessWidget {
  final String title;
  final List<MenuListItem> items;

  _MenuListBottomSheet({@required this.title, @required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomSheetTitle(
          title: title,
          showHandle: true,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [...items],
          ),
        ),
      ],
    );
  }
}
