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
        max(
            size.width - (horizontalPadding * 2),
            0
        )
    }

    var panelsWidth: CGFloat {
        if layout.isSplit {
            return max(
                availableWidth - panelSpacing,
                0
            )
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

        if index == 0 {
            return panelsWidth * preferredLeftRatio
        }

        return panelsWidth * (1 - preferredLeftRatio)
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
            // HTML | Illustration
            return 0.50

        case .illustration:
            return 0.50
        }
    }
}
