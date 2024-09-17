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
import Logging
import ShellOut

@MainActor
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

    deinit {
        timer?.invalidate()
    }

    func start(force: Bool = false) {
        timer?.invalidate()
        let timeInterval: TimeInterval = isIdle && !force ? 15 : force ? 0 : 2
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task {
                async let update: Void = self.updateStatus()
                async let read: Void = self.readPreferences()

                _ = await [update, read]
            }
        }
    }

    private func updateStatus() {
        do {
            status = try BackupState.getState()
            log.trace("Got state: \(status.statusString)")
            start(force: status is BackupState.None)
        } catch {
            log.error("Error updating status: \(error)")
            self.error = UserfacingError.debugError(error: error)
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
            } else {
                self.error = UserfacingError.debugError(error: error)
            }
        }
    }

    func startBackup(id: UUID? = nil) {
        do {
            if let id {
                log.info("Starting backup with id: \(id)")
                let result = try shellOut(to: Constants.Commands.startBackup(id: id))
                log.trace("Started backup: \(result)")
            } else {
                log.info("Starting backup")
                let result = try shellOut(to: Constants.Commands.startBackup())
                log.trace("Started backup: \(result)")
            }
            start(force: true)
        } catch {
            log.error("Error starting backup: \(error)")
        }
    }

    func stopBackup() {
        do {
            log.info("Stopping backup")
            let result = try shellOut(to: Constants.Commands.stopBackup)
            log.trace("Stopped backup: \(result)")
            start(force: true)
        } catch {
            log.error("Error stopping backup: \(error)")
        }
    }

    func launchTimeMachine() {
        do {
            log.info("Launching time machine")
            let result = try shellOut(to: Constants.Commands.launchTimeMachine)
            log.trace("Launched time machine: \(result)")
        } catch {
            log.error("Error launching time machine: \(error)")
        }
    }
}
