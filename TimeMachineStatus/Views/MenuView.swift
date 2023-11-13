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

import SwiftUI
import Combine

struct MenuView: View {
    @Environment(\.openWindow) private var openWindow

    @ObservedObject var utility: TMUtility

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
        .frame(width: 360)
        .fixedSize()
    }

    @ViewBuilder
    private var destinationsSection: some View {
        if let destinations = utility.preferences?.destinations {
            ExpandableSection {
                VStack(alignment: .leading) {
                    ForEach(destinations, id: \.destinationID) { dest in
                        DestinationCell(dest)
                            .frame(maxWidth: .infinity)
                            .environmentObject(utility)
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
                    LabeledContent("general_info_volumename", value: preferences.localizedDiskImageVolumeName)
                        .padding(10)
                        .card(.background.secondary)
                    LabeledContent("general_info_autobackup", value: preferences.autoBackup ? "Enabled" : "Disabled")
                        .padding(10)
                        .card(.background.secondary)
                    if let interval = preferences.autoBackupInterval, preferences.autoBackup {
                        let measurement = Measurement(value: Double(interval), unit: UnitDuration.seconds).converted(to: .hours)
                        LabeledContent("general_info_interval", value: measurement.formatted(.measurement(width: .wide)))
                            .padding(10)
                            .card(.background.secondary)
                    }
                    LabeledContent("general_info_requirespower", value: preferences.requiresACPower ? "Yes" : "No")
                        .padding(10)
                        .card(.background.secondary)
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
                Label("button_startbackup", systemImage: utility.isIdle ? Symbols.playFill() : Symbols.stopFill())
            }
            .focusable(false)

            if let latestDate = utility.preferences?.latestBackupDate,
               let latestVolume = utility.preferences?.latestBackupVolume {
                VStack(alignment: .leading, spacing: 0) {
                    Text("label_lastbackup_\(latestDate.formatted(.relativeDate))_on_\(latestVolume)")
                    if let interval = utility.preferences?.autoBackupInterval, utility.preferences?.autoBackup == true {
                        let nextDate = latestDate.addingTimeInterval(.init(interval))
                        Text("label_nextbackup_\(nextDate.formatted(.relativeDate))")
                            .font(.caption)
                    } else {
                        Text("label_autobackupdisabled")
                            .font(.caption)
                            .opacity(0.8)
                    }
                }
                .foregroundStyle(.secondary)
                .font(.caption2)
            }
            Spacer()

            Menu {
                SettingsLink {
                    Text("settings_button_settings")
                }
                .keyboardShortcut(",", modifiers: .command)
                Button("button_browsebackups") {
                    utility.launchTimeMachine()
                }
                Divider()
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Text("button_quit")
                }
                .keyboardShortcut("q", modifiers: .command)
            } label: {
                Label("settings_button_settings", systemImage: Symbols.gearshapeFill())
            }
            .focusable(false)
        }
        .imageScale(.large)
        .labelStyle(.iconOnly)
        .buttonStyle(.custom)
        .padding(.horizontal)
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Material.bar, in: .rect)
        .overlay(alignment: .top) {
            Divider()
        }
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
