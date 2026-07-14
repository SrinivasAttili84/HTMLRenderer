//
//  CSVParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class CSVReader {

    static func clean(
        _ value: String
    ) -> String? {

        let cleaned = value
            .replacingOccurrences(of: "\u{feff}", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return cleaned.isEmpty ? nil : cleaned
    }

    static func cleanRequired(
        _ value: String
    ) -> String {

        clean(value) ?? ""
    }

    static func loadRows(
        fileName: String
    ) -> [[String]] {

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "csv"
        ) else {
            print("CSV file not found: \(fileName).csv")
            return []
        }

        do {
            let text = try String(
                contentsOf: url,
                encoding: .utf8
            )

            let lines = text
                .components(separatedBy: .newlines)
                .filter {
                    !$0.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                }

            return lines.map {
                parseLine($0)
            }

        } catch {
            print("CSV read error:", error)
            return []
        }
    }

    static func parseLine(
        _ line: String
    ) -> [String] {

        var result: [String] = []
        var current = ""
        var insideQuotes = false

        let chars = Array(line)
        var index = 0

        while index < chars.count {

            let char = chars[index]

            if char == "\"" {

                if insideQuotes,
                   index + 1 < chars.count,
                   chars[index + 1] == "\"" {

                    current.append("\"")
                    index += 1

                } else {
                    insideQuotes.toggle()
                }

            } else if char == ",", !insideQuotes {

                result.append(current)
                current = ""

            } else {

                current.append(char)
            }

            index += 1
        }

        result.append(current)

        return result
    }

    static func headerIndex(
        headers: [String],
        possibleNames: [String]
    ) -> Int? {

        let cleanedHeaders = headers.map {
            cleanRequired($0)
        }

        for name in possibleNames {

            if let index = cleanedHeaders.firstIndex(of: name) {
                return index
            }
        }

        return nil
    }
}



final class TocItemParser {

    static func parse(
        fileName: String
    ) -> [TocItemCSV] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let idIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["Id"]
            ),
            let level1Index = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["LevelId1"]
            ),
            let level2Index = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["LevelId2"]
            ),
            let level3Index = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["LevelId3"]
            ),
            let level4Index = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["LevelId4"]
            ),
            let titleIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["Title"]
            )
        else {
            print("Missing required columns in TocItem.csv")
            return []
        }

        var items: [TocItemCSV] = []

        for columns in rows.dropFirst() {

            let maxIndex = [
                idIndex,
                level1Index,
                level2Index,
                level3Index,
                level4Index,
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
                    columns[level1Index]
                ),
                level2: CSVReader.clean(
                    columns[level2Index]
                ),
                level3: CSVReader.clean(
                    columns[level3Index]
                ),
                level4: CSVReader.clean(
                    columns[level4Index]
                ),
                title: CSVReader.cleanRequired(
                    columns[titleIndex]
                )
            )

            if item.depth > 0 {
                items.append(item)
            }
        }

        print("TocItem rows:", items.count)

        return items
    }
}


final class RelationCSVParser {

    static func parseTocItemContainer(
        fileName: String
    ) -> [TocItemContainerRelation] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let startIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: [
                    "IdStart",
                    "StartId",
                    "ParentId",
                    "SourceId"
                ]
            ),
            let endIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: [
                    "IdEnd",
                    "EndId",
                    "ChildId",
                    "TargetId"
                ]
            )
        else {
            print("Missing relation columns in \(fileName).csv")
            return []
        }

        var result: [TocItemContainerRelation] = []

        for columns in rows.dropFirst() {

            guard columns.count > max(startIndex, endIndex) else {
                continue
            }

            let tocId = CSVReader.cleanRequired(
                columns[startIndex]
            )

            let containerId = CSVReader.cleanRequired(
                columns[endIndex]
            )

            if !tocId.isEmpty && !containerId.isEmpty {
                result.append(
                    TocItemContainerRelation(
                        tocItemId: tocId,
                        containerId: containerId
                    )
                )
            }
        }

        print("TocItem_Container relations:", result.count)

        return result
    }

    static func parseContainerSolution(
        fileName: String
    ) -> [ContainerSolutionRelation] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let startIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: [
                    "IdStart",
                    "StartId",
                    "ParentId",
                    "SourceId"
                ]
            ),
            let endIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: [
                    "IdEnd",
                    "EndId",
                    "ChildId",
                    "TargetId"
                ]
            )
        else {
            print("Missing relation columns in \(fileName).csv")
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

            if !containerId.isEmpty && !solutionId.isEmpty {
                result.append(
                    ContainerSolutionRelation(
                        containerId: containerId,
                        solutionId: solutionId
                    )
                )
            }
        }

        print("Container_Solution relations:", result.count)

        return result
    }
}

final class SolutionParser {

    static func parse(
        fileName: String
    ) -> [Solution] {

        let rows = CSVReader.loadRows(
            fileName: fileName
        )

        guard rows.count > 1 else {
            return []
        }

        let headers = rows[0]

        guard
            let idIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: ["Id"]
            ),
            let labelIndex = CSVReader.headerIndex(
                headers: headers,
                possibleNames: [
                    "Label",
                    "Title",
                    "Name"
                ]
            )
        else {
            print("Missing Id / Label columns in Solution.csv")
            return []
        }

        let trCodeIndex = CSVReader.headerIndex(
            headers: headers,
            possibleNames: [
                "TrCode",
                "TRCode",
                "Code"
            ]
        )

        let fileIndex = CSVReader.headerIndex(
            headers: headers,
            possibleNames: [
                "File",
                "XmlFile",
                "XMLFile",
                "Path"
            ]
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

            let trCode: String

            if let trCodeIndex,
               columns.count > trCodeIndex {

                trCode = CSVReader.cleanRequired(
                    columns[trCodeIndex]
                )

            } else {
                trCode = ""
            }

            let xmlFile: String

            if let fileIndex,
               columns.count > fileIndex {

                xmlFile = CSVReader.cleanRequired(
                    columns[fileIndex]
                )

            } else if !trCode.isEmpty {

                xmlFile = "\(trCode).xml"

            } else {

                xmlFile = ""
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

        print("Solution rows:", result.count)

        return result
    }
}
