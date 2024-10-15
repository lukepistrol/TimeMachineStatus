//
//  Idle.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

extension BackupState {

    class Idle: _State {
        enum CodingKeys: String, CodingKey {
            case clientID = "ClientID"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.clientID = try container.decode(String.self, forKey: .clientID)
            try super.init(from: decoder)
        }

        fileprivate init(clientID: String) {
            self.clientID = clientID
            super.init()
        }

        let clientID: String

        override var statusString: String {
            "Idle"
        }

        override var shortStatusString: String {
            "Idle"
        }
    }
}

extension BackupState._State.Mock {
    static let idle = BackupState.Idle(clientID: "1234")
}
