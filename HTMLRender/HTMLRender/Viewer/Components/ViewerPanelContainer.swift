//
//  ViewerPanelContainer.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerPanelContainer<Content: View>: View {

    @ViewBuilder let content: Content

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            }
    }
}
