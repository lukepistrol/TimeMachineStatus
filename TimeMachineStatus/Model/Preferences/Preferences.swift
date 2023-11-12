//
//  Preferences.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import Foundation

struct Preferences: Decodable {
    enum CodingKeys: String, CodingKey {
        case autoBackup = "AutoBackup"
        case autoBackupInterval = "AutoBackupInterval"
        case excludedVolumeUUIDs = "ExcludedVolumeUUIDs"
        case preferencesVersion = "PreferencesVersion"
        case requiresACPower = "RequiresACPower"
        case lastConfigurationTraceDate = "LastConfigurationTraceDate"
        case lastDestinationID = "LastDestinationID"
        case localizedDiskImageVolumeName = "LocalizedDiskImageVolumeName"
        case destinations = "Destinations"
        case skipPaths = "SkipPaths"
    }

    let autoBackup: Bool
    let autoBackupInterval: Int?
    let excludedVolumeUUIDs: [UUID]
    let preferencesVersion: Int
    let requiresACPower: Bool
    let lastConfigurationTraceDate: Date
    let lastDestinationID: UUID?
    let localizedDiskImageVolumeName: String
    let skipPaths: [String]?
    let destinations: [Destination]

    var latestBackupDate: Date? {
        destinations.map(\.snapshotDates).flatMap { $0 }.max()
    }

    var latestBackupVolume: String? {
        guard let lastDestinationID else { return nil }
        return destinations
            .first { $0.destinationID == lastDestinationID }?
            .lastKnownVolumeName
    }
}

struct Destination: Decodable {
    enum CodingKeys: String, CodingKey {
        case lastKnownVolumeName = "LastKnownVolumeName"
        case bytesUsed = "BytesUsed"
        case bytesAvailable = "BytesAvailable"
        case filesystemTypeName = "FilesystemTypeName"
        case lastKnownEncryptionState = "LastKnownEncryptionState"
        case quotaGB = "QuotaGB"
        case networkURL = "NetworkURL"
        case destinationID = "DestinationID"
        case consistencyScanDate = "ConsistencyScanDate"
        case referenceLocalSnapshotDate = "ReferenceLocalSnapshotDate"
        case snapshotDates = "SnapshotDates"
        case attemptDates = "AttemptDates"
    }

    let lastKnownVolumeName: String
    let bytesUsed: Int
    let bytesAvailable: Int
    let filesystemTypeName: String
    let lastKnownEncryptionState: String
    let quotaGB: Double?
    let networkURL: String?
    let destinationID: UUID
    let consistencyScanDate: Date
    let referenceLocalSnapshotDate: Date
    let snapshotDates: [Date]
    let attemptDates: [Date]
}
