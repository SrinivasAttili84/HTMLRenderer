//
//  TocItemParser.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

final class TocItemParser {

    static func parse(
        fileName: String = "TocItem"
    ) -> [TocItemCSV] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let idIndex = CSVReader.index(
                headers: headers,
                names: ["Id"]
            ),
            let l1Index = CSVReader.index(
                headers: headers,
                names: ["LevelId1"]
            ),
            let l2Index = CSVReader.index(
                headers: headers,
                names: ["LevelId2"]
            ),
            let l3Index = CSVReader.index(
                headers: headers,
                names: ["LevelId3"]
            ),
            let l4Index = CSVReader.index(
                headers: headers,
                names: ["LevelId4"]
            ),
            let titleIndex = CSVReader.index(
                headers: headers,
                names: ["Title"]
            )
        else {
            print("Missing required TocItem columns")
            return []
        }

        var result: [TocItemCSV] = []

        for columns in rows.dropFirst() {

            let maxIndex = [
                idIndex,
                l1Index,
                l2Index,
                l3Index,
                l4Index,
                titleIndex
            ].max() ?? 0

            guard columns.count > maxIndex else {
                continue
            }

            let item = TocItemCSV(
                id: CSVReader.cleanRequired(
                    columns[idIndex]
                ),
                level1: CSVReader.clean(
                    columns[l1Index]
                ),
                level2: CSVReader.clean(
                    columns[l2Index]
                ),
                level3: CSVReader.clean(
                    columns[l3Index]
                ),
                level4: CSVReader.clean(
                    columns[l4Index]
                ),
                title: CSVReader.cleanRequired(
                    columns[titleIndex]
                )
            )

            if item.depth > 0 {
                result.append(item)
            }
        }

        print("TocItem count:", result.count)

        return result
    }
}

