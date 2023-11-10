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

enum Constants {
    enum URLs {
        static let timeMachinePreferencesPlist = URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist")
        static let settingsFullDiskAccess: URL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
        static let authorURL: URL = URL(string: "https://lukaspistrol.com")!

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
}
