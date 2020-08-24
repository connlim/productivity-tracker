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

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableSessions = 'sessions';
final String columnId = '_id';
final String columnStart = 'start';
final String columnEnd = 'end';

class SessionModel extends ChangeNotifier {
  List<Session> _items;

  List<Session> get sessions => _items;
  int get count => _items.length;

  final Future<Database> _database = openDatabase(
    'sessions.db',
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE sessions($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnStart TEXT, $columnEnd TEXT)',
      );
    },
  );

  SessionModel() {
    Sqflite.devSetDebugModeOn();
    _retrieveDatabase().then(
      (List<Session> value) {
        _items = value;
        notifyListeners();
      },
    );
  }

  Session getSession(int index) {
    return _items[index];
  }

  Future<Session> addSession(Session session) async {
    _items.add(session);

    notifyListeners();

    return _insertDatabase(session);
  }

  Future<bool> removeSession(Session session) async {
    bool returnValue = _items.remove(session);
    notifyListeners();

    _removeDatabase(session);

    return returnValue;
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Session>> _retrieveDatabase() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(tableSessions);
    return List.generate(
      maps.length,
      (i) => Session(
        id: maps[i][columnId],
        start: DateTime.parse(maps[i][columnStart]),
        end: DateTime.parse(maps[i][columnEnd]),
      ),
    );
  }

  Future<Session> _insertDatabase(Session session) async {
    final Database db = await _database;
    session.id = await db.insert(
      tableSessions,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return session;
  }

  Future<void> _updateDatabase(Session session) async {
    final Database db = await _database;
    await db.update(
      tableSessions,
      session.toMap(),
      where: '$columnId = ?',
      whereArgs: [session.id],
    );
  }

  Future<void> _removeDatabase(Session session) async {
    if (session.id == null) return;

    final Database db = await _database;
    await db.delete(
      tableSessions,
      where: '$columnId = ?',
      whereArgs: [session.id],
    );
  }
}

class Session {
  int id;
  DateTime start, end;

  Duration get duration => end.difference(start);

  Session({this.id, this.start, this.end});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnStart: start.toIso8601String(),
      columnEnd: end.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  String toString() {
    return 'Start: ${start.toString()}. End: ${end.toString()}. Duration: $duration';
  }
}
