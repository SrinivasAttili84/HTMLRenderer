//
//  TroubleshootingResultCardView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct TroubleshootingResultCardView: View {
    let result: TroubleshootingResult
    let onReferenceTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                Text(result.titlePrefix)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AirNavXColor.textPrimary)

                Text(result.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AirNavXColor.textPrimary)

                if let highlightedText = result.highlightedText {
                    Text(highlightedText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(AirNavXColor.warningBrown)
                }
            }
            .lineLimit(2)

            Text(result.message)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(AirNavXColor.textPrimary)

            Divider()

            HStack(spacing: 8) {
                Text("Ref. TASK:")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(AirNavXColor.textSecondary)

                Button(action: onReferenceTap) {
                    Text(result.referenceTask)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(AirNavXColor.linkBlue)
                        .underline()
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(18)
        .background(AirNavXColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(AirNavXColor.border, lineWidth: 1)
        }
    }
}
