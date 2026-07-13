//
//  TOCTreeBuilder.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCTreeBuilder {

    func build(rows: [TocCSVRow]) -> [TOCNode] {

        var roots: [TOCNode] = []

        var nodes: [String: TOCNode] = [:]

        for row in rows {

            let l1 = normalize(row.level1)
            let l2 = normalize(row.level2)
            let l3 = normalize(row.level3)
            let l4 = normalize(row.level4)

            let node = TOCNode(
                id: row.id,
                title: row.title,
                level1: l1,
                level2: l2,
                level3: l3,
                level4: l4
            )

            let currentKey = makeKey(
                l1: l1,
                l2: l2,
                l3: l3,
                l4: l4
            )

            let parentKey = makeParentKey(
                l1: l1,
                l2: l2,
                l3: l3,
                l4: l4
            )

            nodes[currentKey] = node

            if parentKey.isEmpty {

                roots.append(node)

            } else {

                nodes[parentKey]?.children?.append(node)
            }
        }

        return roots
    }
}

private extension TOCTreeBuilder {

    func normalize(_ value: String) -> String {

        let text = value.trimmingCharacters(in: .whitespaces)

        if text == "0" || text.isEmpty {
            return ""
        }

        return text
    }

    func makeKey(
        l1: String,
        l2: String,
        l3: String,
        l4: String
    ) -> String {

        [l1,l2,l3,l4]
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }

    func makeParentKey(
        l1: String,
        l2: String,
        l3: String,
        l4: String
    ) -> String {

        if !l4.isEmpty {
            return [l1,l2,l3]
                .filter { !$0.isEmpty }
                .joined(separator: "-")
        }

        if !l3.isEmpty {
            return [l1,l2]
                .filter { !$0.isEmpty }
                .joined(separator: "-")
        }

        if !l2.isEmpty {
            return l1
        }

        return ""
    }
}
