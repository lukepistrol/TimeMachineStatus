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
                if let lastKnownVolumeName = dest.lastKnownVolumeName {
                    LabeledContent("dest_info_name", value: lastKnownVolumeName)
                }
                if let lastKnownEncryptionState = dest.lastKnownEncryptionState {
                    LabeledContent("dest_info_encrypted", value: lastKnownEncryptionState)
                }
                if let networkURL = dest.networkURL {
                    LabeledContent("dest_info_url", value: networkURL)
                }
            }
            Section {
                if let filesystemTypeName = dest.filesystemTypeName {
                    LabeledContent("dest_info_filesystem", value: filesystemTypeName)
                }
                if let bytesUsed = dest.bytesUsed {
                    LabeledContent("dest_info_usedspace", value: bytesUsed.formatted(.byteCount(style: .file)))
                }
                if let bytesAvailable = dest.bytesAvailable {
                    LabeledContent("dest_info_freespace", value: bytesAvailable.formatted(.byteCount(style: .file)))
                }
                if let quotaGB = dest.quotaGB {
                    LabeledContent("dest_info_quota", value: Int(quotaGB * 1e9).formatted(.byteCount(style: .file)))
                }
            }
            Section {
                if let last = dest.snapshotDates?.max() {
                    LabeledContent("dest_info_lastbackup", value: last.formatted(.relativeDate))
                }
                if let last = dest.attemptDates?.max() {
                    LabeledContent("dest_info_lastattempt", value: last.formatted(.relativeDate))
                }
            }
        }
        .formStyle(.grouped)
        .labeledContentStyle(CustomLabeledContentStyle())
        .frame(width: 500)
    }
}
