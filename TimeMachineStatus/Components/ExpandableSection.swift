//
//  ExpandableSection.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-11.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct ExpandableSection<C: View, H: View>: View {

    let content: () -> C
    let header: () -> H
    @State var expanded: Bool

    init(
        expanded: Bool = true,
        @ViewBuilder content: @escaping () -> C,
        @ViewBuilder header: @escaping () -> H
    ) {
        self.content = content
        self.header = header
        self.expanded = expanded
    }

    var body: some View {
        Section(isExpanded: $expanded) {
            content()
        } header: {
            Button {
                expanded.toggle()
            } label: {
                HStack {
                    header()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(expanded ? .degrees(90) : .zero)
                        .padding(.horizontal, 12)
                        .contentShape(.rect)
                }
                .foregroundStyle(.secondary)
                .font(.headline)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .focusable(false)
        }
    }
}
