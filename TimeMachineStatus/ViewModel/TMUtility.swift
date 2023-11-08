//
//  TMUtility.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import Foundation
import ShellOut
import Logging

class TMUtility: ObservableObject {
    @Published var status: BackupState._State = BackupState.None()
    @Published var preferences: Preferences?
    @Published var lastUpdated: Date?

    let log = Logger(label: "com.lukaspistrol.TimeMachineStatus.TMUtility")

    var isIdle: Bool { !status.running }

    private var timer: Timer?

    init() {
        readPreferences()
        start(force: true)
    }

    func start(force: Bool = false) {
        timer?.invalidate()
        let timeInterval: TimeInterval = isIdle && !force ? 15 : force ? 0 : 2
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] timer in
            guard let self else { return }
            self.updateStatus()
            self.readPreferences()
        }
    }

    private func updateStatus() {
        do {
            status = try BackupState.getState()
            log.trace("Got state: \(status.statusString)")
            start(force: status is BackupState.None)
        } catch {
            log.error("Error updating status: \(error)")
            start(force: true)
        }
    }

    private func readPreferences() {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.TimeMachine.plist"))
            self.preferences = try decoder.decode(Preferences.self, from: data)
            log.trace("Got preferences: \(preferences.debugDescription)")
            lastUpdated = .now
        } catch {
            log.error("Error reading preferences: \(error)")
        }
    }

    func startBackup(id: UUID? = nil) {
        do {
            _ = if let id {
                try shellOut(to: "tmutil startbackup -d \(id.uuidString)")
            } else {
                try shellOut(to: "tmutil startbackup")
            }
            start(force: true)
        } catch {
            log.error("Error starting backup: \(error)")
        }
    }

    func stopBackup() {
        do {
            let response = try shellOut(to: "tmutil stopbackup")
            print(response)
            start(force: true)
        } catch {
            log.error("Error stopping backup: \(error)")
        }
    }
}
