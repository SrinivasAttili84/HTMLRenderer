//
//  TOCView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//


import SwiftUI

struct TOCRowContentView: View {

    let node: TOCNode

    var body: some View {

        HStack(spacing: 8) {

            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .frame(width: 20)

            if node.type == .solution {

                Text(node.title)
                    .font(.system(size: 15))

            } else {

                Text("\(node.ataCode) - \(node.title)")
                    .font(rowFont)
            }
        }
        .padding(.vertical, 3)
    }

    private var iconName: String {

        switch node.type {
        case .solution:
            return "doc.text"

        default:
            return "chevron.right"
        }
    }

    private var iconColor: Color {

        switch node.type {
        case .solution:
            return .gray

        default:
            return .secondary
        }
    }

    private var rowFont: Font {

        switch node.type {
        case .level4:
            return .system(size: 16, weight: .semibold)

        default:
            return .system(size: 16)
        }
    }
}


struct TOCView: View {

    @StateObject private var viewModel = TOCViewModel()

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 0) {

                HStack {

                    Text("Browse")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "magnifyingglass")

                    Text("Search")
                        .font(.headline)
                }
                .padding()

                Toggle(
                    "Extended display",
                    isOn: .constant(false)
                )
                .padding(.horizontal)

                if viewModel.isLoading {

                    ProgressView("Loading TOC...")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )

                } else {

                    List {

                        OutlineGroup(
                            viewModel.rootNodes,
                            children: \.children
                        ) { node in

                            TOCRowContentView(
                                node: node
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {

                                viewModel.selectedNode = node

                                if node.type == .solution {

                                    print("Selected Solution:")
                                    print("Title:", node.title)
                                    print("Solution Id:", node.solutionId ?? "")
                                    print("TR Code:", node.trCode ?? "")
                                    print("XML File:", node.xmlFile ?? "")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Manual")
            .task {
                viewModel.load()
            }
        }
    }
}


struct ContentView: View {

    var body: some View {

        TOCView()
    }
}
