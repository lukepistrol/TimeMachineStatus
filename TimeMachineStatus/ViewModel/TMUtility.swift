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
protocol TMUtility {
    var status: BackupState._State { get set }
    var preferences: Preferences? { get set }
    var lastUpdated: Date? { get set }
    var canReadPreferences: Bool { get }
    var error: UserfacingError? { get set }

    var isIdle: Bool { get }

    func start(force: Bool)
    func startBackup(id: UUID?)
    func stopBackup()
    func launchTimeMachine()
}

extension TMUtility {
    func startBackup() {
        startBackup(id: nil)
    }
}

@MainActor
@Observable
class TMUtilityMock: TMUtility {
    var status: BackupState._State = BackupState.None()
    var preferences: Preferences?
    var lastUpdated: Date?
    var error: UserfacingError?
    var canReadPreferences: Bool { _canReadPreferences }

    private var _canReadPreferences: Bool

    var isIdle: Bool { !status.running }

    init(
        status: BackupState._State = BackupState.None(),
        preferences: Preferences? = nil,
        lastUpdated: Date? = nil,
        error: UserfacingError? = nil,
        canReadPreferences: Bool = true
    ) {
        self.status = status
        self.preferences = preferences
        self.lastUpdated = lastUpdated
        self.error = error
        self._canReadPreferences = canReadPreferences
    }

    func start(force: Bool = false) {}

    func startBackup(id: UUID? = nil) {}

    func stopBackup() {}

    func launchTimeMachine() {}
}

@MainActor
@Observable
class TMUtilityImpl: TMUtility {
    var status: BackupState._State = BackupState.None()
    var preferences: Preferences?
    var lastUpdated: Date?
    var error: UserfacingError?

    let log = Logger(label: "\(Bundle.identifier).TMUtility")

    var isIdle: Bool { !status.running }

    private var timer: Timer?

    var canReadPreferences: Bool {
        do {
            let _ = try Data(contentsOf: Constants.URLs.timeMachinePreferencesPlist)
            return true
        } catch {
            return false
        }
    }

    init() {
        readPreferences()
        start(force: true)
    }

    deinit {
        Task { [weak self] in
            guard let timer = await self?.timer else { return }
            timer.invalidate()
        }
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
                self.error = UserfacingError.preferencesFilePermissionNotGranted
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
