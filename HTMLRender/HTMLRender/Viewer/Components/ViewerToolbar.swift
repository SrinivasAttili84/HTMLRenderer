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
            .buttonStyle(.plain)

            Button(action: onTOCTap) {
                toolbarButton(
                    systemName: "list.bullet",
                    panel: .toc
                )
            }
            .buttonStyle(.plain)

            Button(action: onHTMLTap) {
                toolbarButton(
                    systemName: "doc.text",
                    panel: .html
                )
            }
            .buttonStyle(.plain)

            Button(action: onIllustrationTap) {
                toolbarButton(
                    systemName: "photo",
                    panel: .illustration
                )
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
        .background(Color.white)
    }
}

// MARK: - Helpers

private extension ViewerToolbar {

    func isVisible(_ panel: ViewerPanel) -> Bool {
        layout.contains(panel)
    }

    @ViewBuilder
    func toolbarButton(
        systemName: String,
        panel: ViewerPanel
    ) -> some View {

        let selected = isVisible(panel)

        Image(systemName: systemName)
            .font(
                .system(
                    size: 20,
                    weight: .medium
                )
            )
            .foregroundStyle(
                selected
                ? Color.white
                : Color.blue
            )
            .frame(
                width: 48,
                height: 44
            )
            .background(
                selected
                ? Color.blue
                : Color.clear
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
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
