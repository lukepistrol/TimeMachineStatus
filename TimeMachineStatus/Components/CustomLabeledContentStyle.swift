//
//  CustomLabeledContentStyle.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct CustomLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 0) {
                configuration.label
                Text(verbatim: ":")
            }
            .font(.body.weight(.semibold))
            .foregroundStyle(.primary)
            Spacer()
            configuration.content
                .font(.callout)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
    }
}

extension LabeledContentStyle where Self == CustomLabeledContentStyle {
    static var custom: CustomLabeledContentStyle {
        CustomLabeledContentStyle()
    }
}
