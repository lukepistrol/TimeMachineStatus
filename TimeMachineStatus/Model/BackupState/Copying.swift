//
//  Copying.swift
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
    class Copying: _InProgressState {
        enum CodingKeys: String, CodingKey {
            case phase = "BackupPhase"
            case clientID = "ClientID"
            case stateChange = "DateOfStateChange"
            case destinationID = "DestinationID"
            case destinationMountPoint = "DestinationMountPoint"
            case fractionOfProgressBar = "FractionOfProgressBar"
            case running = "Running"
            case attemptOptions = "attemptOptions"
            case progress = "Progress"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let fractionOfProgressBarString = try container.decode(String.self, forKey: .fractionOfProgressBar)
            self.fractionOfProgressBar = Double(fractionOfProgressBarString) ?? 0
            self.progress = try container.decode(Progress.self, forKey: .progress)
            try super.init(from: decoder)
        }

        fileprivate init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int,
            stateChange: Date?,
            destinationMountPoint: String,
            fractionOfProgressBar: Double,
            progress: Progress
        ) {
            self.fractionOfProgressBar = fractionOfProgressBar
            self.progress = progress
            super.init(
                clientID: clientID,
                destinationID: destinationID,
                attemptOptions: attemptOptions,
                stateChange: stateChange,
                destinationMountPoint: destinationMountPoint
            )
        }

        let fractionOfProgressBar: Double
        let progress: Progress

        override var statusString: String {
            "Copying Data"
        }

        override var shortStatusString: String {
            "Copying"
        }
    }
}

extension BackupState.Copying {
    struct Progress: Decodable {
        enum CodingKeys: String, CodingKey {
            case percent = "Percent"
            case timeRemaining = "TimeRemaining"
            case bytes
            case files
            case totalBytes
            case totalFiles
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let percentString = try container.decodeIfPresent(String.self, forKey: .percent)
            self.percent = Double(percentString ?? "")
            self.timeRemaining = try container.decodeIfPresent(String.self, forKey: .timeRemaining)
            let bytesString = try container.decodeIfPresent(String.self, forKey: .bytes)
            self.bytes = Int(bytesString ?? "")
            let filesString = try container.decodeIfPresent(String.self, forKey: .files)
            self.files = Int(filesString ?? "")
            let totalBytesString = try container.decodeIfPresent(String.self, forKey: .totalBytes)
            self.totalBytes = Int(totalBytesString ?? "")
            let totalFilesString = try container.decodeIfPresent(String.self, forKey: .totalFiles)
            self.totalFiles = Int(totalFilesString ?? "")
        }

        init(
            percent: Double?,
            timeRemaining: String?,
            bytes: Int?,
            files: Int?,
            totalBytes: Int?,
            totalFiles: Int?
        ) {
            self.percent = percent
            self.timeRemaining = timeRemaining
            self.bytes = bytes
            self.files = files
            self.totalBytes = totalBytes
            self.totalFiles = totalFiles
        }

        let percent: Double?
        let timeRemaining: String?
        let bytes: Int?
        let files: Int?
        let totalBytes: Int?
        let totalFiles: Int?
    }
}

extension BackupState._State.Mock {
    static func copying(_ id: UUID = UUID()) -> BackupState.Copying {
        .init(
            clientID: "1234",
            destinationID: id,
            attemptOptions: 0,
            stateChange: Date(),
            destinationMountPoint: "/Volumes/BackupDrive",
            fractionOfProgressBar: 0.5,
            progress: BackupState.Copying.Progress(
                percent: 50,
                timeRemaining: "2 hours",
                bytes: 1_024,
                files: 10,
                totalBytes: 2_048,
                totalFiles: 20
            )
        )
    }
}
