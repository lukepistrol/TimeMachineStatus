# TimeMachineStatus

This app is a simple status bar app that shows the status of Time Machine backups. It is still in early development
and thus not available for download yet.

![Desktop Template - Dark](https://github.com/lukepistrol/TimeMachineStatus/assets/9460130/93561920-c242-4d0c-a999-fff6fd612fe7)

## Roadmap

- [x] Show current status of Time Machine
- [x] Show time of last backup
- [x] Show time of next backup (if any)
- [x] List all backup volumes
- [x] Allow to start a backup (automatic volume selection)
- [x] Allow to start a backup manually (select volume)
- [x] Stop a running backup
- [x] Show progress of running backup
- [ ] Schedule backups (instead of hourly backups)
- [ ] Schedule backups on a per volume basis
- [x] Launch Time Machine
- [ ] Launch app at login
- [ ] Improve displayed information in menu bar

## Contributing

If you want to contribute to this project, please have a look at the open issues and let me know which one you want to 
work on. If you have an idea for additional features, please open a new issue first so we can discuss it.

> Do not create pull requests for new features without discussing it first.

## Installing

Currently it is only possible to run the app by building it from source using `Xcode 15`. To do so, clone the repository
and open the project in Xcode.

> Make sure that you change the signing team to your own, otherwise the `Full Disk Access` permission does not persist
> between app launches.

Then simply run the app using the `Run` button in Xcode.

## License

See LICENSE.md file in the root of the file tree.
