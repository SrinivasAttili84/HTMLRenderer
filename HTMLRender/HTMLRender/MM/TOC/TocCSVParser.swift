//
//  TocCSVParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

import Foundation

final class TocCSVParser {

    func parse(fileURL: URL) throws -> [TocCSVRow] {

        let text = try String(contentsOf: fileURL, encoding: .utf8)

        let lines = text
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        guard let header = lines.first else {
            return []
        }

        let headers = parseCSVLine(header)

        var rows: [TocCSVRow] = []

        for line in lines.dropFirst() {

            let values = parseCSVLine(line)

            var dict: [String:String] = [:]

            for (index,key) in headers.enumerated() {

                if index < values.count {
                    dict[key] = values[index]
                }
            }

            rows.append(
                TocCSVRow(
                    id: clean(dict["Id"]),
                    title: clean(dict["Title"]),
                    level1: clean(dict["LevelId1"]),
                    level2: clean(dict["LevelId2"]),
                    level3: clean(dict["LevelId3"]),
                    level4: clean(dict["LevelId4"])
                )
            )
        }

        return rows
    }
}

private extension TocCSVParser {

    func clean(_ value: String?) -> String {

        guard var text = value else {
            return ""
        }

        text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if text.hasPrefix("\"") {
            text.removeFirst()
        }

        if text.hasSuffix("\"") {
            text.removeLast()
        }

        text = text.replacingOccurrences(of: "\"\"", with: "")

        if text == "0" {
            return ""
        }

        return text
    }

    func parseCSVLine(_ line: String) -> [String] {

        var values: [String] = []

        var current = ""

        var insideQuotes = false

        for char in line {

            switch char {

            case "\"":

                insideQuotes.toggle()

            case ",":

                if insideQuotes {

                    current.append(char)

                } else {

                    values.append(current)
                    current = ""
                }

            default:

                current.append(char)
            }
        }

        values.append(current)

        return values
    }
}
