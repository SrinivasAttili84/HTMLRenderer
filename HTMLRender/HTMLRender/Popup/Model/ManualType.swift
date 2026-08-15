//
//  ManualType.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 15/08/26.
//

import Foundation

enum ManualType: String, CaseIterable, Identifiable {
    case amm = "AMM"
    case tsm = "TSM"
    case ipc = "IPC"
    case srm = "SRM"
    case others = "Others"

    var id: String { rawValue }

    var displayName: String {
        rawValue
    }
}
