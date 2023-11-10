//
//  StatusBarItem.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI
import Combine

struct ItemSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct StatusBarItem: View {

    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(StorageKeys.horizontalPadding.id)
    private var padding: Double = StorageKeys.horizontalPadding.default

    @AppStorage(StorageKeys.verticalPadding.id)
    private var verticalPadding: Double = StorageKeys.verticalPadding.default

    @AppStorage(StorageKeys.boldFont.id)
    private var boldFont: Bool = StorageKeys.boldFont.default

    @AppStorage(StorageKeys.showStatus.id)
    private var showStatus: Bool = StorageKeys.showStatus.default

    @AppStorage(StorageKeys.spacing.id)
    private var spacing: Double = StorageKeys.spacing.default

    @AppStorage(StorageKeys.backgroundColor.id)
    private var bgColor: Color = StorageKeys.backgroundColor.default

    @AppStorage(StorageKeys.cornerRadius.id)
    private var cornerRadius: Double = StorageKeys.cornerRadius.default

    var sizePassthrough: PassthroughSubject<CGSize, Never>
    @ObservedObject var utility: TMUtility

    private var mainContent: some View {
        HStack(spacing: spacing) {
            Symbols.timeMachine.image
                .font(.body.weight(boldFont ? .bold : .medium))
            if showStatus {
                Text(utility.status.statusString)
                    .font(.caption2.weight(boldFont ? .bold : .medium))
            }
        }
        .foregroundStyle(.primary)
    }

    var body: some View {
        mainContent
            .padding(.horizontal, 4 + padding)
            .frame(maxHeight: .infinity)
            .background(bgColor, in: .rect(cornerRadius: cornerRadius))
            .padding(.vertical, verticalPadding)
            .fixedSize(horizontal: true, vertical: false)
            .overlay(
                GeometryReader { geometryProxy in
                    Color.clear
                        .preference(key: ItemSizePreferenceKey.self, value: geometryProxy.size)
                }
            )
            .onPreferenceChange(ItemSizePreferenceKey.self, perform: { size in
                sizePassthrough.send(size)
            })
            .offset(y: -1)
    }
}

#Preview {
    StatusBarItem(sizePassthrough: .init(), utility: .init())
        .frame(height: 24)
}
