//
//  ViewerWorkspaceMetrics.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerWorkspaceMetrics {

    let size: CGSize
    let layout: ViewerLayoutState

    let horizontalPadding: CGFloat = 24
    let verticalPadding: CGFloat = 20
    let panelSpacing: CGFloat = 16

    var availableWidth: CGFloat {
        size.width - (horizontalPadding * 2)
    }

    var panelsWidth: CGFloat {
        if layout.isSplit {
            return availableWidth - panelSpacing
        }

        return availableWidth
    }

    func width(
        for panel: ViewerPanel,
        at index: Int
    ) -> CGFloat {

        guard layout.isSplit else {
            return panelsWidth
        }

        let leftRatio = preferredLeftRatio

        if index == 0 {
            return panelsWidth * leftRatio
        }

        return panelsWidth * (1 - leftRatio)
    }

    private var preferredLeftRatio: CGFloat {

        guard let leftPanel = layout.leftPanel else {
            return 1
        }

        switch leftPanel {

        case .search, .toc:
            switch size.width {
            case 0..<1000:
                return 0.44

            case 1000..<1200:
                return 0.42

            default:
                return 0.40
            }

        case .html:
            return 0.50

        case .illustration:
            return 0.50
        }
    }
}
