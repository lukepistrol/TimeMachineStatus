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

    var title: LocalizedStringKey {
        switch self {
        case .fullDiskPermissionDenied:
            return "error_fulldiskpermissiondenied_title"
        }
    }

    var failureReason: LocalizedStringKey? {
        switch self {
        case .fullDiskPermissionDenied:
            return "error_fulldiskpermissiondenied_description"
        }
    }

    var action: Action? {
        switch self {
        case .fullDiskPermissionDenied:
            Action(
                title: "button_opensystemsettings",
                url: Constants.URLs.settingsFullDiskAccess
            )
        }
    }

    struct Action {
        let title: LocalizedStringKey
        let url: URL
    }
}
