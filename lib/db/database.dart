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

import 'package:productivity_tracker/db/tables/sessions.dart';
import 'package:productivity_tracker/db/tables/projects.dart';
import 'package:productivity_tracker/db/tables/tags.dart';
import 'package:productivity_tracker/db/tables/projects_x_tags.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(
    tables: [Sessions, Projects, Tags, ProjectsXTags],
    daos: [SessionDao, ProjectDao])
class Database extends _$Database {
  Database() : super(_openConnection()) {
    this.customStatement('PRAGMA foreign_keys = ON');
  }

  @override
  int get schemaVersion => 1;
}
