//
//  InitializeView.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 02.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct InitializeView: View {
    @Environment(\.dismiss) private var dismiss

    @State var utility: any TMUtility

    @State private var showPicker = false

    var body: some View {
        Group {
            if case .preferencesFilePermissionNotGranted = utility.error {
                VStack {
                    VStack {
                        Image(.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                        Text("settings_item_preferences_file_permission")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                    }
                    .padding(.bottom)
                    VStack {
                        Button {
                            showPicker = true
                        } label: {
                            Text("button_grant_access")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                        Button {
                            dismiss()
                        } label: {
                            Text("button_close")
                                .frame(maxWidth: .infinity)
                        }
                        .controlSize(.large)
                    }
                }
            } else {
                VStack {
                    Image(.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                    HStack {
                        ProgressView()
                            .controlSize(.small)
                        Text("label_initializing")
                    }
                }
            }
        }
        .padding()
        .frame(width: 300)
        .backgroundVisualEffect(.hudWindow)
        .task {
            if utility.canReadPreferences {
                try? await Task.sleep(for: .seconds(1))
                dismiss()
            } else {
                utility.error = .preferencesFilePermissionNotGranted
            }
        }
        .preferencesFileImporter($showPicker)
        .hideWindowControls()
    }
}

#Preview("Access") {
    InitializeView(utility: TMUtilityMock(canReadPreferences: true))
}

#Preview("No Access") {
    InitializeView(
        utility: TMUtilityMock(
            error: .preferencesFilePermissionNotGranted,
            canReadPreferences: false
        )
    )
}
