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
    @Published var error: UserfacingError?

    let log = Logger(label: "\(Bundle.identifier).TMUtility")

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
            let data = try Data(contentsOf: Constants.URLs.timeMachinePreferencesPlist)
            self.preferences = try decoder.decode(Preferences.self, from: data)
            log.trace("Got preferences: \(preferences.debugDescription)")
            lastUpdated = .now
            self.error = nil
        } catch {
            log.error("Error reading preferences: \(error)")
            if (error as NSError).code == 257 {
                self.error = UserfacingError.fullDiskPermissionDenied
            }
        }
    }

    func startBackup(id: UUID? = nil) {
        do {
            _ = if let id {
                try shellOut(to: Constants.Commands.startBackup(id: id))
            } else {
                try shellOut(to: Constants.Commands.startBackup())
            }
            start(force: true)
        } catch {
            log.error("Error starting backup: \(error)")
        }
    }

    func stopBackup() {
        do {
            let response = try shellOut(to: Constants.Commands.stopBackup)
            print(response)
            start(force: true)
        } catch {
            log.error("Error stopping backup: \(error)")
        }
    }

    func launchTimeMachine() {
        do {
            _ = try shellOut(to: Constants.Commands.launchTimeMachine)
        } catch {
            log.error("Error launching time machine: \(error)")
        }
    }
}
