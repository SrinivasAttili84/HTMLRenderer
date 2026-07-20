//
//  ManualTOCPanelView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct ManualTOCPanelView: View {

    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        VStack(spacing: 0) {

            HStack {

                Text("AIRCRAFT MAINTENANCE MANUAL")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 22)
            .frame(height: 72)
            .background(Color.airbusBlue)

            SearchBarView(
                viewModel: viewModel
            )

            if viewModel.isLoading {

                ProgressView("Loading...")
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )

            } else {

                TOCTreeScrollView(
                    viewModel: viewModel
                )
            }
        }
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 14
            )
            .stroke(
                Color.airbusRowBorder,
                lineWidth: 1
            )
        }
    }
}
