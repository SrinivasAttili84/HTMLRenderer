//
//  TOCNodeRowView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct TOCNodeRowView: View {

    let node: TOCNode
    let level: Int
    let isExpanded: Bool
    let isInSelectedPath: Bool
    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        HStack(spacing: 0) {

            Spacer()
                .frame(width: leadingIndent)

            iconView

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                titleText

                if node.type == .solution {

                    Text("**ON A/C FSN ALL")
                        .font(.system(size: 18))
                        .foregroundColor(.airbusSecondaryText)
                }
            }

            Spacer()

            trailingIcon
        }
        .padding(.horizontal, 16)
        .frame(height: rowHeight)
        .background(
            viewModel.isHighlighted(node: node) ? Color.airbusSelected: Color.white //new
        )
        .overlay(
            Rectangle()
                .fill(Color.airbusRowBorder)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private var leadingIndent: CGFloat {

        switch node.type {

        case .level1:
            return 0

        case .level2:
            return 42

        case .level3:
            return 74

        case .level4:
            return 104

        case .solution:
            return 74
        }
    }

    private var rowHeight: CGFloat {

        switch node.type {

        case .solution:
            return 94

        default:
            return 76
        }
    }

    @ViewBuilder
    private var iconView: some View {

        if node.type == .solution {

            Image(systemName: "doc.text")
                .font(.system(size: 24))
                .foregroundColor(.airbusTextBlue)
                .frame(width: 42)

        } else {

            Spacer()
                .frame(width: 42)
        }
    }

    @ViewBuilder
    private var titleText: some View {

        switch node.type {

        case .solution:

            solutionTitleView

        default:

            Text("\(node.ataCode) - \(node.title)")
                .font(
                    .system(
                        size: fontSize,
                        weight: fontWeight
                    )
                )
                .foregroundColor(.airbusTextBlue)
                .lineLimit(2)
        }
    }

    private var solutionTitleView: some View {

        let text = node.title

        return Text(makeBoldPrefix(text))
            .font(.system(size: 22))
            .foregroundColor(
                viewModel.isHighlighted(
                    node: node
                )
                ? .airbusTextBlue
                : .black
            )
//            .foregroundColor(.airbusTextBlue)
            .lineLimit(2)
    }

    private func makeBoldPrefix(
        _ text: String
    ) -> AttributedString {

        var attributed = AttributedString(text)

        if let range = attributed.range(of: " - ") {

            let boldRange = attributed.startIndex..<range.lowerBound

            attributed[boldRange].font =
                .system(size: 22, weight: .bold)
        }

        return attributed
    }

    private var fontSize: CGFloat {

        switch node.type {

        case .level1:
            return 26

        case .level2:
            return 24

        case .level3:
            return 22

        case .level4:
            return 21

        case .solution:
            return 22
        }
    }

    private var fontWeight: Font.Weight {

        switch node.type {

        case .level1:
            return .semibold

        case .level2:
            return .regular

        case .level3:
            return .regular

        case .level4:
            return .semibold

        case .solution:
            return .regular
        }
    }

    @ViewBuilder
    private var trailingIcon: some View {

        if (node.children ?? []).isEmpty {

            Spacer()
                .frame(width: 28)

        } else {

            Image(
                systemName:
                    isExpanded
                    ? "chevron.up"
                    : "chevron.down"
            )
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.airbusTextBlue)
            .frame(width: 34)
        }
    }
}
