//
//  ContentView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject
    private var viewModel = TOCViewModel()

    var body: some View {

        VStack(spacing: 0) {

            HeaderView()

            Toolbar()

            HStack(alignment: .top, spacing: 16) {

                TOCPanelView(
                    viewModel: viewModel
                )
                .frame(width: 560)

                // Right side placeholder
                RoundedRectangle(
                    cornerRadius: 10
                )
                .fill(.white)
                .overlay {

                    Text("Rendering Pane")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .background(
            Color.airbusBackground
        )
        .task {
            viewModel.load()
        }
    }
}
