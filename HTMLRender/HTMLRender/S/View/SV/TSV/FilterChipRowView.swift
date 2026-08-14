//
//  FilterChipRowView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct FilterChipRowView: View {
    let filters: [TroubleshootingFilter]
    let onRemove: (TroubleshootingFilter) -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text("+\(max(filters.count - 1, 0))")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AirNavXColor.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AirNavXColor.chipBackground)
                .clipShape(Capsule())

            ForEach(filters.prefix(2)) { filter in
                HStack(spacing: 8) {
                    Text(filter.type.rawValue)
                    if !filter.description.isEmpty {
                        Text(filter.description)
                    }

                    Button {
                        onRemove(filter)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AirNavXColor.primaryBlue)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(AirNavXColor.chipBackground)
                .clipShape(Capsule())
            }

            Spacer()
        }
    }
}
