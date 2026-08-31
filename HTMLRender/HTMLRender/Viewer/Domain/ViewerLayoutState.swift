//
//  ViewerLayoutState.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import Foundation

struct ViewerLayoutState: Hashable {

    private(set) var visiblePanels: [ViewerPanel]

    init(visiblePanels: [ViewerPanel]) {

        precondition(
            !visiblePanels.isEmpty,
            "At least one panel must be visible."
        )

        precondition(
            visiblePanels.count <= 2,
            "Viewer supports a maximum of two panels."
        )

        precondition(
            Set(visiblePanels).count == visiblePanels.count,
            "The same panel cannot be displayed twice."
        )

        self.visiblePanels = visiblePanels
    }

    static let initial = ViewerLayoutState(
        visiblePanels: [.search, .toc]
    )

    var isSplit: Bool {
        visiblePanels.count == 2
    }

    var leftPanel: ViewerPanel? {
        guard isSplit else {
            return nil
        }

        return visiblePanels.first
    }

    var rightPanel: ViewerPanel {
        visiblePanels.last!
    }

    func contains(_ panel: ViewerPanel) -> Bool {
        visiblePanels.contains(panel)
    }

    func collapsingLeftPanel() -> ViewerLayoutState {
        ViewerLayoutState(
            visiblePanels: [rightPanel]
        )
    }
}
