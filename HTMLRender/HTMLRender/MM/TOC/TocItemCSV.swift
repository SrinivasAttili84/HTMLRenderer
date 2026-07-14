//
//  TocItemCSV.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

struct TocItemCSV {

    let id: String

    let level1: String?
    let level2: String?
    let level3: String?
    let level4: String?

    let title: String

    var ataCode: String {
        let parts = [
            level1,
            level2,
            level3,
            level4
        ].compactMap { $0 }

        return parts.joined(separator: "-")
    }

    var depth: Int {
        if level4 != nil {
            return 4
        }

        if level3 != nil {
            return 3
        }

        if level2 != nil {
            return 2
        }

        if level1 != nil {
            return 1
        }

        return 0
    }

    var parentAtaCode: String? {
        switch depth {
        case 2:
            return level1

        case 3:
            guard let level1, let level2 else {
                return nil
            }

            return "\(level1)-\(level2)"

        case 4:
            guard let level1, let level2, let level3 else {
                return nil
            }

            return "\(level1)-\(level2)-\(level3)"

        default:
            return nil
        }
    }
}


struct TocItemContainerRelation {

    let tocItemId: String
    let containerId: String
}

struct ContainerSolutionRelation {

    let containerId: String
    let solutionId: String
}

struct Solution: Identifiable {

    let id: String
    let label: String
    let trCode: String
    let xmlFile: String
}
