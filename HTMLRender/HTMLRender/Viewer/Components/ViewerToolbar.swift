//
//  ViewerToolbar.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerToolbar: View {

    let layout: ViewerLayoutState

    let onSearchTap: () -> Void
    let onTOCTap: () -> Void
    let onHTMLTap: () -> Void
    let onIllustrationTap: () -> Void

    var body: some View {

        HStack(spacing: 8) {

            Button(action: onSearchTap) {
                toolbarButton(
                    systemName: "magnifyingglass",
                    panel: .search
                )
            }

            Button(action: onTOCTap) {
                toolbarButton(
                    systemName: "list.bullet",
                    panel: .toc
                )
            }

            Button(action: onHTMLTap) {
                toolbarButton(
                    systemName: "doc.text",
                    panel: .html
                )
            }

            Button(action: onIllustrationTap) {
                toolbarButton(
                    systemName: "photo",
                    panel: .illustration
                )
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
        .background(.white)
    }
}

// MARK: - Helpers

extension ViewerToolbar {

    private func isVisible(
        _ panel: ViewerPanel
    ) -> Bool {

        layout.leftPanel == panel ||
        layout.rightPanel == panel
    }

    @ViewBuilder
    private func toolbarButton(
        systemName: String,
        panel: ViewerPanel
    ) -> some View {

        let selected = isVisible(panel)

        Image(systemName: systemName)
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(
                selected
                ? Color.white
                : Color.blue
            )
            .frame(width: 48, height: 44)
            .background(
                selected
                ? Color.blue
                : Color.clear
            )
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color.blue,
                        lineWidth: 1
                    )
            }
    }
}
