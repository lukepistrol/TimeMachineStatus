//
//  SettingsView.swift
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

enum StorageKeys {

    struct Key<Value: Any> {
        let id: String
        let `default`: Value
    }

    static let horizontalPadding = Key(id: "horizontalPadding", default: 0.0)
    static let verticalPadding = Key(id: "verticalPadding", default: 0.0)
    static let boldFont = Key(id: "boldFont", default: false)
    static let boldIcon = Key(id: "boldIcon", default: false)
    static let showStatus = Key(id: "showStatus", default: true)
    static let spacing = Key(id: "spacing", default: 4.0)
    static let backgroundColor = Key(id: "backgroundColor", default: Color.clear)
    static let cornerRadius = Key(id: "cornerRadius", default: 5.0)
    static let showPercentage = Key(id: "showPercentage", default: true)
}

struct SettingsView: View {

    @AppStorage(StorageKeys.horizontalPadding.id)
    private var horizontalPadding: Double = StorageKeys.horizontalPadding.default

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

    private enum Tabs: Hashable, CaseIterable {
        case general
        case appearance
        case about

        var height: Double {
            switch self {
            case .about: 350
            case .appearance: 410
            case .general: 250
            }
        }

        static var largestHeight: Double {
            Self.allCases.map(\.height).max() ?? 100
        }
    }

    @State private var selection: Tabs = .general
    @StateObject private var launchItemProvider = LaunchItemProvider()
    @ObservedObject private var updaterViewModel: UpdaterViewModel
    private let updater: SPUUpdater

    init(updater: SPUUpdater) {
        self.updater = updater
        self.updaterViewModel = UpdaterViewModel(updater: updater)
    }

    var body: some View {
        TabView(selection: $selection) {
            generalTab
            appearandeTab
            aboutTab
        }
        .frame(
            width: Constants.Sizes.settingsWidth,
            height: isPreview ? Tabs.largestHeight : selection.height
        )
    }

    private var generalTab: some View {
        Form {
            Section("settings_section_permissions") {
                VStack(alignment: .leading) {
                    Text("settings_item_fulldiskaccess_title")
                    Text("settings_item_fulldiskaccess_description")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Spacer()
                    Button("button_opensystemsettings") {
                        NSWorkspace.shared.open(Constants.URLs.settingsFullDiskAccess)
                    }
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Toggle("settings_item_launchatlogin", isOn: $launchItemProvider.launchAtLogin)
                        .disabled(launchItemProvider.requiresApproval)
                    if launchItemProvider.requiresApproval {
                        Text("settings_item_launchatlogin_approval_notice")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle(
                    "settings_item_autocheckupdates",
                    isOn: $updaterViewModel.automaticallyChecksForUpdates
                )
            }
        }
        .formStyle(.grouped)
        .tabItem {
            Label("settings_tab_item_general", systemImage: Symbols.gear())
        }
        .tag(Tabs.general)
    }

    private var appearandeTab: some View {
        Form {
            Section("settings_section_menubaritem") {
                LabeledContent {
                    HStack {
                        Text(horizontalPadding.formatted(.number) + " pt")
                        Stepper("", value: $horizontalPadding, in: 0...10, step: 1)
                            .labelsHidden()
                    }
                } label: {
                    Text("settings_item_horizontalpadding")
                }
            }
            Section {
                HStack {
                    ColorPicker("settings_item_backgroundcolor", selection: $bgColor)
                    Button("settings_button_default") {
                        bgColor = .clear
                    }
                }
                if bgColor.cgColor?.alpha != 0 {
                    LabeledContent {
                        HStack {
                            Text(verticalPadding.formatted(.number) + " pt")
                            Stepper("", value: $verticalPadding, in: 0...5, step: 1)
                                .labelsHidden()
                        }
                    } label: {
                        Text("settings_item_verticalpadding")
                    }
                    LabeledContent {
                        HStack {
                            Text(cornerRadius.formatted(.number) + " pt")
                            Stepper("", value: $cornerRadius, in: 0...12, step: 1)
                                .labelsHidden()
                        }
                    } label: {
                        Text("settings_item_cornerradius")
                    }
                }
            }
            Section {
                Toggle("settings_item_boldfont", isOn: $boldFont)
                Toggle("settings_item_boldicon", isOn: $boldIcon)
            }
            Section {
                Toggle("settings_item_showstatus", isOn: $showStatus)
                Toggle("settings_item_showpercentage", isOn: $showPercentage)
                if showStatus || showPercentage {
                    LabeledContent {
                        HStack {
                            Text(spacing.formatted(.number) + " pt")
                            Stepper("", value: $spacing, in: 2...12, step: 1)
                                .labelsHidden()
                        }
                    } label: {
                        Text("settings_item_spacing")
                    }
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button("settings_button_resettodefault", role: .destructive) {
                        horizontalPadding = StorageKeys.horizontalPadding.default
                        verticalPadding = StorageKeys.verticalPadding.default
                        boldFont = StorageKeys.boldFont.default
                        boldIcon = StorageKeys.boldIcon.default
                        showStatus = StorageKeys.showStatus.default
                        showPercentage = StorageKeys.showPercentage.default
                        spacing = StorageKeys.spacing.default
                        bgColor = StorageKeys.backgroundColor.default
                        cornerRadius = StorageKeys.cornerRadius.default
                    }
                }
            }
        }
        .formStyle(.grouped)
        .tabItem {
            Label("settings_tab_item_appearance", systemImage: Symbols.wandAndStarsInverse())
        }
        .tag(Tabs.appearance)
    }

    private var aboutTab: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128)
                Text(Bundle.appName)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Version " + Bundle.appVersionString + " (" + Bundle.appBuildString + ")")
                    .font(.headline)
                Button("settings_button_checkforupdates") {
                    updater.checkForUpdates()
                }
                .disabled(!updaterViewModel.canCheckForUpdates)
            }
            VStack {
                Text("about_copyright")
                Link("about_weblink", destination: Constants.URLs.authorURL)
            }
            .font(.caption2)
        }
        .tabItem {
            Label("settings_tab_item_about", systemImage: Symbols.infoCircle())
        }
        .tag(Tabs.about)
    }
}

#Preview {
    SettingsView(updater: SPUStandardUpdaterController(updaterDelegate: nil, userDriverDelegate: nil).updater)
}
