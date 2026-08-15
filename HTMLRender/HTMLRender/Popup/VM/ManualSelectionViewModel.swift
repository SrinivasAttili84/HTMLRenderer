//
//  ManualSelectionViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 15/08/26.
//

import Foundation
import Combine

protocol ManualSelectionRepositoryProtocol {

    func fetchManuals(
        manualType: ManualType
    ) async throws -> [ManualSelectionItem]
}

@MainActor
final class ManualSelectionViewModel: ObservableObject {

    @Published var searchText: String = ""

    @Published var selectedCustomisation: String?

    @Published var selectedAircraftType: String?

    @Published private(set)
    var manuals: [ManualSelectionItem] = []

    let manualType: ManualType

    private let repository: ManualSelectionRepositoryProtocol

    init(
        manualType: ManualType,
        repository: ManualSelectionRepositoryProtocol
    ) {
        self.manualType = manualType
        self.repository = repository
    }

    func load() {

    }

    func selectManual(
        _ item: ManualSelectionItem
    ) {

    }

    func openFilters() {

    }

    func close() {

    }
}
