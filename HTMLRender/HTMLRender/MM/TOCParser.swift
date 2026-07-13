//
//  TOCParser.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCParser {

    static func load(from fileName: String) -> [TOCNode] {

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("\(fileName).json not found")
        }

        do {
            let data = try Data(contentsOf: url)

            return try JSONDecoder().decode([TOCNode].self, from: data)

        } catch {
            fatalError("Failed to parse JSON: \(error)")
        }
    }
}
