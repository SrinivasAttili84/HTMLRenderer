//
//  TroubleshootingFilterCardView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct TroubleshootingFilterCardView: View {

    @Binding var filter: TroubleshootingFilter

    let onDelete: () -> Void
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Filter 1")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(AirNavXColor.textSecondary)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AirNavXColor.primaryBlue)
                }
                .buttonStyle(.plain)

                Button(action: onToggle) {
                    Image(systemName: filter.isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(AirNavXColor.primaryBlue)
                }
                .buttonStyle(.plain)
            }

            if filter.isExpanded {
                HStack(spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .fieldLabelStyle()

                        Picker("", selection: $filter.type) {
                            ForEach(TroubleshootingFilterType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(AirNavXColor.inputLine)
                                .frame(height: 1)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ATA Ref")
                            .fieldLabelStyle()

                        TextField("XX-XX-XX", text: $filter.ataRef)
                            .font(.system(size: 18))
                            .foregroundStyle(AirNavXColor.textPrimary)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .fill(AirNavXColor.inputLine)
                                    .frame(height: 1)
                            }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .fieldLabelStyle()

                    TextField("Description", text: $filter.description)
                        .font(.system(size: 18))
                        .foregroundStyle(AirNavXColor.textPrimary)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(AirNavXColor.inputLine)
                                .frame(height: 1)
                        }
                }
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

private extension Text {
    func fieldLabelStyle() -> some View {
        self
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(AirNavXColor.textSecondary)
    }
}
