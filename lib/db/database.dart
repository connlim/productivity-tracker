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
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  IntColumn get projectId =>
      integer().nullable().customConstraint('NULL REFERENCES projects(id)')();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [Sessions, Projects], daos: [SessionDao, ProjectDao])
class Database extends _$Database {
  Database() : super(_openConnection()) {
    this.customStatement('PRAGMA foreign_keys = ON');
  }

  @override
  int get schemaVersion => 1;
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

  Future<Session> createAndInsertSession(DateTime start, DateTime end,
      [Project project]) {
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

@UseDao(tables: [Projects])
class ProjectDao extends DatabaseAccessor<Database> with _$ProjectDaoMixin {
  final Database db;

  ProjectDao(this.db) : super(db);

  Future<List<Project>> getAllProjects() => select(projects).get();
  Stream<List<Project>> watchAllProjects() => select(projects).watch();

  Future<int> insertProject(Insertable<Project> proj) =>
      into(projects).insert(proj);
  Future updateProject(Insertable<Project> proj) =>
      update(projects).replace(proj);
  Future deleteProject(Insertable<Project> proj) =>
      delete(projects).delete(proj);

  Future<Project> createAndInsertProject(String name) {
    return insertProject(
      ProjectsCompanion(
        name: Value(name),
      ),
    ).then(
      (id) {
        return Project(id: id, name: name);
      },
    );
  }
}
