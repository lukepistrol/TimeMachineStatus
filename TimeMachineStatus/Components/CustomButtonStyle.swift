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
    @State private var hovering: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground(configuration).gradient)
            .scaleEffect(configuration.isPressed ? .init(width: 0.95, height: 0.95) : .init(width: 1, height: 1))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.1), value: hovering)
            .onHover { hovering in
                self.hovering = hovering
            }
    }

    private func foreground(_ configuration: Configuration) -> Color {
        if configuration.isPressed {
            Color.secondary
        } else {
            hovering ? Color.primary : Color.secondary
        }
    }
}

extension ButtonStyle where Self == CustomButtonStyle {
    static var custom: CustomButtonStyle { CustomButtonStyle() }
}
