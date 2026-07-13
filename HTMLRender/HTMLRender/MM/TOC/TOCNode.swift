//
//  TOCNode.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

enum TOCNodeType {
    case root
    case level1
    case level2
    case level3
    case level4
}

final class TOCNode: ObservableObject, Identifiable {

    let id: String
    let title: String
    let type: TOCNodeType

    @Published var children: [TOCNode]

    init(
        id: String,
        title: String,
        type: TOCNodeType,
        children: [TOCNode] = []
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.children = children
    }
}
