//
//  ViewerScreen.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct ViewerScreen: View {

    @StateObject private var viewModel = ViewerViewModel()

    var body: some View {
        VStack(spacing: 0) {

            ViewerToolbar(
                layout: viewModel.layout,
                onSearchTap: viewModel.didTapSearch,
                onTOCTap: viewModel.didTapTOC,
                onHTMLTap: viewModel.didTapHTML,
                onIllustrationTap: viewModel.didTapIllustration
            )

            ViewerWorkspaceView(viewModel: viewModel)
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.95))
    }
}

