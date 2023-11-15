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

import SwiftUI

enum UserfacingError: Error {
    case fullDiskPermissionDenied
    case debugError(error: Error)

    var title: LocalizedStringKey {
        switch self {
        case .fullDiskPermissionDenied:
            return "error_fulldiskpermissiondenied_title"
        case .debugError:
            return "error_debug_title"
        }
    }

    var failureReason: LocalizedStringKey? {
        switch self {
        case .fullDiskPermissionDenied:
            return "error_fulldiskpermissiondenied_description"
        case .debugError(let error):
            return "error_debug_description\(String(describing: error))"
        }
    }

    var action: Action? {
        switch self {
        case .fullDiskPermissionDenied:
            Action(
                title: "button_opensystemsettings",
                url: Constants.URLs.settingsFullDiskAccess
            )
        default: nil
        }
    }

    struct Action {
        let title: LocalizedStringKey
        let url: URL
    }
}
