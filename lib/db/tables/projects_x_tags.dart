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

// part 'projects_x_tags.g.dart';

class ProjectsXTags extends Table {
  IntColumn get projectId =>
      integer().customConstraint('REFERENCES projects(id)')();
  IntColumn get tagId => integer().customConstraint('REFERENCES tags(id)')();

  @override
  Set<Column> get primaryKey => {projectId, tagId};
}
