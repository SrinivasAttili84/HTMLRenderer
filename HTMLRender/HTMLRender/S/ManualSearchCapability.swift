//
//  ManualSearchCapability.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import Foundation

enum ManualType: String, Hashable {
    case amm = "AMM"
    case tsm = "TSM"
    case ipc = "IPC"
    case srm = "SRM"
    case others = "Others"
}

enum ManualSearchMode: String, CaseIterable, Identifiable, Hashable {
    case troubleshooting = "Troubleshooting"
    case search = "Search"

    var id: String { rawValue }
}

struct ManualSearchCapability {
    let manualType: ManualType
    let supportedModes: [ManualSearchMode]

    var defaultMode: ManualSearchMode {
        supportedModes.first ?? .search
    }

    var supportsTabs: Bool {
        supportedModes.count > 1
    }
}

extension ManualType {
    var searchCapability: ManualSearchCapability {
        switch self {
        case .tsm:
            return ManualSearchCapability(
                manualType: self,
                supportedModes: [.troubleshooting, .search]
            )

        case .amm, .ipc, .srm, .others:
            return ManualSearchCapability(
                manualType: self,
                supportedModes: [.search]
            )
        }
    }
}
