//
//  ViewerWorkspaceMetrics.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerWorkspaceMetrics {

    let size: CGSize

    var availableWidth: CGFloat {
        size.width - 48 - 16
    }

    var leftWidth: CGFloat {
        switch size.width {
        case 0..<1000:
            return availableWidth * 0.44
        case 1000..<1200:
            return availableWidth * 0.42
        default:
            return availableWidth * 0.40
        }
    }

    var rightWidth: CGFloat {
        availableWidth - leftWidth
    }
}
