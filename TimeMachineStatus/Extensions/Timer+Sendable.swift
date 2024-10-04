//
//  Timer+Sendable.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 03.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

extension Timer: @unchecked @retroactive Sendable {}
