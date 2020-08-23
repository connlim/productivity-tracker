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
import 'package:provider/provider.dart';
import 'package:productivity_tracker/models/timerService.dart';
import 'package:sprintf/sprintf.dart';

class TimerWidget extends StatefulWidget {
  final Function(DateTime, DateTime) onTimerStopped;
  TimerWidget({this.onTimerStopped});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool started = false;

  String _formatDuration(Duration duration) {
    return sprintf("%02d:%02d:%02d",
        [duration.inHours, duration.inMinutes % 60, duration.inSeconds % 60]);
  }

  void _stopTimer(TimerService timerService) {
    timerService.stop();
    widget.onTimerStopped(timerService.startTime, timerService.endTime);
    timerService.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerService(),
      builder: (context, widget) => Column(
        children: [
          Text(
            _formatDuration(context
                .select((TimerService service) => service.currentDuration)),
            style: Theme.of(context).textTheme.headline1,
          ),
          RaisedButton(
            child: Text(started ? 'Stop Timer' : 'Start Timer'),
            color: started ? Colors.red : Colors.green,
            onPressed: () {
              if (started)
                _stopTimer(context.read<TimerService>());
              else
                context.read<TimerService>().start();
              setState(() {
                started = !started;
              });
            },
          ),
        ],
      ),
    );
  }
}
