//
//  SearchPanelSampleView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct SearchPanelSampleView: View {

    let onRevisionSelected: (ManualRevisionSelection) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("Search")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.00, green: 0.04, blue: 0.36))

            Text("Search on this document's revision.")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)

            Button {
                onRevisionSelected(
                    ManualRevisionSelection(
                        manualCode: "AMM",
                        revisionId: "REV-87",
                        revisionDate: "20-Mar-2023"
                    )
                )
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("AMM Revision")
                        .font(.system(size: 18, weight: .bold))

                    Text("Rev date: 20-Mar-2023")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                }
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(24)
    }
}
