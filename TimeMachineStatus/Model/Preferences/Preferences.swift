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

    var destinationError: DestinationError? {
        DestinationError(result)
    }

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

struct DestinationError: Error {
    let errorCode: Int

    init?(_ errorCode: Int?) {
        guard let errorCode, errorCode != 0 else { return nil }
        self.errorCode = errorCode
    }

    var localizedString: LocalizedStringResource {
        return switch errorCode {
        case 1: "DESTINATION_ERROR_1_MESSAGE"
        case 2: "DESTINATION_ERROR_2_MESSAGE"
        case 3, 6: "DESTINATION_ERROR_3_MESSAGE"
        case 4: "DESTINATION_ERROR_4_MESSAGE"
        case 5: "DESTINATION_ERROR_5_MESSAGE"
        case 7: "DESTINATION_ERROR_7_MESSAGE"
        case 8: "DESTINATION_ERROR_8_MESSAGE"
        case 9: "DESTINATION_ERROR_9_MESSAGE"
        case 10: "DESTINATION_ERROR_10_MESSAGE"
        case 11: "DESTINATION_ERROR_11_MESSAGE"
        case 12: "DESTINATION_ERROR_12_MESSAGE"
        case 14: "DESTINATION_ERROR_14_MESSAGE"
        case 15, 16: "DESTINATION_ERROR_15_MESSAGE"
        case 17: "DESTINATION_ERROR_17_MESSAGE"
        case 18: "DESTINATION_ERROR_18_MESSAGE"
        case 19: "DESTINATION_ERROR_19_MESSAGE"
        case 20: "DESTINATION_ERROR_20_MESSAGE"
        case 21: "DESTINATION_ERROR_21_MESSAGE"
        case 22: "DESTINATION_ERROR_22_MESSAGE"
        case 23: "DESTINATION_ERROR_23_MESSAGE"
        case 24: "DESTINATION_ERROR_24_MESSAGE"
        case 25: "DESTINATION_ERROR_25_MESSAGE"
        case 26: "DESTINATION_ERROR_26_MESSAGE"
        case 27: "DESTINATION_ERROR_27_MESSAGE"
        case 28: "DESTINATION_ERROR_28_MESSAGE"
        case 29: "DESTINATION_ERROR_29_MESSAGE"
        case 30: "DESTINATION_ERROR_30_MESSAGE"
        case 31: "DESTINATION_ERROR_31_MESSAGE"
        case 32: "DESTINATION_ERROR_32_MESSAGE"
        case 33: "DESTINATION_ERROR_33_MESSAGE"
        case 37: "DESTINATION_ERROR_37_MESSAGE"
        case 38: "DESTINATION_ERROR_38_MESSAGE"
        case 39: "DESTINATION_ERROR_39_MESSAGE"
        case 42: "DESTINATION_ERROR_42_MESSAGE"
        case 44: "DESTINATION_ERROR_44_MESSAGE"
        case 45: "DESTINATION_ERROR_45_MESSAGE"
        case 49: "DESTINATION_ERROR_49_MESSAGE"
        case 50: "DESTINATION_ERROR_50_MESSAGE"
        case 52: "DESTINATION_ERROR_52_MESSAGE"
        case 53: "DESTINATION_ERROR_53_MESSAGE"
        case 60: "DESTINATION_ERROR_60_MESSAGE"
        case 70: "DESTINATION_ERROR_70_MESSAGE"
        case 100: "DESTINATION_ERROR_100_MESSAGE"
        case 101: "DESTINATION_ERROR_101_MESSAGE"
        case 102: "DESTINATION_ERROR_102_MESSAGE"
        case 103: "DESTINATION_ERROR_103_MESSAGE"
        case 104: "DESTINATION_ERROR_104_MESSAGE"
        case 105, 106: "DESTINATION_ERROR_105_MESSAGE"
        case 300, 301, 302, 303: "DESTINATION_ERROR_300_MESSAGE"
        case 402: "DESTINATION_ERROR_402_MESSAGE"
        case 404: "DESTINATION_ERROR_404_MESSAGE"
        case 406: "DESTINATION_ERROR_406_MESSAGE"
        case 450: "DESTINATION_ERROR_450_MESSAGE"
        case 451: "DESTINATION_ERROR_451_MESSAGE"
        case 455: "DESTINATION_ERROR_455_MESSAGE"
        case 501: "DESTINATION_ERROR_501_MESSAGE"
        case 703: "DESTINATION_ERROR_703_MESSAGE"
        case 704: "DESTINATION_ERROR_704_MESSAGE"
        default: "DESTINATION_ERROR_999_MESSAGE"
        }
    }
}
