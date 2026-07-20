//
//  SolutionParser.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

final class SolutionParser {

    static func parse(
        fileName: String = "Solution"
    ) -> [Solution] {

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
            let labelIndex = CSVReader.index(
                headers: headers,
                names: ["Label", "Title", "Name"]
            )
        else {
            print("Missing Solution Id / Label columns")
            return []
        }

        let trCodeIndex = CSVReader.index(
            headers: headers,
            names: ["TrCode", "TRCode", "Code"]
        )

        let fileIndex = CSVReader.index(
            headers: headers,
            names: ["File", "XmlFile", "XMLFile", "Path"]
        )

        var result: [Solution] = []

        for columns in rows.dropFirst() {

            guard columns.count > max(idIndex, labelIndex) else {
                continue
            }

            let id = CSVReader.cleanRequired(
                columns[idIndex]
            )

            let label = CSVReader.cleanRequired(
                columns[labelIndex]
            )

            var trCode = ""

            if let trCodeIndex,
               columns.count > trCodeIndex {

                trCode = CSVReader.cleanRequired(
                    columns[trCodeIndex]
                )
            }

            var xmlFile = ""

            if let fileIndex,
               columns.count > fileIndex {

                xmlFile = CSVReader.cleanRequired(
                    columns[fileIndex]
                )

            } else if !trCode.isEmpty {

                xmlFile = "\(trCode).xml"
            }

            if !id.isEmpty {

                result.append(
                    Solution(
                        id: id,
                        label: label,
                        trCode: trCode,
                        xmlFile: xmlFile
                    )
                )
            }
        }

        print("Solution count:", result.count)

        return result
    }
}
