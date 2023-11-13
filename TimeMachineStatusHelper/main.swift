//
//  main.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 13.11.23.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Cocoa

let delegate = HelperAppDelegate()
NSApplication.shared.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
