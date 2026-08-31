//
//  SearchPanelSampleView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct SearchPanelSampleView: View {

    let selectedRevision: ManualRevisionSelection?

    let onRevisionSelected:
        (ManualRevisionSelection) -> Void

    let onSearchResultSelected:
        (TOCElementSelection) -> Void

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            Text("Search")
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.04,
                        blue: 0.36
                    )
                )

            Text("Search on this document's revision.")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)

            revisionButton

            if selectedRevision != nil {
                Divider()

                Text("Search Results")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )

                searchResultButton
            }

            Spacer()
        }
        .padding(24)
    }

    private var revisionButton: some View {

        Button {

            onRevisionSelected(
                ManualRevisionSelection(
                    manualCode: "AMM",
                    revisionId: "REV-87",
                    revisionDate: "20-Mar-2023"
                )
            )

        } label: {

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text("AMM Revision")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )

                Text("Rev date: 20-Mar-2023")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color.gray.opacity(0.35),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    private var searchResultButton: some View {

        Button {

            onSearchResultSelected(
                TOCElementSelection(
                    elementId: "SEARCH-32-42-27-000-001-A",
                    taskCode: "32-42-27-000-001-A",
                    title: "32-42-27-000-001-A - Removal of the Brake"
                )
            )

        } label: {

            HStack(spacing: 12) {

                Image(systemName: "doc.text")

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text("Removal of the Brake")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )

                    Text("32-42-27-000-001-A")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .foregroundStyle(Color.primary)
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        Color.gray.opacity(0.30),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
