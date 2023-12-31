//
//  Starting.swift
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
    class Starting: _BaseState {
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }

        override var statusString: String {
            "Starting"
        }

        override var shortStatusString: String {
            statusString
        }
    }
}
