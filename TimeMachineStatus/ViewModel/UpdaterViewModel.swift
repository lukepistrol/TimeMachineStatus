//
//  UpdaterViewModel.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 14.11.23.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation
import Sparkle
import Combine

class UpdaterViewModel: ObservableObject {
    @Published private (set) var canCheckForUpdates = false
    @Published var automaticallyChecksForUpdates: Bool {
        didSet {
            print(automaticallyChecksForUpdates)
            updater.automaticallyChecksForUpdates = automaticallyChecksForUpdates
        }
    }

    private let updater: SPUUpdater

    init(updater: SPUUpdater) {
        self.updater = updater
        self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        self.updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
        self.updater.publisher(for: \.automaticallyChecksForUpdates)
            .assign(to: &$automaticallyChecksForUpdates)
    }
}
