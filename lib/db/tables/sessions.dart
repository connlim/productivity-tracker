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
import 'package:moor/moor.dart';
import 'package:productivity_tracker/db/database.dart';

part 'sessions.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get projectId =>
      integer().nullable().customConstraint('NULL REFERENCES projects(id)')();
}

@UseDao(tables: [Sessions])
class SessionDao extends DatabaseAccessor<Database> with _$SessionDaoMixin {
  final Database db;

  SessionDao(this.db) : super(db);

  Future<List<Session>> getAllSessions() {
    return (select(sessions)
          ..orderBy(
            [
              (t) => OrderingTerm(expression: t.start, mode: OrderingMode.desc),
            ],
          ))
        .get();
  }

  Stream<List<Session>> watchAllSessions() {
    return (select(sessions)
          ..orderBy(
            [
              (t) => OrderingTerm(expression: t.start, mode: OrderingMode.desc),
            ],
          ))
        .watch();
  }

  Future<int> insertSession(Insertable<Session> s) => into(sessions).insert(s);
  Future updateSession(Insertable<Session> s) => update(sessions).replace(s);
  Future deleteSession(Insertable<Session> s) => delete(sessions).delete(s);

  Future<Session> createAndInsertSession(DateTime start,
      [DateTime end, Project project]) {
    return insertSession(
      SessionsCompanion(
        start: Value(start),
        end: Value(end),
      ),
    ).then(
      (id) {
        return Session(id: id, start: start, end: end);
      },
    );
  }
}
