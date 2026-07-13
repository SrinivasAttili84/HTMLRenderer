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

        var roots: [TOCNode] = []

        var level1Map: [String: TOCNode] = [:]
        var level2Map: [String: TOCNode] = [:]
        var level3Map: [String: TOCNode] = [:]

        for row in rows {

            guard let l1 = row.level1 else {
                continue
            }

            //----------------------------------
            // LEVEL 1
            //----------------------------------

            if row.level2 == nil {

                let node = TOCNode(
                    id: row.id,
                    title: "\(l1) - \(row.title)",
                    type: .level1
                )

                roots.append(node)

                level1Map[l1] = node
                continue
            }

            guard let l2 = row.level2 else {
                continue
            }

            let level2Key = "\(l1)-\(l2)"

            //----------------------------------
            // LEVEL 2
            //----------------------------------

            if row.level3 == nil {

                let node = TOCNode(
                    id: row.id,
                    title: "\(l1)-\(l2) - \(row.title)",
                    type: .level2
                )

                level1Map[l1]?.children.append(node)

                level2Map[level2Key] = node

                continue
            }

            guard let l3 = row.level3 else {
                continue
            }

            let level3Key = "\(l1)-\(l2)-\(l3)"

            //----------------------------------
            // LEVEL 3
            //----------------------------------

            if row.level4 == nil {

                let node = TOCNode(
                    id: row.id,
                    title: "\(l1)-\(l2)-\(l3) - \(row.title)",
                    type: .level3
                )

                level2Map[level2Key]?.children.append(node)

                level3Map[level3Key] = node

                continue
            }

            guard let l4 = row.level4 else {
                continue
            }

            //----------------------------------
            // LEVEL 4
            //----------------------------------

            let node = TOCNode(
                id: row.id,
                title: "\(l1)-\(l2)-\(l3)-\(l4) - \(row.title)",
                type: .level4
            )

            level3Map[level3Key]?.children.append(node)
        }

        return roots
    }
}
