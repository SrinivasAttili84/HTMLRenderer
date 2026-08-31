//
//  ViewerPanel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import Foundation

enum ViewerPanel: String, Identifiable, Hashable {
    case search
    case toc
    case html
    case illustration

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .search:
            return "Search"

        case .toc:
            return "TOC"

        case .html:
            return "HTML"

        case .illustration:
            return "Illustration"
        }
    }

    var isContentPanel: Bool {
        self == .html || self == .illustration
    }
}
