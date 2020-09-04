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
import 'package:productivity_tracker/db/database.dart';
import 'package:productivity_tracker/screens/edit_session_screen.dart';
import 'package:productivity_tracker/screens/overview_screen.dart';
import 'package:productivity_tracker/screens/project_overview_screen.dart';
import 'package:productivity_tracker/screens/projects_list_screen.dart';

class EditSessionRouteArguments {
  final Session session;
  EditSessionRouteArguments({@required this.session});
}

class Router {
  static const String overviewRoute = '/overview';
  static const String editSessionRoute = '/session';
  static const String createSessionRoute = '/create_session';
  static const String projectsListRoute = '/projects';
  static const String projectOverviewRoute = '/project_overview';

  static Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: Duration(milliseconds: 160),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(0.5, 0.0);
        final end = Offset.zero;
        final curve = Curves.easeOut;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings,
      [Widget defaultPage]) {
    switch (settings.name) {
      case overviewRoute:
        return _createRoute(OverviewScreen());
      case editSessionRoute:
        EditSessionRouteArguments args =
            settings.arguments as EditSessionRouteArguments;
        return _createRoute(EditSessionScreen(session: args.session));
      case createSessionRoute:
        return _createRoute(EditSessionScreen.createSession());
      case projectsListRoute:
        return _createRoute(ProjectsListScreen());
      case projectOverviewRoute:
        Project project = settings.arguments as Project;
        return _createRoute(ProjectOverviewScreen(project: project));
      default:
        return _createRoute(
            defaultPage ?? Container(child: Text('No Route Found')));
    }
  }
}
