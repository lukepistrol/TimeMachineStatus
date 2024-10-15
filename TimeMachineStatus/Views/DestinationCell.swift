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
    @State private var utility: any TMUtility

    let dest: Destination

    init(_ dest: Destination, utility: any TMUtility) {
        self.dest = dest
        self.utility = utility
    }

    private var isActive: Bool {
        utility.status.activeDestinationID == dest.destinationID
    }

    private var findingChanges: BackupState.FindingChanges? {
        if let findingChanges = utility.status as? BackupState.FindingChanges {
            return findingChanges
        }
        return nil
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
                failureWarning
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
        .onHover { hovering in
            withAnimation(.snappy) {
                self.hovering = hovering
            }
        }
        .popover(isPresented: $showInfo) {
            DestinationInfoView(dest: dest)
        }
    }

    @ViewBuilder
    private var hoverOverlay: some View {
        if hovering {
            Rectangle()
                .fill(.fill.secondary.opacity(0.5))
                .allowsHitTesting(false)
        }
    }

    private var symbol: some View {
        Group {
            if dest.networkURL != nil {
                Image(systemSymbol: .externaldriveFillBadgeWifi)
            } else {
                Image(systemSymbol: .externaldriveFillBadgeTimemachine)
            }
        }
        .imageScale(.large)
        .font(.title2)
        .foregroundStyle(.secondary)
    }

    private var volumeInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dest.lastKnownVolumeName ?? "dest_label_no_volume_name")
                    .font(.headline)
                if let latest = dest.snapshotDates?.max() {
                    Text(latest.formatted(.relativeDate))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            if let bytesUsed = dest.bytesUsed, let bytesAvailable = dest.bytesAvailable {
                let used = bytesUsed.formatted(byteFormat)
                let available = bytesAvailable.formatted(byteFormat)
                Text("dest_label_\(used)_used_\(available)_free")
                    .monospacedDigit()
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text("dest_label_no_size_info")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .lineLimit(1)
    }

    @ViewBuilder
    private var progressIndicator: some View {
        if isActive {
            ProgressView()
                .scaleEffect(0.4)
                .frame(height: 20)
        }
    }

    @ViewBuilder
    private var failureWarning: some View {
        if dest.lastBackupFailed && !isActive {
            Button {
                NSWorkspace.shared.open(Constants.URLs.timeMachineSystemSettings)
            } label: {
                Image(systemSymbol: .exclamationmarkTriangleFill)
                    .foregroundStyle(.red)
                    .padding([.vertical, .leading], 4)
            }
            .buttonStyle(.plain)
            .focusable(false)
            .help("dest_label_last_backup_failed")
        }
    }

    @ViewBuilder
    private var startStopButton: some View {
        if !utility.isIdle && !isActive {
            EmptyView()
        } else {
            Button {
                if utility.status.activeDestinationID == dest.destinationID {
                    utility.stopBackup()
                } else {
                    utility.startBackup(id: dest.destinationID)
                }
            } label: {
                if utility.status.activeDestinationID == dest.destinationID {
                    Image(systemSymbol: .stopFill)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13)
                } else {
                    Image(systemSymbol: .playFill)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13)
                }
            }
            .disabled(!utility.isIdle && !isActive)
            .buttonStyle(.custom)
            .focusable(false)
        }
    }

    @ViewBuilder
    private var contextMenuActions: some View {
        let unknown = NSLocalizedString("dest_label_no_volume_name", comment: "")
        Button("button_show_info") { showInfo.toggle() }
        Divider()
        Button("button_backup_to_\(dest.lastKnownVolumeName ?? unknown)_now") {
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
                if let findingChanges {
                    Text("dest_label_progress_found\(findingChanges.itemsFound)")
                }
                if let copying {
                    if let bytes = copying.progress.bytes, let files = copying.progress.files {
                        Text("dest_label_progress_\(files)_files_\(bytes.formatted(byteFormat))")
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
        GeometryReader { geometry in
            if let percent = utility.status.progessPercentage {
                Color.accentColor
                    .frame(width: geometry.size.width * percent)
                    .opacity(0.3)
                    .animation(.easeInOut, value: percent)
            }
        }
    }

    private var byteFormat: ByteCountFormatStyle {
        .byteCount(style: .file)
    }
}

import Sparkle

#Preview("Light") {
    MenuView(
        utility: TMUtilityMock(preferences: .mock),
        updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater
    )
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    MenuView(
        utility: TMUtilityMock(preferences: .mock),
        updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater
    )
    .preferredColorScheme(.dark)
}
