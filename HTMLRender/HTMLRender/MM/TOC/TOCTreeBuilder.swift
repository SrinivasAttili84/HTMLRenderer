//
//  TOCTreeBuilder.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCTreeBuilder {

    static func build(
        from rows: [TocItemCSV]
    ) -> [TOCNode] {

        var childrenByParent: [String: [TocItemCSV]] = [:]
        var rootRows: [TocItemCSV] = []

        for row in rows {

            if row.depth == 1 {
                rootRows.append(row)
            } else if let parentCode = row.parentAtaCode {
                childrenByParent[parentCode, default: []].append(row)
            }
        }

        rootRows.sort {
            $0.ataCode < $1.ataCode
        }

        let tree = rootRows.map {
            makeNode(
                from: $0,
                childrenByParent: childrenByParent
            )
        }

        print("Root nodes:", tree.count)

        return tree
    }

    private static func makeNode(
        from row: TocItemCSV,
        childrenByParent: [String: [TocItemCSV]]
    ) -> TOCNode {

        let childrenRows = childrenByParent[row.ataCode]?
            .sorted {
                $0.ataCode < $1.ataCode
            } ?? []

        let childNodes = childrenRows.map {
            makeNode(
                from: $0,
                childrenByParent: childrenByParent
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
            children: childNodes.isEmpty ? nil : childNodes
        )
    }
}


final class SolutionAttacher {

    static func attachSolutions(
        to nodes: [TOCNode],
        tocItemContainers: [TocItemContainerRelation],
        containerSolutions: [ContainerSolutionRelation],
        solutions: [Solution]
    ) -> [TOCNode] {

        let tocToContainers = buildTocToContainers(
            tocItemContainers
        )

        let containerToSolutions = buildContainerToSolutions(
            containerSolutions
        )

        let solutionLookup = Dictionary(
            uniqueKeysWithValues: solutions.map {
                ($0.id, $0)
            }
        )

        let updatedNodes = nodes.map {
            attachSolutions(
                node: $0,
                tocToContainers: tocToContainers,
                containerToSolutions: containerToSolutions,
                solutionLookup: solutionLookup
            )
        }

        return updatedNodes
    }

    private static func buildTocToContainers(
        _ relations: [TocItemContainerRelation]
    ) -> [String: [String]] {

        var dictionary: [String: [String]] = [:]

        for relation in relations {
            dictionary[
                relation.tocItemId,
                default: []
            ].append(relation.containerId)
        }

        return dictionary
    }

    private static func buildContainerToSolutions(
        _ relations: [ContainerSolutionRelation]
    ) -> [String: [String]] {

        var dictionary: [String: [String]] = [:]

        for relation in relations {
            dictionary[
                relation.containerId,
                default: []
            ].append(relation.solutionId)
        }

        return dictionary
    }

    private static func attachSolutions(
        node: TOCNode,
        tocToContainers: [String: [String]],
        containerToSolutions: [String: [String]],
        solutionLookup: [String: Solution]
    ) -> TOCNode {

        var updatedNode = node

        if let children = updatedNode.children {

            updatedNode.children = children.map {
                attachSolutions(
                    node: $0,
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

                guard let solution = solutionLookup[solutionId] else {
                    continue
                }

                let solutionNode = TOCNode(
                    id: solution.id,
                    ataCode: "",
                    title: solution.label,
                    type: .solution,
                    solutionId: solution.id,
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
}
