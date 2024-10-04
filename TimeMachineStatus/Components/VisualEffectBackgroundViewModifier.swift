//
//  VisualEffectBackgroundViewModifier.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 02.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

private struct VisualEffectBackgroundViewModifier: ViewModifier {

    let material: NSVisualEffectView.Material
    let state: NSVisualEffectView.State

    func body(content: Content) -> some View {
        content
            .background {
                _VisualEffectView(material: material, state: state)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
    }
}

extension View {
    @ViewBuilder
    func backgroundVisualEffect(
        _ material: NSVisualEffectView.Material,
        state: NSVisualEffectView.State = .active
    ) -> some View {
        if isPreview {
            self
        } else {
            modifier(VisualEffectBackgroundViewModifier(material: material, state: state))
        }
    }
}

private struct _VisualEffectView: NSViewRepresentable {

    let material: NSVisualEffectView.Material
    let state: NSVisualEffectView.State

    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = material
        effectView.state = state
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
