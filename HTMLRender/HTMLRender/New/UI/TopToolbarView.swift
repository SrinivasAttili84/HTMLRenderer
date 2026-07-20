//
//  TopToolbarView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct TopToolbarView: View {

    var body: some View {

        HStack(spacing: 28) {

            Button {} label: {

                Image(systemName: "arrow.left")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundColor(.airbusTextBlue)
            }

            Button {} label: {

                Image(systemName: "arrow.right")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundColor(.airbusTextBlue)
            }

            Spacer()
        }
        .padding(.horizontal, 70)
        .frame(height: 64)
        .background(Color.airbusBackground)
    }
}
