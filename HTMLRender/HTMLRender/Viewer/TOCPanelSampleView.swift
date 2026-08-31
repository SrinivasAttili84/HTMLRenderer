//
//  TOCPanelSampleView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct TOCPanelSampleView: View {

    let selectedRevision: ManualRevisionSelection?
    let onElementSelected: (TOCElementSelection) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("TOC")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(red: 0.00, green: 0.04, blue: 0.36))

                Spacer()

                if let selectedRevision {
                    Text(selectedRevision.manualCode)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }

            if let selectedRevision {
                Text("Revision: \(selectedRevision.revisionDate)")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            } else {
                Text("Select a revision from Search.")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }

            Divider()

            ScrollView {
                VStack(spacing: 8) {

                    tocRow(
                        title: "32-41 - WHEELS",
                        isHeader: true
                    )

                    tocRow(
                        title: "32-42 - NORMAL BRAKING",
                        isHeader: true
                    )

                    tocElementButton(
                        title: "32-42-27-000-001-A - Removal of the Brake"
                    )

                    tocElementButton(
                        title: "32-42-27-000-002-A - Installation of the Brake"
                    )

                    tocElementButton(
                        title: "32-42-27-000-004-A - Removal of Brake Hydraulic"
                    )
                }
            }

            Spacer()
        }
        .padding(24)
    }

    private func tocRow(
        title: String,
        isHeader: Bool
    ) -> some View {
        HStack {
            Text(title)
                .font(.system(size: isHeader ? 16 : 15, weight: isHeader ? .bold : .regular))

            Spacer()

            Image(systemName: "chevron.down")
        }
        .padding()
        .background(Color.gray.opacity(0.06))
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        }
    }

    private func tocElementButton(title: String) -> some View {
        Button {
            onElementSelected(
                TOCElementSelection(
                    elementId: UUID().uuidString,
                    taskCode: "32-42-27-000-001-A",
                    title: title
                )
            )
        } label: {
            HStack {
                Image(systemName: "doc.text")

                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
