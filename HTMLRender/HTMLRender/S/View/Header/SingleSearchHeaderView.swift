//
//  SingleSearchHeaderView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct SingleSearchHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(AirNavXColor.primaryBlue)

            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 24)
        .padding(.bottom, 10)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AirNavXColor.primaryBlue.opacity(0.65))
                .frame(height: 1)
                .padding(.horizontal, 28)
        }
    }
}
