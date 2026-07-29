//
//  CGMDisplayListViewerScreen.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI

struct CGMDisplayListViewerScreen: View {

    let cgmURL: URL

    @State private var displayList: CGMDisplayList?
    @State private var message: String = "Loading CGM..."

    var body: some View {

        ZStack {

            Color.white
                .ignoresSafeArea()

            if let displayList {

                GeometryReader { geometry in

                    Canvas { context, size in

                        DisplayListRenderer.render(
                            displayList: displayList,
                            context: &context,
                            size: size
                        )
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }

            } else {

                ProgressView(message)
                    .padding()
            }
        }
        .onAppear {
            load()
        }
    }

    private func load() {

        do {

            let cache = DisplayListCache.shared

            if cache.exists(for: cgmURL) {

                message = "Loading cached display list..."

                let cachedDisplayList = try cache.load(
                    for: cgmURL
                )

                displayList = cachedDisplayList

                print("Loaded from display list cache")

            } else {

                message = "Parsing CGM..."

                let parser = CGMParser()

                let document = try parser.parse(
                    url: cgmURL
                )

                let builder = DisplayListBuilder()

                let builtDisplayList = builder.build(
                    document: document,
                    figureId: cgmURL.deletingPathExtension().lastPathComponent,
                    sourceFileName: cgmURL.lastPathComponent
                )

                try cache.save(
                    builtDisplayList,
                    for: cgmURL
                )

                displayList = builtDisplayList

                print("Parsed CGM and saved display list")
            }

        } catch {

            message = error.localizedDescription

            print("CGM DisplayList error: \(error)")
        }
    }
}
