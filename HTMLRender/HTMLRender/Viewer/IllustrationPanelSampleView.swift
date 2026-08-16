//
//  IllustrationPanelSampleView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

struct IllustrationPanelSampleView: View {

    let selectedIllustration: IllustrationSelection?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Illustration")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.00, green: 0.04, blue: 0.36))

            if let selectedIllustration {
                Text(selectedIllustration.figureTitle)
                    .font(.system(size: 18, weight: .semibold))

                Text("Sheet \(selectedIllustration.sheetNumber)")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.08))

                VStack(spacing: 16) {
                    Image(systemName: "airplane")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.gray.opacity(0.7))

                    Text("Illustration Preview")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Button("Sheet 1") { }
                    .buttonStyle(.borderedProminent)

                Button("Sheet 2") { }
                    .buttonStyle(.bordered)

                Button("Sheet 3") { }
                    .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding(24)
    }
}
