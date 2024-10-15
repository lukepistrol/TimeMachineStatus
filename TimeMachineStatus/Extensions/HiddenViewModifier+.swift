//
//  HiddenViewModifier+.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 14.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct HiddenViewModifier: ViewModifier {
    private let hidden: Bool

    init(_ hidden: Bool) {
        self.hidden = hidden
    }

    func body(content: Content) -> some View {
        if hidden {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {
    func hidden(_ hidden: Bool) -> some View {
        modifier(HiddenViewModifier(hidden))
    }
}
