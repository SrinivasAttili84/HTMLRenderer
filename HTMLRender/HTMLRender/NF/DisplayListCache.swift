//
//  DisplayListCache.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation

final class DisplayListCache {

    static let shared = DisplayListCache()

    private init() {}

    func cacheURL(
        for sourceURL: URL
    ) -> URL {

        let fileName = sourceURL
            .deletingPathExtension()
            .lastPathComponent

        let cacheFileName = "\(fileName).displaylist.json"

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(cacheFileName)
    }

    func exists(
        for sourceURL: URL
    ) -> Bool {

        let url = cacheURL(for: sourceURL)

        return FileManager.default.fileExists(
            atPath: url.path
        )
    }

    func save(
        _ displayList: CGMDisplayList,
        for sourceURL: URL
    ) throws {

        let url = cacheURL(for: sourceURL)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys
        ]

        let data = try encoder.encode(displayList)

        try data.write(
            to: url,
            options: .atomic
        )

        print("DisplayList saved at: \(url.path)")
    }

    func load(
        for sourceURL: URL
    ) throws -> CGMDisplayList {

        let url = cacheURL(for: sourceURL)

        let data = try Data(
            contentsOf: url
        )

        let decoder = JSONDecoder()

        return try decoder.decode(
            CGMDisplayList.self,
            from: data
        )
    }
}
