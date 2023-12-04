//
//  UserfacingErrorView.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-11.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct UserfacingErrorView: View {
    let error: UserfacingError?

    @ViewBuilder
    var body: some View {
        if let error {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Symbols.exclamationMarkTriangleFill.image
                        .foregroundStyle(.red)
                    Text(error.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.primary)
                }
                .font(.headline)
                if let failureReason = error.failureReason {
                    Text(failureReason)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(5)
                }
                if let action = error.action {
                    Divider()
                    Button(action.title) {
                        NSWorkspace.shared.open(action.url)
                    }
                }
            }
            .padding(8)
            .card(.bar)
            .padding()
        }
    }
}
