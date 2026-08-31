//
//  ViewerWorkspaceView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerWorkspaceView: View {

    @ObservedObject
    var viewModel: ViewerViewModel

    @State
    private var dragOffset: CGFloat = 0

    private let swipeThreshold: CGFloat = 85
    private let predictedSwipeThreshold: CGFloat = 130
    private let maximumVerticalTranslation: CGFloat = 90

    var body: some View {

        GeometryReader { proxy in

            let metrics = ViewerWorkspaceMetrics(
                size: proxy.size,
                layout: viewModel.layout
            )

            HStack(spacing: metrics.panelSpacing) {

                ForEach(
                    Array(
                        viewModel.layout
                            .visiblePanels
                            .enumerated()
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
                    .scaleEffect(
                        panelScale(for: index),
                        anchor: .leading
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
                contentCollapseGesture
            )
            .animation(
                .interactiveSpring(
                    response: 0.32,
                    dampingFraction: 0.88,
                    blendDuration: 0.2
                ),
                value: viewModel.layout
            )
        }
    }

    func panelScale(
        for index: Int
    ) -> CGFloat {

        guard viewModel.layout
            .allowsContentCollapseSwipe,
              index == 0,
              dragOffset < 0 else {
            return 1
        }

        let progress = min(
            abs(dragOffset) / swipeThreshold,
            1
        )

        return 1 - (progress * 0.08)
    }
    
    @ViewBuilder
    private func panelView(
        _ panel: ViewerPanel
    ) -> some View {

        switch panel {

        case .search:
            SearchPanelSampleView(
                selectedRevision:
                    viewModel.selectedRevision,
                onRevisionSelected:
                    viewModel.didSelectRevision,
                onSearchResultSelected:
                    viewModel.didSelectSearchElement
            )

        case .toc:
            TOCPanelSampleView(
                selectedRevision:
                    viewModel.selectedRevision,
                onElementSelected:
                    viewModel.didSelectTOCElement
            )

        case .html:
            HTMLPanelSampleView(
                selectedElement:
                    viewModel.selectedTOCElement,
                onIllustrationSelected:
                    viewModel.didSelectIllustration
            )

        case .illustration:
            IllustrationPanelSampleView(
                selectedIllustration:
                    viewModel.selectedIllustration
            )
        }
    }
}

// MARK: - Content Collapse Gesture

private extension ViewerWorkspaceView {

    var contentCollapseGesture: some Gesture {

        DragGesture(
            minimumDistance: 20,
            coordinateSpace: .local
        )
        .onChanged { value in

            guard viewModel.layout
                .allowsContentCollapseSwipe else {

                dragOffset = 0
                return
            }

            let horizontal =
                value.translation.width

            let vertical =
                value.translation.height

            let isMostlyHorizontal =
                abs(horizontal) > abs(vertical)

            guard isMostlyHorizontal else {
                dragOffset = 0
                return
            }

            /*
             Accept interactive movement only in the
             right-to-left direction.
             */

            dragOffset = min(
                horizontal,
                0
            )
        }
        .onEnded { value in

            defer {
                withAnimation(
                    .easeOut(duration: 0.18)
                ) {
                    dragOffset = 0
                }
            }

            guard viewModel.layout
                .allowsContentCollapseSwipe else {
                return
            }

            let horizontal =
                value.translation.width

            let predictedHorizontal =
                value.predictedEndTranslation.width

            let vertical =
                abs(value.translation.height)

            let isMostlyHorizontal =
                abs(horizontal) > vertical

            let verticalMovementIsValid =
                vertical <= maximumVerticalTranslation

            /*
             Support both:

             1. A slower drag passing the normal threshold.
             2. A faster flick passing the predicted threshold.
             */

            let passedTranslationThreshold =
                horizontal <= -swipeThreshold

            let passedVelocityThreshold =
                predictedHorizontal <= -predictedSwipeThreshold

            let shouldCollapse =
                passedTranslationThreshold ||
                passedVelocityThreshold

            guard isMostlyHorizontal,
                  verticalMovementIsValid,
                  shouldCollapse else {
                return
            }

            viewModel.didSwipeRightToLeft()
        }
    }

    func panelOffset(
        for index: Int
    ) -> CGFloat {

        guard viewModel.layout
            .allowsContentCollapseSwipe else {
            return 0
        }

        if index == 0 {

            // Left panel follows finger
            return dragOffset
        }

        // Content panel follows partially
        // making expansion feel natural
        return dragOffset * 0.45
    }

    func panelOpacity(
        for index: Int
    ) -> Double {

        guard viewModel.layout
            .allowsContentCollapseSwipe,
              index == 0,
              dragOffset < 0 else {
            return 1
        }

        let progress = min(
            abs(dragOffset) / swipeThreshold,
            1
        )

        // softer fade
        return max(
            0.35,
            1 - progress
        )
    }
}
