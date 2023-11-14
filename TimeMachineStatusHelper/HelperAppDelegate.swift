//
//  HelperAppDelegate.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 13.11.23.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Cocoa

class HelperAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == Constants.BundleIds.main
        }

        if !isRunning {
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: Constants.BundleIds.main) {
                NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
            }
        }
    }
}
