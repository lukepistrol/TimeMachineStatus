//
//  PreferencesFileImporterViewModifier.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 01.10.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//

import SwiftUI

struct PreferencesFileImporterViewModifier: ViewModifier {
    @Binding var showPicker: Bool

    func body(content: Content) -> some View {
        content
            .fileImporter(isPresented: $showPicker, allowedContentTypes: [.propertyList]) { _ in }
            .fileDialogDefaultDirectory(Constants.URLs.timeMachinePreferencesPlist)
            .fileDialogMessage(Text("dialog_label_select_file_\(lastPathComponent)"))
            .fileDialogConfirmationLabel(Text("button_select"))
            .fileDialogURLEnabled(#Predicate<URL> { url in
                url.lastPathComponent == lastPathComponent
            })
    }

    private var lastPathComponent: String { Constants.URLs.timeMachinePreferencesPlist.lastPathComponent }
}

extension View {
    func preferencesFileImporter(_ showPicker: Binding<Bool>) -> some View {
        modifier(PreferencesFileImporterViewModifier(showPicker: showPicker))
    }
}
