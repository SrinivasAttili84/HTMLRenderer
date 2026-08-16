//
//  ViewerSelection.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import Foundation

struct ManualRevisionSelection: Hashable {
    let manualCode: String
    let revisionId: String
    let revisionDate: String
}

struct TOCElementSelection: Hashable {
    let elementId: String
    let taskCode: String
    let title: String
}

struct IllustrationSelection: Hashable {
    let illustrationId: String
    let figureTitle: String
    let sheetNumber: Int
}
