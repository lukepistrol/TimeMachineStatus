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
                LabeledContent("dest_info_name", value: dest.lastKnownVolumeName)
                LabeledContent("dest_info_encrypted", value: dest.lastKnownEncryptionState)
                if let networkURL = dest.networkURL {
                    LabeledContent("dest_info_url", value: networkURL)
                }
            }
            Section {
                LabeledContent("dest_info_filesystem", value: dest.filesystemTypeName)
                LabeledContent("dest_info_usedspace", value: dest.bytesUsed.formatted(.byteCount(style: .file)))
                LabeledContent("dest_info_freespace", value: dest.bytesAvailable.formatted(.byteCount(style: .file)))
                if let quotaGB = dest.quotaGB {
                    LabeledContent("dest_info_quota", value: Int(quotaGB * 1e9).formatted(.byteCount(style: .file)))
                }
            }
            Section {
                if let last = dest.snapshotDates.max() {
                    LabeledContent("dest_info_lastbackup", value: last.formatted(.relativeDate))
                }
                if let last = dest.attemptDates.max() {
                    LabeledContent("dest_info_lastattempt", value: last.formatted(.relativeDate))
                }
            }
        }
        .formStyle(.grouped)
        .labeledContentStyle(CustomLabeledContentStyle())
        .frame(width: 500)
    }
}
