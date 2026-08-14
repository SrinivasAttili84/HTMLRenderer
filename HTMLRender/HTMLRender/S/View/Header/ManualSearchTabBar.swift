//
//  ManualSearchTabBar.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct ManualSearchTabBar: View {
    let modes: [ManualSearchMode]
    let selectedMode: ManualSearchMode
    let onSelect: (ManualSearchMode) -> Void

    var body: some View {
        HStack(spacing: 28) {
            ForEach(modes) { mode in
                Button {
                    onSelect(mode)
                } label: {
                    VStack(spacing: 8) {
                        Text(mode.rawValue)
                            .font(.system(size: 22, weight: selectedMode == mode ? .bold : .regular))
                            .foregroundStyle(AirNavXColor.primaryBlue)

                        Rectangle()
                            .fill(selectedMode == mode ? AirNavXColor.primaryBlue : Color.clear)
                            .frame(height: 2)
                    }
                    .fixedSize()
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 24)
        .padding(.bottom, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AirNavXColor.primaryBlue.opacity(0.65))
                .frame(height: 1)
                .padding(.horizontal, 28)
        }
    }
}
