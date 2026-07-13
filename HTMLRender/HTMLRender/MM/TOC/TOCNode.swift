//
//  TOCNode.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

enum TOCNodeType {
    case level1
    case level2
    case level3
    case level4
}

struct TOCNode: Identifiable {

    let id: String

    let ataCode: String

    let title: String

    let type: TOCNodeType

    var children: [TOCNode]?
}
