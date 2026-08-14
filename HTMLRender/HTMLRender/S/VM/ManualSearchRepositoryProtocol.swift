//
//  ManualSearchRepositoryProtocol.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import Foundation

protocol ManualSearchRepositoryProtocol {
    func searchTroubleshooting(filters: [TroubleshootingFilter]) async throws -> [TroubleshootingResult]
    func searchManualText(manualType: ManualType, query: String) async throws -> [SearchResult]
}
