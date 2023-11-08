//
//  FormatStyle+.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import Foundation

extension FormatStyle where Self == Date.RelativeFormatStyle {
    static var relativeDate: Date.RelativeFormatStyle {
        .relative(presentation: .named, unitsStyle: .narrow)
    }
}
