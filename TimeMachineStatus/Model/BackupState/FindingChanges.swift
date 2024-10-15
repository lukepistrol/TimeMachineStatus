//
//  FindingChanges.swift
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
    class FindingChanges: _InProgressState {

        enum CodingKeys: String, CodingKey {
            case itemsFound = "ChangedItemCount"
            case fractionDone = "FractionDone"
            case fractionOfProgressBar = "FractionOfProgressBar"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let itemsFoundString = try container.decode(String.self, forKey: .itemsFound)
            self.itemsFound = Int(itemsFoundString) ?? 0
            let fractionDoneString = try container.decode(String.self, forKey: .fractionDone)
            self.fractionDone = Double(fractionDoneString) ?? 0
            let fractionOfProgressBarString = try container.decode(String.self, forKey: .fractionOfProgressBar)
            self.fractionOfProgressBar = Double(fractionOfProgressBarString) ?? 0
            try super.init(from: decoder)
        }

        fileprivate init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int,
            stateChange: Date?,
            destinationMountPoint: String,
            itemsFound: Int,
            fractionDone: Double,
            fractionOfProgressBar: Double
        ) {
            self.itemsFound = itemsFound
            self.fractionDone = fractionDone
            self.fractionOfProgressBar = fractionOfProgressBar
            super.init(
                clientID: clientID,
                destinationID: destinationID,
                attemptOptions: attemptOptions,
                stateChange: stateChange,
                destinationMountPoint: destinationMountPoint
            )
        }

        let itemsFound: Int
        let fractionDone: Double
        let fractionOfProgressBar: Double

        override var statusString: String {
            "Finding Changes"
        }

        override var shortStatusString: String {
            "Changes"
        }
    }
}

extension BackupState._State.Mock {
    static func findingChanges(_ id: UUID = UUID()) -> BackupState.FindingChanges {
        .init(
            clientID: "1234",
            destinationID: id,
            attemptOptions: 0,
            stateChange: Date(),
            destinationMountPoint: "/Volumes/Backup",
            itemsFound: .random(in: 0...100),
            fractionDone: .random(in: 0...1),
            fractionOfProgressBar: 0.1
        )
    }
}
