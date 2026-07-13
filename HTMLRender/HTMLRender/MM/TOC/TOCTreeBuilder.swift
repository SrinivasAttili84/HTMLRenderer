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

        var dictionary: [String: TOCNode] = [:]

        for row in rows {

            let node = TOCNode(
                id: row.id,
                title: row.title,
                level1: row.level1,
                level2: row.level2,
                level3: row.level3,
                level4: row.level4
            )

            let currentKey = makeKey(
                l1: row.level1,
                l2: row.level2,
                l3: row.level3,
                l4: row.level4
            )

            dictionary[currentKey] = node

            let parentKey = makeParentKey(
                l1: row.level1,
                l2: row.level2,
                l3: row.level3,
                l4: row.level4
            )

            if parentKey.isEmpty {

                roots.append(node)

            } else {

                dictionary[parentKey]?.children.append(node)
            }
        }

        return roots
    }
}
/**
 let parser = TocCSVParser()

 let rows = try parser.parse(fileURL: csvURL)

 let builder = TOCTreeBuilder()

 let toc = builder.build(rows: rows)
 */
extension TOCTreeBuilder {

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
                .filter{$0 != ""}
                .joined(separator: "-")
        }

        if !l3.isEmpty {

            return [l1,l2]
                .filter{$0 != ""}
                .joined(separator: "-")
        }

        if !l2.isEmpty {

            return l1
        }

        return ""
    }
}
