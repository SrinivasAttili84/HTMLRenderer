//
//  ManualTreeBuilder.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

final class ManualTreeBuilder {

    static func buildCompleteTree(
        tocItems: [TocItemCSV],
        tocItemContainers: [TocItemContainerRelation],
        containerSolutions: [ContainerSolutionRelation],
        solutions: [Solution]
    ) -> ManualTreeResult {

        let tocTree = buildTOCTree(
            from: tocItems
        )

        let finalTree = attachSolutions(
            to: tocTree,
            tocItemContainers: tocItemContainers,
            containerSolutions: containerSolutions,
            solutions: solutions
        )

        var lookup: [String: TOCNode] = [:]

        flatten(
            nodes: finalTree,
            lookup: &lookup
        )

        return ManualTreeResult(
            rootNodes: finalTree,
            nodeLookup: lookup
        )
    }

    private static func buildTOCTree(
        from rows: [TocItemCSV]
    ) -> [TOCNode] {

        var rowsByAtaCode: [String: TocItemCSV] = [:]
        var childrenByParentAtaCode: [String: [TocItemCSV]] = [:]
        var roots: [TocItemCSV] = []

        for row in rows {

            rowsByAtaCode[row.ataCode] = row

            if row.depth == 1 {

                roots.append(row)

            } else if let parentAtaCode = row.parentAtaCode {

                childrenByParentAtaCode[
                    parentAtaCode,
                    default: []
                ].append(row)
            }
        }

        roots.sort {
            $0.ataCode < $1.ataCode
        }

        return roots.map { rootRow in

            makeTOCNode(
                row: rootRow,
                parentId: nil,
                childrenByParentAtaCode: childrenByParentAtaCode
            )
        }
    }

    private static func makeTOCNode(
        row: TocItemCSV,
        parentId: String?,
        childrenByParentAtaCode: [String: [TocItemCSV]]
    ) -> TOCNode {

        let childrenRows = childrenByParentAtaCode[
            row.ataCode
        ]?
        .sorted {
            $0.ataCode < $1.ataCode
        } ?? []

        let childNodes = childrenRows.map { childRow in

            makeTOCNode(
                row: childRow,
                parentId: row.id,
                childrenByParentAtaCode: childrenByParentAtaCode
            )
        }

        let type: TOCNodeType

        switch row.depth {

        case 1:
            type = .level1

        case 2:
            type = .level2

        case 3:
            type = .level3

        default:
            type = .level4
        }

        return TOCNode(
            id: row.id,
            ataCode: row.ataCode,
            title: row.title,
            type: type,
            parentId: parentId,
            children: childNodes.isEmpty ? nil : childNodes
        )
    }

    private static func attachSolutions(
        to nodes: [TOCNode],
        tocItemContainers: [TocItemContainerRelation],
        containerSolutions: [ContainerSolutionRelation],
        solutions: [Solution]
    ) -> [TOCNode] {

        let tocToContainers = Dictionary(
            grouping: tocItemContainers,
            by: { $0.tocItemId }
        )
        .mapValues {
            $0.map { $0.containerId }
        }

        let containerToSolutions = Dictionary(
            grouping: containerSolutions,
            by: { $0.containerId }
        )
        .mapValues {
            $0.map { $0.solutionId }
        }

        let solutionLookup = Dictionary(
            uniqueKeysWithValues: solutions.map {
                ($0.id, $0)
            }
        )

        return nodes.map { node in

            attachSolutionsToNode(
                node: node,
                tocToContainers: tocToContainers,
                containerToSolutions: containerToSolutions,
                solutionLookup: solutionLookup
            )
        }
    }

    private static func attachSolutionsToNode(
        node: TOCNode,
        tocToContainers: [String: [String]],
        containerToSolutions: [String: [String]],
        solutionLookup: [String: Solution]
    ) -> TOCNode {

        var updatedNode = node

        if let children = updatedNode.children {

            updatedNode.children = children.map { child in

                attachSolutionsToNode(
                    node: child,
                    tocToContainers: tocToContainers,
                    containerToSolutions: containerToSolutions,
                    solutionLookup: solutionLookup
                )
            }
        }

        guard updatedNode.type == .level4 else {
            return updatedNode
        }

        let containerIds = tocToContainers[
            updatedNode.id
        ] ?? []

        var solutionNodes: [TOCNode] = []

        for containerId in containerIds {

            let solutionIds = containerToSolutions[
                containerId
            ] ?? []

            for solutionId in solutionIds {

                guard let solution = solutionLookup[
                    solutionId
                ] else {
                    continue
                }

                let solutionNode = TOCNode(
                    id: solution.id,
                    ataCode: "",
                    title: solution.label,
                    type: .solution,
                    parentId: updatedNode.id,
                    solutionId: solution.id,
                    solutionLabel: solution.label,
                    trCode: solution.trCode,
                    xmlFile: solution.xmlFile,
                    children: nil
                )

                solutionNodes.append(solutionNode)
            }
        }

        solutionNodes.sort {
            $0.title < $1.title
        }

        if !solutionNodes.isEmpty {

            var existingChildren = updatedNode.children ?? []
            existingChildren.append(contentsOf: solutionNodes)
            updatedNode.children = existingChildren
        }

        return updatedNode
    }

    private static func flatten(
        nodes: [TOCNode],
        lookup: inout [String: TOCNode]
    ) {

        for node in nodes {

            lookup[node.id] = node

            if let children = node.children {

                flatten(
                    nodes: children,
                    lookup: &lookup
                )
            }
        }
    }
}
