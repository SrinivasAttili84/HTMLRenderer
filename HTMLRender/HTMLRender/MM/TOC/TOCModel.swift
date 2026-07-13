//
//  TOCModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCNode: Identifiable {

    let id: String
    let title: String

    let level1: String
    let level2: String
    let level3: String
    let level4: String

    var children: [TOCNode] = []

    init(
        id: String,
        title: String,
        level1: String,
        level2: String,
        level3: String,
        level4: String
    ) {
        self.id = id
        self.title = title
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
        self.level4 = level4
    }
}
