//
//  TOCViewModel.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation
import SwiftUI

@MainActor
final class TOCViewModel: ObservableObject {

    @Published var rootNodes: [TOCNode] = []

    @Published var expandedNodes: Set<String> = []

    @Published var selectedNodeId: String?

    @Published var searchText: String = ""

    @Published var searchResults: [TOCNode] = []

    @Published var isLoading: Bool = false

    private(set) var nodeLookup: [String: TOCNode] = [:]

    private var hasLoaded = false

    func load() {

        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        isLoading = true

        Task.detached(priority: .userInitiated) {

            let tocItems = TocItemParser.parse(
                fileName: "TocItem"
            )

            let tocItemContainers = RelationCSVParser.parseTocItemContainer(
                fileName: "TocItem_Container"
            )

            let containerSolutions = RelationCSVParser.parseContainerSolution(
                fileName: "Container_Solution"
            )

            let solutions = SolutionParser.parse(
                fileName: "Solution"
            )

            let result = ManualTreeBuilder.buildCompleteTree(
                tocItems: tocItems,
                tocItemContainers: tocItemContainers,
                containerSolutions: containerSolutions,
                solutions: solutions
            )

            await MainActor.run {

                self.rootNodes = result.rootNodes
                self.nodeLookup = result.nodeLookup
                self.isLoading = false

                self.expandFirstLevelByDefault()
            }
        }
    }

    func toggle(
        _ nodeId: String
    ) {

        if expandedNodes.contains(nodeId) {

            expandedNodes.remove(nodeId)

        } else {

            expandedNodes.insert(nodeId)
        }
    }

    func selectNode(
        _ node: TOCNode
    ) {

        selectedNodeId = node.id

        expandParents(
            nodeId: node.id
        )
    }

    func expandParents(
        nodeId: String
    ) {

        var currentId = nodeId

        while true {

            guard let node = nodeLookup[currentId] else {
                break
            }

            guard let parentId = node.parentId else {
                break
            }

            expandedNodes.insert(parentId)

            currentId = parentId
        }
    }

    func isSelectedPath(
        nodeId: String
    ) -> Bool {

        guard let selectedNodeId else {
            return false
        }

        var currentId = selectedNodeId

        while true {

            if currentId == nodeId {
                return true
            }

            guard let node = nodeLookup[currentId],
                  let parentId = node.parentId else {
                return false
            }

            currentId = parentId
        }
    }

    func search() {

        let key = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !key.isEmpty else {
            searchResults = []
            return
        }

        searchResults = nodeLookup.values
            .filter {
                $0.type == .solution
            }
            .filter {
                $0.title.lowercased().contains(key)
                || ($0.trCode ?? "").lowercased().contains(key)
                || ($0.xmlFile ?? "").lowercased().contains(key)
            }
            .sorted {
                $0.title < $1.title
            }
    }

    func openSearchResult(
        _ node: TOCNode
    ) {

        selectedNodeId = node.id

        expandParents(
            nodeId: node.id
        )

        searchText = ""
        searchResults = []
    }

    private func expandFirstLevelByDefault() {

        for node in rootNodes {

            expandedNodes.insert(node.id)
        }
    }
}
