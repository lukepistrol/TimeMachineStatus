//
//  _State.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import Foundation

extension BackupState {
    class _State: Decodable {
        enum _BState {
            case _idle, _findingBackupVol, _starting, _mounting, _preparing, _findingChanges, _copying, _finishing
            case _stopping, _thinning, _unknown
        }

        enum CodingKeys: String, CodingKey {
            case phase = "BackupPhase"
            case running = "Running"
        }

        init() {
            self.phase = ""
            self.running = false
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.phase = try container.decodeIfPresent(String.self, forKey: .phase)
            let runningString = try container.decode(String.self, forKey: .running)
            self.running = runningString == "1"
        }

        var phase: String?
        var running: Bool

        var statusString: String {
            fatalError("Implement!")
        }

        var state: _BState {
            if let phase, running {
                switch phase {
                case "FindingBackupVol":
                    return ._findingBackupVol
                case "Starting":
                    return ._starting
                case "MountingDiskImage":
                    return ._mounting
                case "PreparingSourceVolumes":
                    return ._preparing
                case "FindingChanges":
                    return ._findingChanges
                case "Copying":
                    return ._copying
                case "Finishing":
                    return ._finishing
                case "Stopping":
                    return ._stopping
                case "ThinningPostBackup":
                    return ._thinning
                default:
                    fatalError("Unknown phase: \(phase)")
                }
            } else {
                return ._idle
            }
        }
    }

    class None: _State {
        override init() {
            super.init()
            self.phase = "None"
        }

        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }

        override var statusString: String {
            "N/A"
        }
    }
}

extension BackupState._State {
    var activeDestinationID: UUID? {
        if let state = self as? BackupState._BaseState {
            return state.destinationID
        }
        return nil
    }

    var progessPercentage: Double? {
        if let state = self as? BackupState._InProgressState {
            if let state = state as? BackupState.FindingChanges {
                return state.fractionOfProgressBar * state.fractionDone
            } else if let state = state as? BackupState.Copying {
                return 0.1 + (state.progress.percent ?? 0) * state.fractionOfProgressBar
            } else if state is BackupState.Finishing || state is BackupState.Stopping {
                return 0.95
            } else if state is BackupState.Thinning {
                return 0.98
            }
        }
        return nil
    }
}
