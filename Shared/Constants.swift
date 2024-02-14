//
//  Constants.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

// swiftlint:disable line_length force_unwrapping
enum Constants {
    enum Sizes {
        static let popoverWidth: Double = 360
        static let settingsWidth: Double = 375
    }

    enum URLs {
        static let timeMachinePreferencesPlist = URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist")
        static let settingsFullDiskAccess: URL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
        static let timeMachineSystemSettings: URL = URL(string: "x-apple.systempreferences:com.apple.Time-Machine-Settings.extension")!
        static let authorURL: URL = URL(string: "https://lukaspistrol.com")!

        static let bugReport: URL = URL(string: "https://github.com/lukepistrol/TimeMachineStatus/issues/new/choose")!
        static let issues: URL = URL(string: "https://github.com/lukepistrol/TimeMachineStatus/issues")!

        static let githubSponsor: URL = URL(string: "https://github.com/sponsors/lukepistrol")!
        static let buymeacoffee: URL = URL(string: "http://buymeacoffee.com/lukeeep")!

        static var timeMachineApp: URL? {
            URL(filePath: "/Applications/Time Machine.app")
        }
    }

    enum Commands {
        static func startBackup(id: UUID? = nil) -> String {
            if let id {
                return "tmutil startbackup -d \(id.uuidString)"
            }
            return "tmutil startbackup"
        }
        static let stopBackup: String = "tmutil stopbackup"
        static let status: String = "tmutil status | tail -n +2"
        static let launchTimeMachine = "open -n \"/System/Applications/Time Machine.app\" --args -AppCommandLineArg"
    }

    enum BundleIds {
        static let main = "com.lukaspistrol.TimeMachineStatus"
        static let helper = "com.lukaspistrol.TimeMachineStatusHelper"
    }
}
// swiftlint:enable line_length force_unwrapping
