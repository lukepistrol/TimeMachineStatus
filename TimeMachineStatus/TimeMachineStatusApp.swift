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

import Logging
import LoggingOSLog
@_exported import SFSafeSymbols
import SwiftUI

@main
struct TimeMachineStatusApp: App {

    @AppStorage(StorageKeys.logLevel.id)
    private var logLevel: Logging.Logger.Level = StorageKeys.logLevel.default

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        LoggingSystem.bootstrap { [logLevel] id in
            var mpx = MultiplexLogHandler([
                LoggingOSLog(label: id)
            ])
            #if DEBUG
            mpx.logLevel = .trace
            #else
            mpx.logLevel = logLevel
            #endif
            return mpx
        }
    }

    var body: some Scene {
        initializeScene
        settingsScene
    }

    private var initializeScene: some Scene {
        WindowGroup {
            InitializeView(utility: appDelegate.utility)
        }
        .defaultSize(width: 300, height: 200)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
    }

    private var settingsScene: some Scene {
        Settings {
            SettingsView(
                updater: appDelegate.updaterController.updater,
                utility: appDelegate.utility
            )
        }
    }
}
