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
                Text("\(latestDate.formatted(.relativeDate)) on \(latestVolume)")
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
        .preferredColorScheme(.light)
}
