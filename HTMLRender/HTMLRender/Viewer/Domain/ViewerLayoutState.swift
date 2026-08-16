//
//  ViewerLayoutState.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import Foundation

struct ViewerLayoutState: Hashable {
    var leftPanel: ViewerPanel
    var rightPanel: ViewerPanel

    static let initial = ViewerLayoutState(
        leftPanel: .search,
        rightPanel: .toc
    )
}
