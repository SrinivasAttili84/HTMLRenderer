//
//  TOCNode.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import Foundation

enum TOCNodeType {
    case level1
    case level2
    case level3
    case level4
    case solution
}

struct TOCNode: Identifiable {

    let id: String

    let ataCode: String
    let title: String

    let type: TOCNodeType

    // important for search expansion
    var parentId: String?

    // solution-only fields
    var solutionId: String?
    var solutionLabel: String?
    var trCode: String?
    var xmlFile: String?

    var children: [TOCNode]?

    init(
        id: String,
        ataCode: String,
        title: String,
        type: TOCNodeType,
        parentId: String? = nil,
        solutionId: String? = nil,
        solutionLabel: String? = nil,
        trCode: String? = nil,
        xmlFile: String? = nil,
        children: [TOCNode]? = nil
    ) {
        self.id = id
        self.ataCode = ataCode
        self.title = title
        self.type = type
        self.parentId = parentId
        self.solutionId = solutionId
        self.solutionLabel = solutionLabel
        self.trCode = trCode
        self.xmlFile = xmlFile
        self.children = children
    }
}
