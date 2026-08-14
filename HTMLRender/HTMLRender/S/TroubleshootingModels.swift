//
//  TroubleshootingModels.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import Foundation

enum TroubleshootingFilterType: String, CaseIterable, Identifiable, Hashable {
    case ecamAlert = "ECAM Alert"
    case faultMessage = "Fault Message"
    case observedFailure = "Observed Failure"

    var id: String { rawValue }
}

struct TroubleshootingFilter: Identifiable, Hashable {
    let id: UUID
    var type: TroubleshootingFilterType
    var ataRef: String
    var description: String
    var isExpanded: Bool

    init(
        id: UUID = UUID(),
        type: TroubleshootingFilterType = .ecamAlert,
        ataRef: String = "XX-XX-XX",
        description: String = "",
        isExpanded: Bool = true
    ) {
        self.id = id
        self.type = type
        self.ataRef = ataRef
        self.description = description
        self.isExpanded = isExpanded
    }
}

struct TroubleshootingResult: Identifiable, Hashable {
    let id: String
    let titlePrefix: String
    let title: String
    let highlightedText: String?
    let message: String
    let referenceTask: String
}

struct SearchResult: Identifiable, Hashable {
    let id: String
    let title: String
    let path: String
    let snippet: String
}
