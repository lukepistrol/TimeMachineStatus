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
    case preferencesFilePermissionNotGranted
    case debugError(error: Error)

    var title: LocalizedStringKey {
        switch self {
        case .preferencesFilePermissionNotGranted:
            return "button_grant_access"
        case .debugError:
            return "error_debug_title"
        }
    }

    var failureReason: LocalizedStringKey? {
        switch self {
        case .preferencesFilePermissionNotGranted:
            return "settings_item_preferences_file_permission"
        case .debugError(let error):
            return "error_debug_description\(String(describing: error))"
        }
    }

    var action: Action? {
        switch self {
        case .preferencesFilePermissionNotGranted:
            return .grantAccess
        default: return nil
        }
    }

    enum Action {
        case link(title: LocalizedStringKey, url: URL)
        case grantAccess
    }
}
