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

    enum FocusedField {
        case startButton
        case settingsButton
    }

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing: 8) {
            UserfacingErrorView(error: utility.error)
            VStack(alignment: .leading) {
                if let destinations = utility.preferences?.destinations {
                    Section {
                        ForEach(destinations, id: \.destinationID) { dest in
                            DestinationCell(dest)
                                .frame(maxWidth: .infinity)
                                .environmentObject(utility)
                        }
                    } header: {
                        Text("Destinations")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
            }
            .padding()
            bottomToolbar
        }
        .defaultFocus($focusedField, .settingsButton)
        .frame(width: 360)
        .fixedSize()
    }

    private var bottomToolbar: some View {
        HStack {
            Button {
                if utility.isIdle {
                    utility.startBackup()
                } else {
                    utility.stopBackup()
                }
            } label: {
                Label("Start Backup", systemImage: utility.isIdle ? Symbols.playFill() : Symbols.stopFill())
            }
            .focused($focusedField, equals: .startButton)

            if let latestDate = utility.preferences?.latestBackupDate,
               let latestVolume = utility.preferences?.latestBackupVolume {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(latestDate.formatted(.relativeDate)) on \(latestVolume)")
                    if let interval = utility.preferences?.autoBackupInterval {
                        let nextDate = latestDate.addingTimeInterval(.init(interval))
                        Text("Next automatic backup in \(nextDate.formatted(.relativeDate))")
                            .font(.caption)
                    } else {
                        Text("Automatic backups are disabled")
                            .font(.caption)
                    }
                }
                .foregroundStyle(.secondary)
                .font(.caption2)
            }
            Spacer()
            SettingsLink {
                Label("Settings", systemImage: Symbols.gearshapeFill())
            }
            .focused($focusedField, equals: .settingsButton)
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

#Preview {
    MenuView(utility: .init())
//        .preferredColorScheme(.light)
}

struct UserfacingErrorView: View {
    let error: UserfacingError?

    @ViewBuilder
    var body: some View {
        if let error {
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Symbols.exclamationMarkTriangleFill.image
                        .foregroundStyle(.red)
                    Text(error.localizedDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.primary)
                }
                .font(.headline)
                if let failureReason = error.failureReason {
                    Text(failureReason)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                if let action = error.action {
                    Button(action.title) {
                        NSWorkspace.shared.open(action.url)
                    }
                }
            }
            .padding(8)
            .card(.fill)
            .padding()
        }
    }
}
