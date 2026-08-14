//
//  ManualSearchResultCardView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct ManualSearchResultCardView: View {
    let result: SearchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(result.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AirNavXColor.textPrimary)

            Text(result.path)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AirNavXColor.linkBlue)

            Text(result.snippet)
                .font(.system(size: 17))
                .foregroundStyle(AirNavXColor.textSecondary)
                .lineLimit(3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AirNavXColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(AirNavXColor.border, lineWidth: 1)
        }
    }
}
