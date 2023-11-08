//
//  BackupStateError.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//  

enum BackupStateError: Error {
    case couldNotConvertStringToData(string: String)
    case couldNotConvertStringToDate(string: String)
    case failedToParseUUID(uuid: String)
    case invalidState(raw: String)
}
