//
//  ContentView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = TOCViewModel()

    var body: some View {
        HStack {

            ManualTOCPanelView(
                viewModel: viewModel
            )
            .frame(width: 720)

//            SVGViewerPane(
//                svgFileName: "sample"
//            )
        }
//        VStack(spacing: 0) {
//
//            TopToolbarView()
//
//            HStack(alignment: .top) {
//
//                ManualTOCPanelView(
//                    viewModel: viewModel
//                )
//                .frame(width: 720)
//
//                Spacer()
//            }
//            .padding(24)
//        }
        .background(Color.airbusBackground)
        .task {

            viewModel.load()
        }
    }
}
