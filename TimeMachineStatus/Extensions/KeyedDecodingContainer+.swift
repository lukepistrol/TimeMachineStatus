//
//  Decodable+.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 17.09.24.
//        
//  Copyright © 2024 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import Foundation

extension KeyedDecodingContainer {
    func decodeBoolOrIntIfPresent(for key: K, defaultValue: Bool? = nil) throws -> Bool? {
        if let boolValue = try? decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        } else if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return intValue == 1
        } else {
            return defaultValue
        }
    }
}
