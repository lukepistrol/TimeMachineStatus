//
//  MenuView.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import Sparkle
import SwiftUI

struct MenuView: View {
    @State private var utility: any TMUtility
    @ObservedObject private var updaterViewModel: UpdaterViewModel
    private let updater: SPUUpdater

    init(utility: any TMUtility, updater: SPUUpdater) {
        self.utility = utility
        self.updater = updater
        self.updaterViewModel = UpdaterViewModel(updater: updater)
    }

    var body: some View {
        VStack(spacing: 8) {
            UserfacingErrorView(error: utility.error)
            VStack(spacing: 16) {
                destinationsSection
                generalInfoSection
            }
            .padding()
            bottomToolbar
        }
        .frame(width: Constants.Sizes.popoverWidth)
        .fixedSize()
        .navigationTitle("window_title")
        .background(.regularMaterial, in: .rect)
    }

    @ViewBuilder
    private var destinationsSection: some View {
        if let destinations = utility.preferences?.destinations {
            ExpandableSection {
                VStack(alignment: .leading) {
                    ForEach(destinations, id: \.destinationID) { dest in
                        DestinationCell(dest, utility: utility)
                            .frame(maxWidth: .infinity)
                    }
                }
            } header: {
                Text("section_destinations")
            }
            .listRowSeparator(.hidden, edges: .all)
        }
    }

    @ViewBuilder
    private var generalInfoSection: some View {
        if let preferences = utility.preferences {
            ExpandableSection(expanded: false) {
                VStack {
                    if let volumeName = preferences.localizedDiskImageVolumeName {
                        LabeledContent("general_info_volumename", value: volumeName)
                            .padding(10)
                            .card(.background.secondary)
                    }
                    if let autoBackup = preferences.autoBackup {
                        LabeledContent("general_info_autobackup") {
                            if autoBackup {
                                Text("general_info_autobackup_enabled")
                            } else {
                                Text("general_info_autobackup_disabled")
                            }
                        }
                        .padding(10)
                        .card(.background.secondary)
                        if let interval = preferences.autoBackupInterval, autoBackup {
                            let measurement = Measurement(
                                value: Double(interval),
                                unit: UnitDuration.seconds
                            ).converted(to: .hours)
                            LabeledContent(
                                "general_info_interval",
                                value: measurement.formatted(.measurement(width: .wide))
                            )
                            .padding(10)
                            .card(.background.secondary)
                        }
                    }
                    if let requiresACPower = preferences.requiresACPower {
                        LabeledContent("general_info_requirespower") {
                            if requiresACPower {
                                Text("general_info_requirespower_true")
                            } else {
                                Text("general_info_requirespower_false")
                            }
                        }
                        .padding(10)
                        .card(.background.secondary)
                    }
                    LabeledContent("general_info_skippaths") {
                        VStack(alignment: .trailing, spacing: 4) {
                            if let skipPaths = preferences.skipPaths {
                                ForEach(skipPaths, id: \.self) { path in
                                    Text(path)
                                }
                            } else {
                                Text("general_info_skippaths_empty")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .card(.background.secondary)
                }
            } header: {
                Text("section_general_info")
            }
            .labeledContentStyle(CustomLabeledContentStyle())
        }
    }

    private var bottomToolbar: some View {
        HStack(spacing: 12) {
            Button {
                if utility.isIdle {
                    utility.startBackup()
                } else {
                    utility.stopBackup()
                }
            } label: {
                Label("button_startbackup", systemSymbol: utility.isIdle ? .playFill : .stopFill)
            }
            .focusable(false)
            toolbarStatus
            Spacer()

            toolbarMenu
        }
        .lineLimit(1)
        .imageScale(.large)
        .labelStyle(.iconOnly)
        .buttonStyle(.custom)
        .padding(.horizontal)
        .frame(height: 42)
        .frame(maxWidth: .infinity)
        .background(Material.bar, in: .rect)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    @ViewBuilder
    private var toolbarStatus: some View {
        if let activeUUID = utility.status.activeDestinationID,
           let destination = utility.preferences?.destinations?.first(where: { $0.destinationID == activeUUID }) {
            let unknown = NSLocalizedString("dest_label_no_volume_name", comment: "")
            VStack(alignment: .leading, spacing: 0) {
                Text("label_currentbackup_\(destination.lastKnownVolumeName ?? unknown)")
                HStack(spacing: 0) {
                    Text(utility.status.statusString)
                    if let percentage = utility.status.progessPercentage {
                        Text(verbatim: " – " + percentage.formatted(.percent.precision(.fractionLength(0))))
                    }
                }
                .font(.caption)
                .opacity(0.8)
            }
            .foregroundStyle(.secondary)
            .font(.caption2)
        } else {
            if let latestDate = utility.preferences?.latestBackupDate,
               let latestVolume = utility.preferences?.latestBackupVolume {
                VStack(alignment: .leading, spacing: 0) {
                    Text("label_lastbackup_\(latestDate.formatted(.relativeDate))_on_\(latestVolume)")
                    if let interval = utility.preferences?.autoBackupInterval, utility.preferences?.autoBackup == true {
                        let nextDate = latestDate.addingTimeInterval(.init(interval))
                        if nextDate < .now {
                            Text("label_nextbackup_issue")
                                .font(.caption)
                        } else {
                            Text("label_nextbackup_\(nextDate.formatted(.relativeDate))")
                                .font(.caption)
                        }
                    } else {
                        Text("label_autobackupdisabled")
                            .font(.caption)
                            .opacity(0.8)
                    }
                }
                .foregroundStyle(.secondary)
                .font(.caption2)
            }
        }
    }

    private var toolbarMenu: some View {
        Menu {
            SettingsLink {
                Text("settings_button_settings")
            }
            .keyboardShortcut(",", modifiers: .command)
            Button("settings_button_checkforupdates") {
                updater.checkForUpdates()
            }
            .disabled(!updaterViewModel.canCheckForUpdates)
            Divider()
            Button("button_browsebackups") {
                utility.launchTimeMachine()
            }
            Button("button_time_machine_system_settings") {
                NSWorkspace.shared.open(Constants.URLs.timeMachineSystemSettings)
            }
            Divider()
            Menu("button_feedback") {
                Button("button_bug_report_feature_request") {
                    NSWorkspace.shared.open(Constants.URLs.bugReport)
                }
                Divider()
                Button("button_view_issues") {
                    NSWorkspace.shared.open(Constants.URLs.issues)
                }
            }
            Menu("button_support_project") {
                Button("button_github_sponsor") {
                    NSWorkspace.shared.open(Constants.URLs.githubSponsor)
                }
                Button("button_buymeacoffee") {
                    NSWorkspace.shared.open(Constants.URLs.buymeacoffee)
                }
            }
            Divider()
            Button {
                NSApp.terminate(nil)
            } label: {
                Text("button_quit")
            }
            .keyboardShortcut("q", modifiers: .command)
        } label: {
            Label {
                Text("settings_button_settings")
            } icon: {
                Image(.iconPlain)
                    .shadow(
                        color: .black.opacity(0.8),
                        radius: 0.5,
                        x: 0,
                        y: 0.5
                    )
            }
        }
        .focusable(false)
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    MenuView(
        utility: TMUtilityMock(preferences: .mock),
        updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater
    )
    .preferredColorScheme(.light)
}

#Preview("Light Error") {
    MenuView(
        utility: TMUtilityMock(preferences: .mock, error: .preferencesFilePermissionNotGranted, canReadPreferences: false),
        updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater
    )
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    MenuView(
        utility: TMUtilityImpl(),
        updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater
    )
    .preferredColorScheme(.dark)
}
