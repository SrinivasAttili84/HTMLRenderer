//
//  ViewerWorkspaceView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerWorkspaceView: View {

    @ObservedObject var viewModel: ViewerViewModel

    var body: some View {
        GeometryReader { proxy in

            let metrics = ViewerWorkspaceMetrics(size: proxy.size)

            HStack(spacing: 16) {

                ViewerPanelContainer {
                    panelView(viewModel.layout.leftPanel)
                }
                .frame(width: metrics.leftWidth)

                ViewerPanelContainer {
                    panelView(viewModel.layout.rightPanel)
                }
                .frame(width: metrics.rightWidth)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .animation(.easeInOut(duration: 0.22), value: viewModel.layout)
        }
    }

    @ViewBuilder
    private func panelView(_ panel: ViewerPanel) -> some View {
        switch panel {

        case .search:
            SearchPanelSampleView(
                onRevisionSelected: viewModel.didSelectRevision
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
