//
//  Bool+.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI

extension Bool {
    var image: some View {
        Image(systemName: self ? Symbols.checkmarkCircleFill() : Symbols.xmarkCircleFill())
            .foregroundStyle(self ? .green : .red)
    }
}
