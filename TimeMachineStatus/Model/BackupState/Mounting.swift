//
//  Mounting.swift
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
    class Mounting: _BaseState {
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }

        override fileprivate init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int
        ) {
            super.init(
                clientID: clientID,
                destinationID: destinationID,
                attemptOptions: attemptOptions
            )
        }

        override var statusString: String {
            "Mounting Disk Image"
        }

        override var shortStatusString: String {
            "Mounting"
        }
    }
}

extension BackupState._State.Mock {
    static let mounting = BackupState.Mounting(
        clientID: "1234",
        destinationID: UUID(uuidString: "1234")!, // swiftlint:disable:this force_unwrapping
        attemptOptions: 0
    )
}
