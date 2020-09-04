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
import 'package:productivity_tracker/widgets/bottom_sheets/select_project_modal.dart';
import 'package:productivity_tracker/widgets/large_flat_button.dart';

class SelectableProject extends StatelessWidget {
  final Project selectedProject;
  final void Function(Project) onSelectionChange;

  SelectableProject({
    @required this.selectedProject,
    @required this.onSelectionChange,
  });

  @override
  Widget build(BuildContext context) {
    return LargeFlatButton(
      text: selectedProject?.name ?? "No Project Selected",
      onTap: () => showProjectSelector(context: context).then((project) {
        if (project != null) {
          onSelectionChange(project);
        }
      }),
    );
  }
}
