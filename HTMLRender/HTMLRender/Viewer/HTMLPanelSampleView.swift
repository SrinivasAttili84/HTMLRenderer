//
//  HTMLPanelSampleView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct HTMLPanelSampleView: View {

    let selectedElement: TOCElementSelection?
    let onIllustrationSelected: (IllustrationSelection) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("HTML Viewer")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.00, green: 0.04, blue: 0.36))

            if let selectedElement {
                Text(selectedElement.title)
                    .font(.system(size: 18, weight: .semibold))
            } else {
                Text("No task selected")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Text("TASK 32-42-27-000-001-A")
                        .font(.system(size: 18, weight: .bold))

                    Text("Removal of the Brake")
                        .font(.system(size: 17))

                    Text("WARNING: Make sure safety locks are in position before starting the procedure.")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.red)

                    Button {
                        onIllustrationSelected(
                            IllustrationSelection(
                                illustrationId: "FIG-32-42-27-001",
                                figureTitle: "Brake Unit Illustration",
                                sheetNumber: 1
                            )
                        )
                    } label: {
                        HStack {
                            Image(systemName: "photo")

                            Text("Open Figure 32-42-27-001")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundStyle(Color(red: 0.00, green: 0.14, blue: 0.62))
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.blue.opacity(0.45), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding(24)
    }
}
