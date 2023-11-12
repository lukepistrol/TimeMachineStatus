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
                Text("Destinations")
            }
            .listRowSeparator(.hidden, edges: .all)
        }
    }

    @ViewBuilder
    private var generalInfoSection: some View {
        if let preferences = utility.preferences {
            ExpandableSection(expanded: false) {
                VStack {
                    LabeledContent("Image Volume Name", value: preferences.localizedDiskImageVolumeName)
                        .padding(10)
                        .card(.background.secondary)
                    LabeledContent("Auto Backup", value: preferences.autoBackup ? "Enabled" : "Disabled")
                        .padding(10)
                        .card(.background.secondary)
                    if let interval = preferences.autoBackupInterval, preferences.autoBackup {
                        let measurement = Measurement(value: Double(interval), unit: UnitDuration.seconds).converted(to: .hours)
                        LabeledContent("Backup Interval", value: measurement.formatted(.measurement(width: .wide)))
                            .padding(10)
                            .card(.background.secondary)
                    }
                    LabeledContent("Requires Power", value: preferences.requiresACPower ? "Yes" : "No")
                        .padding(10)
                        .card(.background.secondary)
                    LabeledContent("Skip Paths") {
                        VStack(alignment: .trailing, spacing: 4) {
                            if let skipPaths = preferences.skipPaths {
                                ForEach(skipPaths, id: \.self) { path in
                                    Text(path)
                                }
                            } else {
                                Text("Empty")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .card(.background.secondary)
                }
            } header: {
                Text("General Info")
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
                Label("Start Backup", systemImage: utility.isIdle ? Symbols.playFill() : Symbols.stopFill())
            }
            .focusable(false)

            if let latestDate = utility.preferences?.latestBackupDate,
               let latestVolume = utility.preferences?.latestBackupVolume {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(latestDate.formatted(.relativeDate)) on \(latestVolume)")
                    if let interval = utility.preferences?.autoBackupInterval, utility.preferences?.autoBackup == true {
                        let nextDate = latestDate.addingTimeInterval(.init(interval))
                        Text("Next automatic backup in \(nextDate.formatted(.relativeDate))")
                            .font(.caption)
                    } else {
                        Text("Automatic backups are disabled")
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
                    Text("Settings")
                }
                Button("Browse Time Machine Backups") {
                    utility.launchTimeMachine()
                }
                Divider()
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Text("Quit")
                }
            } label: {
                Label("Settings", systemImage: Symbols.gearshapeFill())
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
