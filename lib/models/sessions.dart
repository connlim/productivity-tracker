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

import 'package:flutter/cupertino.dart';

class SessionsModel extends ChangeNotifier {
  List<Session> _items;

  SessionsModel() {
    _items = [
      new Session(DateTime.now(), DateTime.now().add(Duration(hours: 1))),
      new Session(DateTime.now(), DateTime.now().add(Duration(hours: 1))),
      new Session(DateTime.now(), DateTime.now().add(Duration(hours: 1))),
    ];
  }

  Session getSession(int index) {
    return _items[index];
  }

  int get count => _items.length;

  void addSession(Session session) {
    _items.add(session);

    notifyListeners();
  }

  bool removeSession(Session session) {
    bool returnValue = _items.remove(session);
    notifyListeners();
    return returnValue;
  }
}

class Session {
  DateTime start, end;

  Session.create(this.start);
  Session(this.start, this.end);

  Duration get duration => start.difference(end);

  String toString() {
    return 'Start: ${start.toString()}. End: ${end.toString()}';
  }
}
