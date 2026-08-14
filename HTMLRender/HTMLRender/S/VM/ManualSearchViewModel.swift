//
//  ManualSearchViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

@MainActor
final class ManualSearchViewModel: ObservableObject {

    @Published private(set) var capability: ManualSearchCapability
    @Published var selectedMode: ManualSearchMode

    @Published var filters: [TroubleshootingFilter]
    @Published private(set) var troubleshootingResults: [TroubleshootingResult] = []

    @Published var searchText: String = ""
    @Published private(set) var searchResults: [SearchResult] = []

    private let repository: ManualSearchRepositoryProtocol

    init(
        manualType: ManualType,
        repository: ManualSearchRepositoryProtocol
    ) {
        let capability = manualType.searchCapability
        self.capability = capability
        self.selectedMode = capability.defaultMode
        self.repository = repository

        self.filters = [
            TroubleshootingFilter(
                type: .ecamAlert,
                ataRef: "XX-XX-XX",
                description: "Brakes SYS 1 FAULT",
                isExpanded: true
            )
        ]
    }

    func selectMode(_ mode: ManualSearchMode) {
        guard capability.supportedModes.contains(mode) else { return }
        selectedMode = mode
    }

    func addFilter() {
        for index in filters.indices {
            filters[index].isExpanded = false
        }

        filters.append(
            TroubleshootingFilter(
                type: .ecamAlert,
                ataRef: "XX-XX-XX",
                description: "",
                isExpanded: true
            )
        )
    }

    func removeFilter(_ filter: TroubleshootingFilter) {
        guard filters.count > 1 else {
            resetFilters()
            return
        }

        filters.removeAll { $0.id == filter.id }
    }

    func toggleFilter(_ filter: TroubleshootingFilter) {
        guard let index = filters.firstIndex(where: { $0.id == filter.id }) else { return }
        filters[index].isExpanded.toggle()
    }

    func resetFilters() {
        filters = [
            TroubleshootingFilter(
                type: .ecamAlert,
                ataRef: "XX-XX-XX",
                description: "",
                isExpanded: true
            )
        ]
        troubleshootingResults = []
    }

    func applyTroubleshootingFilters() {
        Task {
            do {
                troubleshootingResults = try await repository.searchTroubleshooting(filters: filters)
            } catch {
                troubleshootingResults = []
            }
        }
    }

    func performTextSearch() {
        Task {
            do {
                searchResults = try await repository.searchManualText(
                    manualType: capability.manualType,
                    query: searchText
                )
            } catch {
                searchResults = []
            }
        }
    }

    func openReferenceTask(_ taskId: String) {
        // Connect with your existing Viewer router later.
        // Example:
        // router.openTask(taskId)
    }
}
