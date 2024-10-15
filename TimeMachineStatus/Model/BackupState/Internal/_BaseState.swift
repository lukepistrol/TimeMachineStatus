//
//  _BaseState.swift
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
    class _BaseState: _State {
        enum CodingKeys: String, CodingKey {
            case clientID = "ClientID"
            case destinationID = "DestinationID"
            case attemptOptions = "attemptOptions"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.clientID = try container.decode(String.self, forKey: .clientID)
            let destinationIDString = try container.decode(String.self, forKey: .destinationID)
            self.destinationID = if let uuid = UUID(uuidString: destinationIDString) {
                uuid
            } else {
                throw BackupStateError.failedToParseUUID(uuid: destinationIDString)
            }
            let attemptOptionsString = try container.decode(String.self, forKey: .attemptOptions)
            self.attemptOptions = Int(attemptOptionsString) ?? 0
            try super.init(from: decoder)
        }

        init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int
        ) {
            self.clientID = clientID
            self.destinationID = destinationID
            self.attemptOptions = attemptOptions
            super.init()
        }

        let clientID: String
        let destinationID: UUID
        let attemptOptions: Int
    }
}
