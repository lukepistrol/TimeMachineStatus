//
//  CardViewModifier.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct CardViewModifier<Style: ShapeStyle, S: Shape>: ViewModifier {

    let style: Style
    let shape: S

    func body(content: Content) -> some View {
        content
            .background(style, in: .rect)
            .clipShape(shape)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

extension View {
    func card<Style, S>(
        _ style: Style,
        in shape: S = .rect(cornerRadius: 10)
    ) -> some View where Style: ShapeStyle, S: Shape {
        modifier(CardViewModifier(style: style, shape: shape))
    }
}
