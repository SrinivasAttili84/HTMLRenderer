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
            "At least one viewer panel must be visible."
        )

        precondition(
            visiblePanels.count <= 2,
            "The viewer supports a maximum of two panels."
        )

        precondition(
            Set(visiblePanels).count == visiblePanels.count,
            "The same viewer panel cannot appear twice."
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

    /*
     Swipe is allowed when:

     1. Two panels are visible.
     2. The right panel is HTML or Illustration.

     Allowed:
     Search | HTML
     TOC | HTML
     TOC | Illustration
     HTML | Illustration

     Not allowed:
     Search | TOC
     */
    var allowsContentCollapseSwipe: Bool {
        isSplit && rightPanel.isContentPanel
    }

    /*
     Removes the left pane and retains the content pane.

     Search | HTML        -> HTML
     TOC | HTML           -> HTML
     TOC | Illustration   -> Illustration
     HTML | Illustration  -> Illustration
     */
    func collapsingToRightContent() -> ViewerLayoutState {

        guard allowsContentCollapseSwipe else {
            return self
        }

        return ViewerLayoutState(
            visiblePanels: [rightPanel]
        )
    }
}
