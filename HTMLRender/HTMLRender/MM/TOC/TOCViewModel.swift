//
//  TOCViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation
import SwiftUI

@MainActor
final class TOCViewModel: ObservableObject {

    @Published var rootNodes: [TOCNode] = []
    @Published var isLoading: Bool = false
    @Published var selectedNode: TOCNode?

    private var hasLoaded = false

    func load() {

        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        isLoading = true

        Task.detached(priority: .userInitiated) {

            let tocRows = TocItemParser.parse(
                fileName: "TocItem"
            )

            let tocTree = TOCTreeBuilder.build(
                from: tocRows
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

            let finalTree = SolutionAttacher.attachSolutions(
                to: tocTree,
                tocItemContainers: tocItemContainers,
                containerSolutions: containerSolutions,
                solutions: solutions
            )

            await MainActor.run {
                self.rootNodes = finalTree
                self.isLoading = false
            }
        }
    }
}
