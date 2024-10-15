//
//  Unknown.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 15.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

extension BackupState {

    class Unknown: _State {

        let title: String
        let rawState: String

        init(title: String, raw: String) {
            self.title = title
            self.rawState = raw
            super.init(running: true)
        }

        @available(*, unavailable)
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override var statusString: String {
            title
        }

        override var shortStatusString: String {
            title
        }
    }
}

extension BackupState._State.Mock {
    static let unknown = BackupState.Unknown(title: "Unknown", raw: "{ Some State Content }")
}
