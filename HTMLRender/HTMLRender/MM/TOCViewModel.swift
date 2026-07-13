//
//  TOCViewModel.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

final class TOCViewModel: ObservableObject {

    @Published var visibleNodes: [VisibleNode] = []

    @Published var selectedNode: TOCNode?

    private var rootNodes: [TOCNode] = []

    private var expandedIDs = Set<String>()

    init(nodes: [TOCNode]) {

        rootNodes = nodes

        rebuild()
    }

    func tap(_ node: TOCNode) {

        if node.hasChildren {

            if expandedIDs.contains(node.id) {
                expandedIDs.remove(node.id)
            } else {
                expandedIDs.insert(node.id)
            }

            rebuild()

        } else {

            selectedNode = node
        }
    }

    private func rebuild() {

        visibleNodes.removeAll()

        for node in rootNodes {

            append(node, level: 0)
        }
    }

    private func append(_ node: TOCNode,
                        level: Int) {

        visibleNodes.append(
            VisibleNode(
                id: node.id,
                node: node,
                level: level,
                expanded: expandedIDs.contains(node.id)
            )
        )

        guard expandedIDs.contains(node.id) else { return }

        for child in node.children {

            append(child,
                   level: level + 1)
        }
    }
}
