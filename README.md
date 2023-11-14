# TimeMachineStatus

This app is a simple status bar app that shows the status of Time Machine backups. It is still in early development and I'm open for suggestions and contributions.

> **Info**
> It can be downloaded from the [Releases Section](https://github.com/lukepistrol/TimeMachineStatus/releases/latest)

![Header](https://github.com/lukepistrol/TimeMachineStatus/assets/9460130/c0c89b5a-cf47-434a-891d-16c874f0ae16)

## Download

TimeMachineStatus is currently available for download in the [Releases Section](https://github.com/lukepistrol/TimeMachineStatus/releases/latest).

After downloading it once it can be updated from within the app.

A download using homebrew is [planned](https://github.com/lukepistrol/TimeMachineStatus/issues/10) (hit me up if you want to set this up).

## Roadmap

- [x] Show current status of Time Machine
- [x] Show time of last backup
- [x] Show time of next backup (if any)
- [x] List all backup volumes
- [x] Allow to start a backup (automatic volume selection)
- [x] Allow to start a backup manually (select volume)
- [x] Stop a running backup
- [x] Show progress of running backup
- [x] Launch Time Machine
- [x] Launch app at login
- [ ] Improve displayed information in menu bar
- [ ] Schedule backups (instead of hourly backups)
- [ ] Schedule backups on a per volume basis

## Contributing

If you want to contribute to this project, please have a look at the [open issues](https://github.com/lukepistrol/TimeMachineStatus/issues) and let me know which one you want to 
work on. If you have an idea for additional features, please open a [new issue](https://github.com/lukepistrol/TimeMachineStatus/issues/new/choose) first so we can discuss it.

> Please do not create pull requests for new features without discussing it first.

## Development Setup

Currently it is only possible to run the app by building it from source using `Xcode 15`. To do so, clone the repository
and open the project in Xcode.

> **Warning**
> Make sure that you change the signing team in all targets to your own, otherwise the `Full Disk Access` permission does not persist
> between app launches.

Then simply run the app using the `Run` button in Xcode.

## License

See LICENSE.md file in the root of the file tree.
