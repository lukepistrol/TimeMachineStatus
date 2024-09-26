//
//  Color+RawRepresentable.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

import SwiftUI

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }

        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) ?? .labelColor
            self = Color(color)
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: NSColor(self),
                requiringSecureCoding: false
            ) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
