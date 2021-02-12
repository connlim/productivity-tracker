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
import 'package:productivity_tracker/screens/overview_screen.dart';
import 'package:productivity_tracker/screens/projects_list_screen.dart';
import 'package:productivity_tracker/tab_item.dart';
import 'package:productivity_tracker/theme/styles.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  static int currentTab = 0;

  final List<TabItem> tabs = [
    TabItem(
      title: "Overview",
      icon: Icons.home,
      defaultPage: OverviewScreen(),
    ),
    TabItem(
      title: "Projects",
      icon: Icons.list,
      defaultPage: ProjectsListScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, tabitem) {
      tabitem.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentTabNotPopped =
            !await tabs[currentTab].navigatorKey.currentState.maybePop();
        if (currentTabNotPopped && currentTab != 0) {
          setState(() => currentTab = 0);
          return false;
        }
        return currentTabNotPopped;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: currentTab,
          items: tabs
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.title,
                ),
              )
              .toList(),
          onTap: (int index) {
            setState(() {
              currentTab = index;
            });
          },
        ),
      ),
    );
  }
}
