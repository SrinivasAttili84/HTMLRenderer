//
//  TroubleshootingBottomActionBar.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct TroubleshootingBottomActionBar: View {
    let onAdd: () -> Void
    let onReset: () -> Void
    let onApply: () -> Void

    var body: some View {
        HStack {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(AirNavXColor.primaryBlue)
                    .frame(width: 52, height: 52)
                    .background(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(AirNavXColor.primaryBlue, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)

            Spacer()

            Button(action: onReset) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset")
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AirNavXColor.primaryBlue)
                .frame(width: 150, height: 52)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AirNavXColor.primaryBlue, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)

            Button(action: onApply) {
                Text("Apply")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 160, height: 52)
                    .background(AirNavXColor.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AirNavXColor.border)
                .frame(height: 1)
        }
    }
}
