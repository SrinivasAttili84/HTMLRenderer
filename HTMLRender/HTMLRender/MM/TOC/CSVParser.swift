//
//  CSVParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class CSVParser {

    static func parseTocItems(
        fileName: String
    ) -> [TocItemCSV] {

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "csv"
        ) else {
            return []
        }

        do {

            let csvString = try String(
                contentsOf: url,
                encoding: .utf8
            )

            let rows = csvString.components(
                separatedBy: .newlines
            )

            guard rows.count > 1 else {
                return []
            }

            var items: [TocItemCSV] = []

            for row in rows.dropFirst() {

                if row.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty {
                    continue
                }

                let columns = row.components(
                    separatedBy: ","
                )

                if columns.count < 6 {
                    continue
                }

                let item = TocItemCSV(
                    id: columns[0],

                    level1: columns[1].isEmpty ? nil : columns[1],
                    level2: columns[2].isEmpty ? nil : columns[2],
                    level3: columns[3].isEmpty ? nil : columns[3],
                    level4: columns[4].isEmpty ? nil : columns[4],

                    title: columns[5]
                )

                items.append(item)
            }

            return items

        } catch {

            print(error.localizedDescription)
            return []
        }
    }
}
