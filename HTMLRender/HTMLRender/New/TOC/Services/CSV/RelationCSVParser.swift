//
//  RelationCSVParser.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

final class RelationCSVParser {

    static func parseTocItemContainer(
        fileName: String = "TocItem_Container"
    ) -> [TocItemContainerRelation] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let startIndex = CSVReader.index(
                headers: headers,
                names: ["IdStart", "StartId", "ParentId", "SourceId"]
            ),
            let endIndex = CSVReader.index(
                headers: headers,
                names: ["IdEnd", "EndId", "ChildId", "TargetId"]
            )
        else {
            print("Missing TocItem_Container relation columns")
            return []
        }

        var result: [TocItemContainerRelation] = []

        for columns in rows.dropFirst() {

            guard columns.count > max(startIndex, endIndex) else {
                continue
            }

            let tocItemId = CSVReader.cleanRequired(
                columns[startIndex]
            )

            let containerId = CSVReader.cleanRequired(
                columns[endIndex]
            )

            if !tocItemId.isEmpty,
               !containerId.isEmpty {

                result.append(
                    TocItemContainerRelation(
                        tocItemId: tocItemId,
                        containerId: containerId
                    )
                )
            }
        }

        print("TocItem_Container count:", result.count)

        return result
    }

    static func parseContainerSolution(
        fileName: String = "Container_Solution"
    ) -> [ContainerSolutionRelation] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let startIndex = CSVReader.index(
                headers: headers,
                names: ["IdStart", "StartId", "ParentId", "SourceId"]
            ),
            let endIndex = CSVReader.index(
                headers: headers,
                names: ["IdEnd", "EndId", "ChildId", "TargetId"]
            )
        else {
            print("Missing Container_Solution relation columns")
            return []
        }

        var result: [ContainerSolutionRelation] = []

        for columns in rows.dropFirst() {

            guard columns.count > max(startIndex, endIndex) else {
                continue
            }

            let containerId = CSVReader.cleanRequired(
                columns[startIndex]
            )

            let solutionId = CSVReader.cleanRequired(
                columns[endIndex]
            )

            if !containerId.isEmpty,
               !solutionId.isEmpty {

                result.append(
                    ContainerSolutionRelation(
                        containerId: containerId,
                        solutionId: solutionId
                    )
                )
            }
        }

        print("Container_Solution count:", result.count)

        return result
    }
}
