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
import 'package:productivity_tracker/router.dart';
import 'app.dart';

class TabItem {
  final String title;
  final IconData icon;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int index = 0;
  Widget defaultPage;

  TabItem({
    @required this.title,
    @required this.icon,
    @required this.defaultPage,
  });

  Widget get page {
    return Visibility(
      visible: index == AppState.currentTab,
      maintainState: true,
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return AppRouter.generateRoute(settings, defaultPage);
        },
      ),
    );
  }
}
