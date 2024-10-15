//
//  Thinning.swift
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
    class Thinning: _InProgressState {
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }

        override fileprivate init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int,
            stateChange: Date?,
            destinationMountPoint: String
        ) {
            super.init(
                clientID: clientID,
                destinationID: destinationID,
                attemptOptions: attemptOptions,
                stateChange: stateChange,
                destinationMountPoint: destinationMountPoint
            )
        }

        override var statusString: String {
            "Thinning Backup Image"
        }

        override var shortStatusString: String {
            "Thinning"
        }
    }
}

extension BackupState._State.Mock {
    static let thinning = BackupState.Thinning(
        clientID: "1234",
        destinationID: UUID(uuidString: "1234")!, // swiftlint:disable:this force_unwrapping
        attemptOptions: 0,
        stateChange: Date(),
        destinationMountPoint: "/Volumes/Backup"
    )
}
