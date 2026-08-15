//
//  ManualRowView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 15/08/26.
//

import SwiftUI

struct ManualRowView: View {

    var body: some View {

        Button {

        } label: {

            HStack(alignment: .top) {

                Text("AMM")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 42)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 10) {

                    Text("BGA - A330 - F-GXLQ")
                        .font(.system(size: 28, weight: .bold))

                    HStack(spacing: 14) {

                        Text("MSN: 00237")

                        Text("|")

                        Text("FNS: 008")

                        Text("|")

                        Text("Label: TRENT772B-60")
                    }
                    .font(.system(size: 18))

                    Text("** ON A/C FSN ALL")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Rev: 105 (05-Aug-2026)")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(.white)
            .overlay {

                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            }
        }
        .buttonStyle(.plain)
    }
}
