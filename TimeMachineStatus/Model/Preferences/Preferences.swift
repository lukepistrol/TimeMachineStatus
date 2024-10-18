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

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.autoBackup = try container.decodeBoolOrIntIfPresent(for: .autoBackup)
        self.autoBackupInterval = try container.decodeIfPresent(Int.self, forKey: .autoBackupInterval)
        self.excludedVolumeUUIDs = try container.decodeIfPresent([UUID].self, forKey: .excludedVolumeUUIDs)
        self.preferencesVersion = try container.decode(Int.self, forKey: .preferencesVersion)
        self.requiresACPower = try container.decodeBoolOrIntIfPresent(for: .requiresACPower)
        self.lastConfigurationTraceDate = try container.decodeIfPresent(Date.self, forKey: .lastConfigurationTraceDate)
        self.lastDestinationID = try container.decodeIfPresent(UUID.self, forKey: .lastDestinationID)
        self.localizedDiskImageVolumeName = try container.decodeIfPresent(
            String.self,
            forKey: .localizedDiskImageVolumeName
        )
        self.destinations = try container
            .decodeIfPresent([Destination].self, forKey: .destinations)?
            .sorted { $0.lastKnownVolumeName ?? "" < $1.lastKnownVolumeName ?? "" }
        self.skipPaths = try container.decodeIfPresent([String].self, forKey: .skipPaths)
    }

    private init(
        autoBackup: Bool?,
        autoBackupInterval: Int?,
        excludedVolumeUUIDs: [UUID]?,
        preferencesVersion: Int,
        requiresACPower: Bool?,
        lastConfigurationTraceDate: Date?,
        lastDestinationID: UUID?,
        localizedDiskImageVolumeName: String?,
        skipPaths: [String]?,
        destinations: [Destination]?
    ) {
        self.autoBackup = autoBackup
        self.autoBackupInterval = autoBackupInterval
        self.excludedVolumeUUIDs = excludedVolumeUUIDs
        self.preferencesVersion = preferencesVersion
        self.requiresACPower = requiresACPower
        self.lastConfigurationTraceDate = lastConfigurationTraceDate
        self.lastDestinationID = lastDestinationID
        self.localizedDiskImageVolumeName = localizedDiskImageVolumeName
        self.skipPaths = skipPaths
        self.destinations = destinations
    }

    let autoBackup: Bool?
    let autoBackupInterval: Int?
    let excludedVolumeUUIDs: [UUID]?
    let preferencesVersion: Int
    let requiresACPower: Bool?
    let lastConfigurationTraceDate: Date?
    let lastDestinationID: UUID?
    let localizedDiskImageVolumeName: String?
    let skipPaths: [String]?
    let destinations: [Destination]?

    var latestBackupDate: Date? {
        destinations?.compactMap(\.snapshotDates).flatMap { $0 }.max()
    }

    var latestBackupVolume: String? {
        guard let lastDestinationID else { return nil }
        return destinations?
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
        case result = "RESULT"
    }

    let lastKnownVolumeName: String?
    let bytesUsed: Int?
    let bytesAvailable: Int?
    let filesystemTypeName: String?
    let lastKnownEncryptionState: String?
    let quotaGB: Double?
    let networkURL: String?
    let destinationID: UUID
    let consistencyScanDate: Date?
    let referenceLocalSnapshotDate: Date?
    let snapshotDates: [Date]?
    let attemptDates: [Date]?
    let result: Int?

    var lastBackupFailed: Bool {
        guard let snapshotDates,
              let last = snapshotDates.last,
              let attemptDates,
              let lastAttempt = attemptDates.last
        else { return false }

        return lastAttempt > last
    }

    var numberOfBackups: Int {
        snapshotDates?.count ?? 0
    }
}

extension Preferences {
    static let mock = Preferences(
        autoBackup: false,
        autoBackupInterval: 0,
        excludedVolumeUUIDs: nil,
        preferencesVersion: 1,
        requiresACPower: true,
        lastConfigurationTraceDate: .distantPast,
        lastDestinationID: nil,
        localizedDiskImageVolumeName: "Backups of XX",
        skipPaths: nil,
        destinations: [.mock(name: "Test Drive 1"), .mock(name: "Test Drive 2", network: true)]
    )
}

extension Destination {
    static func mock(name: String, network: Bool = false) -> Self {
        Destination(
            lastKnownVolumeName: name,
            bytesUsed: .random(in: 100_000_000_000...500_000_000_000),
            bytesAvailable: .random(in: 10_000_000_000...100_000_000_000),
            filesystemTypeName: "APFS",
            lastKnownEncryptionState: "Encrypted",
            quotaGB: .random(in: 400...1_000),
            networkURL: network ? "smb://nas.local/share" : nil,
            destinationID: UUID(),
            consistencyScanDate: .distantPast,
            referenceLocalSnapshotDate: .now,
            snapshotDates: [.distantPast, .now.addingTimeInterval(.random(in: -100_000...0))],
            attemptDates: [.distantPast, .now.addingTimeInterval(.random(in: -100_000...0))],
            result: 0
        )
    }
}
