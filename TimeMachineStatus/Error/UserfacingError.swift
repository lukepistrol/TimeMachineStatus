//
//  UserfacingError.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

enum UserfacingError: LocalizedError {
    case fullDiskPermissionDenied

    var errorDescription: String? {
        switch self {
        case .fullDiskPermissionDenied:
            return "Full Disk Access permission denied"
        }
    }

    var failureReason: String? {
        switch self {
        case .fullDiskPermissionDenied:
            return "TimeMachineStatus needs full disk access to read Time Machine preferences.\n\nPlease grant TimeMachineStatus full disk access in System Settings > Privacy & Security > Full Disk Access."
        }
    }

    var action: Action? {
        switch self {
        case .fullDiskPermissionDenied:
            Action(
                title: "Open System Settings",
                url: Constants.URLs.settingsFullDiskAccess
            )
        }
    }

    struct Action {
        let title: String
        let url: URL
    }
}
