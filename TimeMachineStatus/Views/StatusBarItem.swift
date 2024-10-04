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

import Combine
import Logging
import SwiftUI

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

    @AppStorage(StorageKeys.boldIcon.id)
    private var boldIcon: Bool = StorageKeys.boldIcon.default

    @AppStorage(StorageKeys.showStatus.id)
    private var showStatus: Bool = StorageKeys.showStatus.default

    @AppStorage(StorageKeys.showPercentage.id)
    private var showPercentage: Bool = StorageKeys.showPercentage.default

    @AppStorage(StorageKeys.spacing.id)
    private var spacing: Double = StorageKeys.spacing.default

    @AppStorage(StorageKeys.backgroundColor.id)
    private var bgColor: Color = StorageKeys.backgroundColor.default

    @AppStorage(StorageKeys.cornerRadius.id)
    private var cornerRadius: Double = StorageKeys.cornerRadius.default

    @AppStorage(StorageKeys.animateIcon.id)
    private var animateIcon: Bool = StorageKeys.animateIcon.default

    var sizePassthrough: PassthroughSubject<CGSize, Never>
    @State var utility: TMUtilityImpl

    private let log = Logger(label: "\(Bundle.identifier).StatusBarItem")

    private var mainContent: some View {
        HStack(spacing: spacing) {
            if utility.isIdle {
                Image(systemSymbol: .clockArrowCirclepath)
                    .font(.body.weight(boldIcon ? .bold : .medium))
            } else {
                if animateIcon {
                    AnimatedIcon()
                        .font(.body.weight(boldIcon ? .bold : .medium))
                } else {
                    Image(systemSymbol: .arrowTriangle2Circlepath)
                        .font(.body.weight(boldIcon ? .bold : .medium))
                }
            }
            if showStatus, !utility.isIdle {
                Text(utility.status.shortStatusString)
                    .font(.caption2.weight(boldFont ? .bold : .medium))
            }
            if let percentage = utility.status.progessPercentage, showPercentage {
                Text(percentage, format: .percent.precision(.fractionLength(0)))
                    .font(.caption2.weight(boldFont ? .bold : .medium))
                    .monospacedDigit()
            }
        }
        .foregroundStyle(Color.menuBarForeground)
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
            .onPreferenceChange(ItemSizePreferenceKey.self) { size in
                log.trace("Size: \(size)")
                sizePassthrough.send(size)
            }
            .offset(y: -1)
            .onChange(of: utility.isIdle) { oldValue, newValue in
                log.trace("Changed: \(oldValue) -> \(newValue)")
            }
    }

    struct AnimatedIcon: View {
        @State private var isAnimating = false

        private var rotationAnimation: Animation = .linear(duration: 2).repeatForever(autoreverses: false)

        var body: some View {
            Image(systemSymbol: .arrowTriangle2Circlepath)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0), anchor: .center)
                .animation(rotationAnimation, value: isAnimating)
                .task {
                    isAnimating = true
                }
        }
    }
}

#Preview {
    StatusBarItem(sizePassthrough: .init(), utility: .init())
        .frame(height: 24)
}
