//
//  ViewerWorkspaceView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerWorkspaceView: View {

    @ObservedObject var viewModel: ViewerViewModel

    @State private var dragOffset: CGFloat = 0

    private let collapseThreshold: CGFloat = 120
    private let maximumVerticalTranslation: CGFloat = 70

    var body: some View {

        GeometryReader { proxy in

            let metrics = ViewerWorkspaceMetrics(
                size: proxy.size,
                layout: viewModel.layout
            )

            HStack(spacing: metrics.panelSpacing) {

                ForEach(
                    Array(
                        viewModel.layout.visiblePanels.enumerated()
                    ),
                    id: \.element.id
                ) { index, panel in

                    ViewerPanelContainer {
                        panelView(panel)
                    }
                    .frame(
                        width: metrics.width(
                            for: panel,
                            at: index
                        )
                    )
                    .offset(
                        x: panelOffset(for: index)
                    )
                    .opacity(
                        panelOpacity(for: index)
                    )
                }
            }
            .padding(
                .horizontal,
                metrics.horizontalPadding
            )
            .padding(
                .vertical,
                metrics.verticalPadding
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .leading
            )
            .contentShape(Rectangle())
            .simultaneousGesture(
                collapseGesture
            )
            .animation(
                .easeInOut(duration: 0.22),
                value: viewModel.layout
            )
        }
    }

    @ViewBuilder
    private func panelView(
        _ panel: ViewerPanel
    ) -> some View {

        switch panel {

        case .search:
            SearchPanelSampleView(
                selectedRevision: viewModel.selectedRevision,
                onRevisionSelected: viewModel.didSelectRevision,
                onSearchResultSelected: viewModel.didSelectSearchElement
            )

        case .toc:
            TOCPanelSampleView(
                selectedRevision: viewModel.selectedRevision,
                onElementSelected: viewModel.didSelectTOCElement
            )

        case .html:
            HTMLPanelSampleView(
                selectedElement: viewModel.selectedTOCElement,
                onIllustrationSelected: viewModel.didSelectIllustration
            )

        case .illustration:
            IllustrationPanelSampleView(
                selectedIllustration: viewModel.selectedIllustration
            )
        }
    }
}

// MARK: - Gesture

private extension ViewerWorkspaceView {

    var collapseGesture: some Gesture {

        DragGesture(minimumDistance: 20)
            .onChanged { value in

                guard viewModel.layout.isSplit else {
                    dragOffset = 0
                    return
                }

                let horizontal = value.translation.width
                let vertical = value.translation.height

                guard abs(horizontal) > abs(vertical) else {
                    dragOffset = 0
                    return
                }

                // Interactive movement only for right-to-left dragging.
                dragOffset = min(0, horizontal)
            }
            .onEnded { value in

                let horizontal = value.translation.width
                let vertical = abs(value.translation.height)

                let isRightToLeft =
                    horizontal <= -collapseThreshold

                let isMostlyHorizontal =
                    abs(horizontal) > vertical &&
                    vertical <= maximumVerticalTranslation

                if viewModel.layout.isSplit,
                   isRightToLeft,
                   isMostlyHorizontal {

                    viewModel.didSwipeRightToLeft()
                }

                withAnimation(
                    .easeOut(duration: 0.18)
                ) {
                    dragOffset = 0
                }
            }
    }

    func panelOffset(
        for index: Int
    ) -> CGFloat {

        guard viewModel.layout.isSplit else {
            return 0
        }

        if index == 0 {
            return dragOffset
        }

        return dragOffset * 0.15
    }

    func panelOpacity(
        for index: Int
    ) -> Double {

        guard viewModel.layout.isSplit,
              index == 0,
              dragOffset < 0 else {
            return 1
        }

        let progress = min(
            abs(dragOffset) / collapseThreshold,
            1
        )

        return 1 - (progress * 0.35)
    }
}
