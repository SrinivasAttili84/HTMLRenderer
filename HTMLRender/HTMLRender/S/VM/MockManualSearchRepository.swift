//
//  MockManualSearchRepository.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import Foundation

struct MockManualSearchRepository: ManualSearchRepositoryProtocol {

    func searchTroubleshooting(filters: [TroubleshootingFilter]) async throws -> [TroubleshootingResult] {
        [
            TroubleshootingResult(
                id: "1",
                titlePrefix: "ECAM Alert:",
                title: "ECAM Warning - 32-00-",
                highlightedText: "BRAKES SYS 1 FAULT",
                message: "No associated message",
                referenceTask: "32-42-00-810-913-A"
            ),
            TroubleshootingResult(
                id: "2",
                titlePrefix: "Fault Message:",
                title: "32-42:34 - BSCU (10GG) - Source: BSCU 1- Class: 1",
                highlightedText: nil,
                message: "Correlated ECAM Alert: ECAM Warning - 32-00- Brakes SYS 1 FAULT",
                referenceTask: "32-42-00-810-913-A"
            ),
            TroubleshootingResult(
                id: "3",
                titlePrefix: "ECAM Alert:",
                title: "ECAM Warning - 32-00-",
                highlightedText: "BRAKES - PARK BRK FAULT // BRK PRESS RELEASED",
                message: "No associated message",
                referenceTask: "32-45-00-810-003-A"
            )
        ]
    }

    func searchManualText(manualType: ManualType, query: String) async throws -> [SearchResult] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        return [
            SearchResult(
                id: "1",
                title: "\(manualType.rawValue) Search Result",
                path: "32-42-00",
                snippet: "Matching content found for \(query)"
            )
        ]
    }
}
