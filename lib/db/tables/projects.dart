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

part 'projects.g.dart';

enum Status {
  none,
  pending,
  inprogress,
  completed,
}

const Map<Status, String> StatusName = {
  Status.none: "",
  Status.pending: "Pending",
  Status.inprogress: "In Progress",
  Status.completed: "Completed",
};

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get status => intEnum<Status>()();
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

  Future<Project> createAndInsertProject({
    @required String name,
    @required Status status,
  }) {
    return insertProject(
      ProjectsCompanion(
        name: Value(name),
        status: Value(status),
      ),
    ).then(
      (id) {
        return Project(
          id: id,
          name: name,
          status: status,
        );
      },
    );
  }
}
