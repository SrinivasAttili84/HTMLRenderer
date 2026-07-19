//
//  TOCPanelView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import SwiftUI

struct TOCPanelView: View {

    @ObservedObject
    var viewModel: TOCViewModel

    var body: some View {

        VStack(spacing: 0) {

            HStack {

                Text(
                    "AIRCRAFT MAINTENANCE MANUAL"
                )
                .fontWeight(.bold)
                .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 60)
            .background(
                Color.airbusBlue
            )

            List {

                OutlineGroup(
                    viewModel.rootNodes,
                    children: \.children
                ) { node in

                    TOCRowView(
                        node: node,
                        isSelected:
                        viewModel.selectedNode?.id
                        == node.id
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {

                        viewModel.selectedNode = node
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: 4,
                            bottom: 0,
                            trailing: 4
                        )
                    )
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.white)
        }
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 10
            )
            .stroke(
                Color.airbusBorder,
                lineWidth: 1
            )
        }
    }
}

struct TOCRowView: View {

    let node: TOCNode
    let isSelected: Bool

    var body: some View {

        HStack(spacing: 10) {

            if node.type == .solution {

                Image(
                    systemName: "doc.text"
                )
                .foregroundColor(.gray)

            } else {

                Image(
                    systemName: "chevron.right"
                )
                .font(.caption)
                .foregroundColor(
                    .airbusText
                )
            }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                if node.type == .solution {

                    Text(node.title)
                        .font(
                            .system(size: 15)
                        )

                } else {

                    Text(
                        "\(node.ataCode) - \(node.title)"
                    )
                    .font(
                        node.type == .level4
                        ? .system(
                            size: 15,
                            weight: .semibold
                        )
                        : .system(
                            size: 15
                        )
                    )
                    .foregroundColor(
                        .airbusText
                    )
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            isSelected
            ? Color.airbusSelection
            : Color.white
        )
    }
}
