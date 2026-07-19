//
//  FileManagerService.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import Foundation

final class FileManagerService {

    static let shared = FileManagerService()

    private init() {}

    var libraryURL: URL {

        FileManager.default.urls(
            for: .libraryDirectory,
            in: .userDomainMask
        ).first!
    }

    var manualsURL: URL {

        let url = libraryURL
            .appendingPathComponent(
                "Manuals",
                isDirectory: true
            )

        createFolderIfNeeded(url)

        return url
    }

    private func createFolderIfNeeded(
        _ url: URL
    ) {

        if !FileManager.default.fileExists(
            atPath: url.path
        ) {

            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true
            )
        }
    }
}

extension FileManagerService {

    func manualFolder(
        aircraft: String
    ) -> URL {

        let url =
        manualsURL
            .appendingPathComponent(
                aircraft,
                isDirectory: true
            )

        if !FileManager.default.fileExists(
            atPath: url.path
        ) {

            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true
            )
        }

        return url
    }
}

//let path =
//FileManagerService.shared
//    .manualFolder(
//        aircraft: "A330"
//    )
//
//print(path)
