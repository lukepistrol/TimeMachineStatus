//
//  CustomButtonStyle.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI

struct CustomButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground(configuration))
            .scaleEffect(configuration.isPressed ? .init(width: 0.95, height: 0.95) : .init(width: 1, height: 1))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }

    private func foreground(_ configuration: Configuration) -> Color {
        if configuration.isPressed {
            Color.accentColor.opacity(0.8)
        } else {
            Color.accentColor
        }
    }
}

extension ButtonStyle where Self == CustomButtonStyle {
    static var custom: CustomButtonStyle { CustomButtonStyle() }
}
