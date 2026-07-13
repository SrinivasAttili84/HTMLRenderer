//
//  TocItemCSV.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

struct TocItemCSV: Identifiable {

    let id: String

    let level1: String?
    let level2: String?
    let level3: String?
    let level4: String?

    let title: String
}
