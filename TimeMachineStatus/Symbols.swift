//
//  Symbols.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI

enum Symbols: String {
    case checkmarkCircleFill = "checkmark.circle.fill"
    case exclamationMarkTriangleFill = "exclamationmark.triangle.fill"
    case externalDrive = "externaldrive.fill.badge.timemachine"
    case gear
    case gearshapeFill = "gearshape.fill"
    case infoCircle = "info.circle"
    case nasDrive = "externaldrive.fill.badge.wifi"
    case playFill = "play.fill"
    case stopFill = "stop.fill"
    case timeMachine = "clock.arrow.circlepath"
    case wandAndStarsInverse = "wand.and.stars.inverse"
    case xmarkCircleFill = "xmark.circle.fill"

    var image: Image {
        Image(systemName: self.rawValue)
    }

    var name: String {
        self.rawValue
    }

    func nsImage(accessibilityDescription: String? = nil) -> NSImage? {
        return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)
    }

    func callAsFunction() -> String {
        return self.rawValue
    }
}
