//
//  Bundle+.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

public extension Bundle {
    static var appName: String {
        if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return ""
    }

    static var appVersionString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }

    static var appBuildString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return version
        }
        return ""
    }

    static var identifier: String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
