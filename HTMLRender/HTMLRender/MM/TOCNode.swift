//
//  TOCNode.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

//struct TOCNode: Codable, Identifiable {
//
//    let id: String
//    let title: String
//    let page: String?
//    let children: [TOCNode]
//
//    var hasChildren: Bool {
//        !children.isEmpty
//    }
//}

struct TOCNode: Codable, Identifiable {

    let id: String
    let title: String
    let page: String?
    let children: [TOCNode]

    // Optional metadata
    let chapter: String?
    let revision: String?
    let lastUpdated: String?

    var hasChildren: Bool {
        !children.isEmpty
    }
}
