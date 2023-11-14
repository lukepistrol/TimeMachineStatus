//
//  TimeMachineStatusApp.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI
import Logging
import LoggingOSLog

@main
struct TimeMachineStatusApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        LoggingSystem.bootstrap { id in
            var mpx = MultiplexLogHandler([
                LoggingOSLog(label: id)
            ])
            #if DEBUG
            mpx.logLevel = .trace
            #else
            mpx.logLevel = .info
            #endif
            return mpx
        }
    }

    var body: some Scene {

        /* The menu bar item and menu view are set up in AppDelegate */

        Settings {
            SettingsView(updater: appDelegate.updaterController.updater)
                .environmentObject(appDelegate.utility)
        }
    }
}
