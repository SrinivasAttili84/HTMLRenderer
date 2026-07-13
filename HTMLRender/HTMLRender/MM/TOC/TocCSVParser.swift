//
//  TocCSVParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TocCSVParser {

    func parse(fileURL: URL) throws -> [TocCSVRow] {

        let text = try String(contentsOf: fileURL)

        let lines = text.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }

        guard let header = lines.first else {
            return []
        }

        let headers = header.components(separatedBy: ",")

        var rows: [TocCSVRow] = []

        for line in lines.dropFirst() {

            let values = line.components(separatedBy: ",")

            var dict: [String:String] = [:]

            for (index, key) in headers.enumerated() {

                if index < values.count {
                    dict[key] = values[index]
                }
            }

            let row = TocCSVRow(

                id: dict["Id"] ?? "",

                title: dict["Title"] ?? "",

                level1: dict["LevelId1"] ?? "",

                level2: dict["LevelId2"] ?? "",

                level3: dict["LevelId3"] ?? "",

                level4: dict["LevelId4"] ?? ""
            )

            rows.append(row)
        }

        return rows
    }
}
