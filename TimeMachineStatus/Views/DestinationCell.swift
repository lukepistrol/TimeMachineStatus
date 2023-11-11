//
//  DestinationCell.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI

struct DestinationCell: View {
    @EnvironmentObject private var utility: TMUtility

    let dest: Destination

    init(_ dest: Destination) {
        self.dest = dest
    }

    private var isActive: Bool {
        utility.status.activeDestinationID == dest.destinationID
    }

    private var copying: BackupState.Copying? {
        if let copying = utility.status as? BackupState.Copying {
            return copying
        }
        return nil
    }

    @State private var showInfo: Bool = false
    @State private var hovering: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                symbol
                volumeInfo
                Spacer()
                progressIndicator
                startStopButton
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .padding(.trailing, 4)
            status
        }
        .overlay { hoverOverlay }
        .contentShape(.rect)
        .contextMenu { contextMenuActions }
        .card(.background.secondary)
        .onHover(perform: { hovering in
            self.hovering = hovering
        })
        .popover(isPresented: $showInfo) {
            DestinationInfoView(dest: dest)
        }
    }

    @ViewBuilder
    private var hoverOverlay: some View {
        if hovering {
            Rectangle()
                .fill(.fill.secondary)
                .allowsHitTesting(false)
        }
    }

    private var symbol: some View {
        Group {
            if dest.networkURL != nil {
                Symbols.nasDrive.image
            } else {
                Symbols.externalDrive.image
            }
        }
        .imageScale(.large)
        .font(.title2)
        .foregroundStyle(.secondary)
    }

    private var volumeInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dest.lastKnownVolumeName)
                    .font(.headline)
                if let latest = dest.snapshotDates.max() {
                    Text(latest.formatted(.relativeDate))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            HStack {
                Text("\(dest.bytesUsed.formatted(byteFormat)) used, \(dest.bytesAvailable.formatted(byteFormat)) free")
                    .monospacedDigit()
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var progressIndicator: some View {
        if isActive {
            ProgressView()
                .scaleEffect(0.4)
                .frame(height: 20)
        }
    }

    private var startStopButton: some View {
        Button {
            if utility.status.activeDestinationID == dest.destinationID {
                utility.stopBackup()
            } else {
                utility.startBackup(id: dest.destinationID)
            }
        } label: {
            utility.status.activeDestinationID == dest.destinationID ? Symbols.stopFill.image : Symbols.playFill.image
        }
        .imageScale(.large)
        .buttonStyle(.custom)
        .focusable(false)
    }

    @ViewBuilder
    private var contextMenuActions: some View {
        Button("Show Info") { showInfo.toggle() }
        Divider()
        Button("Backup to \(dest.lastKnownVolumeName) now") {
            utility.startBackup(id: dest.destinationID)
        }
    }

    @ViewBuilder
    private var status: some View {
        if isActive {
            HStack {
                if let state = utility.status as? BackupState._BaseState {
                    Text(state.statusString)
                }
                Spacer()
                if let copying {
                    if let bytes = copying.progress.bytes,
                       let files = copying.progress.files {
                        Text("\(files) Files (\(bytes.formatted(byteFormat)))")
                    }
                }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background { progressBackground }
            .background(.fill.tertiary, in: .rect)
        }
    }

    private var progressBackground: some View {
        GeometryReader(content: { geometry in
            if let percent = utility.status.progessPercentage {
                Color.accentColor
                    .frame(width: geometry.size.width * percent)
                    .opacity(0.3)
                    .animation(.easeInOut, value: percent)
            }
        })
    }

    private var byteFormat: ByteCountFormatStyle {
        .byteCount(style: .file)
    }
}

#Preview("Light") {
    MenuView(utility: .init())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    MenuView(utility: .init())
        .preferredColorScheme(.dark)
}
