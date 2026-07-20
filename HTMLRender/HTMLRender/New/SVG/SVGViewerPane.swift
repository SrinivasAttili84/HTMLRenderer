//
//  SVGViewerPane.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct SVGViewerPane: View {

    let svgFileName: String

    var body: some View {

        VStack(spacing: 0) {

            HStack {

                Text("Illustration Viewer")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
            }
            .padding()

            Divider()

            if let svgURL =
                Bundle.main.url(
                    forResource: svgFileName,
                    withExtension: "svg"
                ) {

                SVGWebView(
                    svgURL: svgURL
                )

            } else {

                ContentUnavailableView(
                    "SVG Not Found",
                    systemImage: "photo"
                )
            }
        }
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
}
