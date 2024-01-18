![Static Badge](https://img.shields.io/badge/14.0_Sonoma-orange?label=macOS&style=flat-square)
![GitHub release (with filter)](https://img.shields.io/github/v/release/lukepistrol/TimeMachineStatus?style=flat-square)
![Downloads](https://img.shields.io/github/downloads/lukepistrol/TimeMachineStatus/TimeMachineStatus.dmg?style=flat-square&logo=github&label=Downloads&color=green)

# TimeMachineStatus

This app is a simple status bar app that shows the status of Time Machine backups. It is still in early development and I'm open for suggestions and contributions.

> ⬇️ You can download TimeMachineStatus from [releases](https://github.com/lukepistrol/TimeMachineStatus/releases/latest) or using [homebrew](#homebrew).

![Header](https://github.com/lukepistrol/TimeMachineStatus/assets/9460130/cea44ed3-21ea-4f06-9916-69b76584c313)

## Download

There are multiple ways to download TimeMachineStatus listed below.

> Once installed the app can be updated by itself by selecting the _Check for uptades..._ button or by pressing `⌘ + U` while the popover is active.

### GitHub Releases

TimeMachineStatus is currently available for download in the [Releases Section](https://github.com/lukepistrol/TimeMachineStatus/releases/latest).

### Homebrew

You can also download TimeMachineStatus using the `brew` command:

```sh
brew install --cask timemachinestatus
```

## Features

* Show the current status in the menu bar
* List all backup destinations and detailed information about them
* Start a backup on a specific volume
* Customize the appearance of the menu bar item

## Roadmap

- [ ] Schedule backups (instead of hourly backups)
- [ ] Schedule backups on a per volume basis

## Contributing

If you want to contribute to this project, please have a look at the [open issues](https://github.com/lukepistrol/TimeMachineStatus/issues) and let me know which one you want to 
work on. If you have an idea for additional features, please open a [new issue](https://github.com/lukepistrol/TimeMachineStatus/issues/new/choose) first so we can discuss it.

> Please do not create pull requests for new features without discussing it first.

When submitting a pull request make sure you are on a feature branch in your fork. Pull requests from your main branch will be closed.

## Development Setup

Currently it is only possible to run the app by building it from source using `Xcode 15`. To do so, clone the repository
and open the project in Xcode.

> **Warning**
> Make sure that you change the signing team in all targets to your own, otherwise the `Full Disk Access` permission does not persist
> between app launches.

Then simply run the app using the `Run` button in Xcode.

## License

See LICENSE.md file in the root of the file tree.

## Support Development

I develop this app in my free time and I would highly appreciate a donation to help me maintaining this project if you are able ❤️

You can either [buy me a coffee](http://buymeacoffee.com/lukeeep) or [sponsor me on GitHub](https://github.com/sponsors/lukepistrol)!
