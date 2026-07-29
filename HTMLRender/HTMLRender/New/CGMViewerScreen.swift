//
//  CGMViewerScreen.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI

struct CGMViewerScreen: View {

    let cgmURL: URL

    @State private var document: CGMDocument?
    @State private var errorMessage: String?

    var body: some View {

        ZStack {

            Color.white
                .ignoresSafeArea()

            if let document {

                GeometryReader { geometry in

                    Canvas { context, size in

                        CGMRenderer.render(
                            document: document,
                            context: &context,
                            size: size
                        )
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }

            } else if let errorMessage {

                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()

            } else {

                ProgressView("Loading CGM...")
            }
        }
        .onAppear {
            loadCGM()
        }
    }

    private func loadCGM() {

        do {
            let parser = CGMParser()
            let parsedDocument = try parser.parse(url: cgmURL)
            document = parsedDocument
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
