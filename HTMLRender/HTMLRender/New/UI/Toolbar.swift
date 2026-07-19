//
//  Toolbar.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import SwiftUI

struct Toolbar: View {
    
    var body: some View {

        HStack {

            Button {} label: {
                Image(systemName: "arrow.left")
            }

            Button {} label: {
                Image(systemName: "arrow.right")
            }

            Spacer()

            Text("AMM")
                .font(.title3)
                .fontWeight(.bold)

            Text(
                "Revision date : 20-Mar-2023"
            )
            .foregroundColor(.secondary)

            Spacer()

            Image(systemName: "magnifyingglass")

            toolbarButton(
                icon: "list.bullet"
            )

            toolbarButton(
                icon: "text.bubble"
            )

            toolbarButton(
                icon: "photo"
            )
        }
        .padding(.horizontal)
        .frame(height: 58)
        .background(.white)
        .overlay(alignment: .bottom) {

            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 1)
        }
    }

    @ViewBuilder
    func toolbarButton(
        icon: String
    ) -> some View {

        RoundedRectangle(
            cornerRadius: 6
        )
        .fill(
            Color.airbusBlue
        )
        .frame(width: 40, height: 40)
        .overlay {

            Image(systemName: icon)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    Toolbar()
}
