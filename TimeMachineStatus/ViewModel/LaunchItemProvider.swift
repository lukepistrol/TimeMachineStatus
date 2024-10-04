//
//  LaunchItemProvider.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 13.11.23.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation
import Logging
import ServiceManagement

class LaunchItemProvider: ObservableObject {

    private let log = Logger(label: "com.lukaspistrol.TimeMachineStatus.LaunchItemProvider")

    init() {
        let item = SMAppService.loginItem(identifier: Constants.BundleIds.helper)
        self.launchItem = item
        self.launchAtLogin = item.status == .enabled
    }

    private var launchItem: SMAppService

    var requiresApproval: Bool {
        launchItem.status == .requiresApproval
    }

    @Published var launchAtLogin: Bool {
        didSet {
            if launchAtLogin {
                register()
            } else {
                unregister()
            }
        }
    }

    func register() {
        do {
            log.info("Registering login item", metadata: ["loginItem": .stringConvertible(launchItem)])
            try launchItem.register()
        } catch {
            log.error("Failed to register login item: \(error)")
            launchAtLogin = launchItem.status == .enabled
        }
    }

    func unregister() {
        do {
            log.info("Unregistering login item", metadata: ["loginItem": .stringConvertible(launchItem)])
            try launchItem.unregister()
        } catch {
            log.error("Failed to unregister login item: \(error)")
            launchAtLogin = launchItem.status == .enabled
        }
    }
}
