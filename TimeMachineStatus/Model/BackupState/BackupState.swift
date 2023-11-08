//
//  BackupState.swift
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

enum BackupState {
    static let log = Logger(label: "com.lukaspistrol.TimeMachineStatus.BackupState")

    static func getState() throws -> _State {
        let result = try shellOut(to: "tmutil status | tail -n +2")

        log.trace("Raw State: \(result)")

        guard let data = result.data(using: .utf8) else {
            throw BackupStateError.couldNotConvertStringToData(string: result)
        }

        if let state = try _decodePlist(data) {
            return state
        }
        throw BackupStateError.invalidState(raw: result)
    }
}

// MARK: - Private

extension BackupState {
    static let _dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()

    static private func _decodePlist(_ data: Data) throws -> _State? {
        let decoder = PropertyListDecoder()
        let state = try decoder.decode(BackupState._State.self, from: data)
        switch state.state {
        case ._idle:
            return try decoder.decode(BackupState.Idle.self, from: data)
        case ._findingBackupVol:
            return try decoder.decode(BackupState.FindingBackupVolume.self, from: data)
        case ._starting:
            return try decoder.decode(BackupState.Starting.self, from: data)
        case ._mounting:
            return try decoder.decode(BackupState.Mounting.self, from: data)
        case ._preparing:
            return try decoder.decode(BackupState.Preparing.self, from: data)
        case ._findingChanges:
            return try decoder.decode(BackupState.FindingChanges.self, from: data)
        case ._copying:
            return try decoder.decode(BackupState.Copying.self, from: data)
        case ._finishing:
            return try decoder.decode(BackupState.Finishing.self, from: data)
        case ._stopping:
            return try decoder.decode(BackupState.Stopping.self, from: data)
        case ._thinning:
            return try decoder.decode(BackupState.Thinning.self, from: data)
        case ._unknown:
            return nil
        }
    }
}
