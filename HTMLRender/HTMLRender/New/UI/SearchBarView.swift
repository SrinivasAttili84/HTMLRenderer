//
//  SearchBarView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct SearchBarView: View {

    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        VStack(spacing: 0) {

            HStack {

                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField(
                    "Search solution",
                    text: $viewModel.searchText
                )
                .textFieldStyle(.plain)
                .onChange(of: viewModel.searchText) { _, _ in

                    viewModel.search()
                }

                if !viewModel.searchText.isEmpty {

                    Button {
                        viewModel.searchText = ""
                        viewModel.searchResults = []
                    } label: {

                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color.white)

            if !viewModel.searchResults.isEmpty {

                VStack(spacing: 0) {

                    ForEach(viewModel.searchResults.prefix(8)) { node in

                        Button {

                            viewModel.openSearchResult(node)

                        } label: {

                            HStack {

                                Image(systemName: "doc.text")
                                    .foregroundColor(.airbusTextBlue)

                                Text(node.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.white)
                        }

                        Divider()
                    }
                }
                .overlay(
                    Rectangle()
                        .stroke(
                            Color.airbusRowBorder,
                            lineWidth: 1
                        )
                )
            }

            Divider()
        }
    }
}
