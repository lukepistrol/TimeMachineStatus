//
//  HideWindowControlsViewModifier.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 02.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

private struct HideWindowControllsViewModifier: ViewModifier {

    let types: [NSWindow.ButtonType]

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
                guard let window = NSApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                hideWindowControls(for: window)
            }
    }

    private func hideWindowControls(for window: NSWindow) {
        types.forEach {
            window.standardWindowButton($0)?.isHidden = true
        }
    }
}

extension View {
    func hideWindowControls(
        _ types: [NSWindow.ButtonType] = [
            .closeButton,
            .miniaturizeButton,
            .zoomButton
        ]
    ) -> some View {
        modifier(HideWindowControllsViewModifier(types: types))
    }
}
