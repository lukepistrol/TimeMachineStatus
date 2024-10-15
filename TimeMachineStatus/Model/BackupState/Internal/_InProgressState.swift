//
//  _InProgressState.swift
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
    class _InProgressState: _BaseState {
        enum CodingKeys: String, CodingKey {
            case stateChange = "DateOfStateChange"
            case destinationMountPoint = "DestinationMountPoint"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let stateChangeString = try container.decodeIfPresent(String.self, forKey: .stateChange) {
                self.stateChange = if let date = _dateFormatter.date(from: stateChangeString) {
                    date
                } else {
                    throw BackupStateError.couldNotConvertStringToDate(string: stateChangeString)
                }
            } else {
                self.stateChange = nil
            }
            self.destinationMountPoint = try container.decode(String.self, forKey: .destinationMountPoint)
            try super.init(from: decoder)
        }

        init(
            clientID: String,
            destinationID: UUID,
            attemptOptions: Int,
            stateChange: Date?,
            destinationMountPoint: String
        ) {
            self.stateChange = stateChange
            self.destinationMountPoint = destinationMountPoint
            super.init(clientID: clientID, destinationID: destinationID, attemptOptions: attemptOptions)
        }

        let stateChange: Date?
        let destinationMountPoint: String
    }
}
