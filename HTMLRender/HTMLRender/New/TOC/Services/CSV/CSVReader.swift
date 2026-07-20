//
//  CSVReader.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

final class CSVReader {

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

    static func index(
        headers: [String],
        names: [String]
    ) -> Int? {

        let cleanHeaders = headers.map {
            cleanRequired($0)
        }

        for name in names {

            if let index = cleanHeaders.firstIndex(of: name) {
                return index
            }
        }

        return nil
    }
}
