//
//  TOCNodeTreeView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct TOCNodeTreeView: View {

    let node: TOCNode

    let level: Int

    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        VStack(spacing: 0) {

            TOCNodeRowView(
                node: node,
                level: level,
                isExpanded: isExpanded,
                isInSelectedPath: isInSelectedPath,
                viewModel: viewModel
            )
            .contentShape(Rectangle())
            .onTapGesture {

                viewModel.selectNode(node)

                if hasChildren {
                    viewModel.toggle(node.id)
                }
            }
            .id(node.id)

            if isExpanded {

                ForEach(node.children ?? []) { child in

                    TOCNodeTreeView(
                        node: child,
                        level: level + 1,
                        viewModel: viewModel
                    )
                }
            }
        }
    }

    private var hasChildren: Bool {

        !(node.children ?? []).isEmpty
    }

    private var isExpanded: Bool {

        viewModel.expandedNodes.contains(
            node.id
        )
    }

    private var isInSelectedPath: Bool {

        viewModel.isSelectedPath(
            nodeId: node.id
        )
    }
}
