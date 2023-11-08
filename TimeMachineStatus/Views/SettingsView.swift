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

import SwiftUI

enum StorageKeys {

    struct Key<Value: Any> {
        let id: String
        let `default`: Value
    }

    static let padding = Key(id: "padding", default: 0.0)
    static let boldFont = Key(id: "boldFont", default: false)
    static let showStatus = Key(id: "showStatus", default: false)
    static let spacing = Key(id: "spacing", default: 4.0)
    static let backgroundColor = Key(id: "backgroundColor", default: Color.clear)
    static let cornerRadius = Key(id: "cornerRadius", default: 5.0)
}

struct SettingsView: View {

    @AppStorage(StorageKeys.padding.id) 
    private var padding: Double = StorageKeys.padding.default
    
    @AppStorage(StorageKeys.boldFont.id)
    private var boldFont: Bool = StorageKeys.boldFont.default
    
    @AppStorage(StorageKeys.showStatus.id)
    private var showStatus: Bool = StorageKeys.showStatus.default
    
    @AppStorage(StorageKeys.spacing.id)
    private var spacing: Double = StorageKeys.spacing.default

    @AppStorage(StorageKeys.backgroundColor.id)
    private var bgColor: Color = StorageKeys.backgroundColor.default
    
    @AppStorage(StorageKeys.cornerRadius.id)
    private var cornerRadius: Double = StorageKeys.cornerRadius.default

    private enum Tabs: Hashable {
        case general
        case appearance
        case about
    }

    @State private var selection: Tabs = .appearance

    var body: some View {
        TabView(selection: $selection) {
            generalTab
            appearandeTab
            aboutTab
        }
        .frame(width: 375, height: 420)
    }

    private var generalTab: some View {
        Text("General")
            .tabItem {
                Label("General", systemImage: "gear")
            }
            .tag(Tabs.general)
    }

    private var appearandeTab: some View {
        Form {
            Section("Menu Bar Item") {
                LabeledContent {
                    HStack {
                        Text(padding.formatted(.number))
                        Slider(value: $padding, in: 0...10, step: 1)
                    }
                } label: {
                    Text("Padding")
                }
                HStack {
                    ColorPicker("Background Color", selection: $bgColor)
                    Button("Default") {
                        bgColor = .clear
                    }
                }
                if bgColor.cgColor?.alpha != 0 {
                    LabeledContent {
                        HStack {
                            Text(cornerRadius.formatted(.number))
                            Slider(value: $cornerRadius, in: 0...12, step: 1)
                        }
                    } label: {
                        Text("Corner Radius")
                    }
                }
                Toggle("Bold font", isOn: $boldFont)
                Toggle("Show Status", isOn: $showStatus)
                if showStatus {
                    LabeledContent {
                        HStack {
                            Text(spacing.formatted(.number))
                            Slider(value: $spacing, in: 2...12, step: 1)
                        }
                    } label: {
                        Text("Spacing")
                    }
                }
            }
            Section {
                Button("Reset To Default") {
                    padding = StorageKeys.padding.default
                    boldFont = StorageKeys.boldFont.default
                    showStatus = StorageKeys.showStatus.default
                    spacing = StorageKeys.spacing.default
                    bgColor = StorageKeys.backgroundColor.default
                    cornerRadius = StorageKeys.cornerRadius.default
                }
                .buttonStyle(.link)
                .foregroundStyle(.red)
                .font(.body.weight(.semibold))
            }
        }
        .formStyle(.grouped)
        .tabItem {
            Label("Appearance", systemImage: "wand.and.stars.inverse")
        }
        .tag(Tabs.appearance)
    }

    private var aboutTab: some View {
        VStack(spacing: 20) {
            Image(.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128)
            VStack(spacing: 8) {
                Text(Bundle.appName)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Version " + Bundle.appVersionString + " (" + Bundle.appBuildString + ")")
                    .font(.headline)
            }
            VStack {
                Text("© 2021 Lukas Pistrol")
                Link("lukaspistrol.com", destination: URL(string: "https://lukaspistrol.com")!)
            }
            .font(.caption2)
        }
        .tabItem {
            Label("About", systemImage: "info.circle")
        }
        .tag(Tabs.about)
    }
}

#Preview {
    SettingsView()
}

public extension Bundle {
    static var appName: String {
        if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return ""
    }

    static var appVersionString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }

    static var appBuildString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return version
        }
        return ""
    }
}
