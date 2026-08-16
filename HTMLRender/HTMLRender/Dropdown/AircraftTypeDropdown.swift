//
//  AircraftTypeDropdown.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct AirNavXDropdown: View {

    let title: String

    @Binding var selectedItem: String?

    let items: [String]

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)

            Menu {

                ForEach(items, id: \.self) { item in

                    Button(item) {
                        selectedItem = item
                    }
                }

            } label: {

                HStack {

                    Text(selectedItem ?? "Choose your item")
                        .font(.system(size: 16))
                        .foregroundColor(
                            selectedItem == nil
                            ? .secondary
                            : .primary
                        )

                    Spacer()

                    VStack(spacing: -2) {

                        Image(systemName: "chevron.up")
                            .font(.system(size: 8, weight: .medium))

                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .medium))
                    }
                    .foregroundColor(.secondary)
                }
                .frame(height: 32)
                .contentShape(Rectangle())
            }

            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(height: 1)
        }
    }
}
