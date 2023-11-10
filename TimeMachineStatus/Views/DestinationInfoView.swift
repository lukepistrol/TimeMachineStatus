//
//  DestinationInfoView.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//        
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//        
//  See LICENSE.md for license information.
//  

import SwiftUI

struct DestinationInfoView: View {
    let dest: Destination
    var body: some View {
        Form {
            Section {
                LabeledContent("Name", value: dest.lastKnownVolumeName)
                LabeledContent("Encrypted", value: dest.lastKnownEncryptionState)
                if let networkURL = dest.networkURL {
                    LabeledContent("URL", value: networkURL)
                }
            }
            Section {
                LabeledContent("Filesystem", value: dest.filesystemTypeName)
                LabeledContent("Used Space", value: dest.bytesUsed.formatted(.byteCount(style: .file)))
                LabeledContent("Free Space", value: dest.bytesAvailable.formatted(.byteCount(style: .file)))
                if let quotaGB = dest.quotaGB {
                    LabeledContent("Quota", value: Int(quotaGB * 1e9).formatted(.byteCount(style: .file)))
                }
            }
            Section {
                if let last = dest.snapshotDates.max() {
                    LabeledContent("Last Backup", value: last.formatted(.relativeDate))
                }
                if let last = dest.attemptDates.max() {
                    LabeledContent("Last Attempt", value: last.formatted(.relativeDate))
                }
            }
        }
        .formStyle(.grouped)
        .labeledContentStyle(CustomLabeledContentStyle())
        .frame(width: 500)
    }
}
