# Productivity Tracker

Open-source [Flutter](https://flutter.dev/) app to track your productivity throughout the day. This app is still under active development. **It is not yet ready to be used as a daily driver.**

## Screenshots
<img src="https://github.com/connlim/productivity-tracker/raw/master/screenshots/overview_screen.jpg" width="400px">&nbsp;<img src="https://github.com/connlim/productivity-tracker/raw/master/screenshots/edit_session_screen.jpg" width="400px">
<img src="https://github.com/connlim/productivity-tracker/raw/master/screenshots/projects_screen.jpg" width="400px">&nbsp;<img src="https://github.com/connlim/productivity-tracker/raw/master/screenshots/project_sessions_screen.jpg" width="400px">

## Features
* Timer you can run to track your session in real time
* Ability to edit timer start time while it is running (trust me, you *will* forget to start the timer at some point)
* Sessions can span across multiple days (useful if you work past midnight)
* View a list of all your sessions
* Edit session timings and linked project
* Organize sessions by projects

### Planned Features
- [x] Add support for per-session notes (to detail what you did in each session)
- [x] Add new session records without having to start the timer
- [x] Edit project details
- [x] Change create session to outline button
- [ ] See total time spent on each project
- [x] Colored dots next to project name for better differentiation
- [ ] Progress states: pending, in progress, completed
- [x] Make timer stand out from background
- [ ] Change color scheme
- [ ] Add more symbols
- [ ] Organize projects by tags (e.g. programming tag: flutter app, java, web dev)
- [ ] Track changes in productivity between days and weeks

- [ ] Background service
- [ ] Export and import data
- [ ] F-Droid release

## Development
You need to install [Flutter](https://flutter.dev/) on your system first.
```bash
flutter pub get # get packages

flutter run # run in debug mode
```

If you change any files in `/lib/db/`, be sure to run the following command to rebuild the generated files:
```bash
flutter packages pub run build_runner build
```
