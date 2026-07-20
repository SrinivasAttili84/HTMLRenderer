//
//  SVGWebView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI
import WebKit

struct SVGWebView: UIViewRepresentable {

    let svgURL: URL

    func makeUIView(
        context: Context
    ) -> WKWebView {

        let webView = WKWebView()

        webView.isOpaque = false
        webView.backgroundColor = .white

        webView.scrollView.minimumZoomScale = 1
        webView.scrollView.maximumZoomScale = 8

        return webView
    }

    func updateUIView(
        _ webView: WKWebView,
        context: Context
    ) {

        guard let svgString =
        try? String(
            contentsOf: svgURL,
            encoding: .utf8
        ) else {
            return
        }

        let html = """
        <!DOCTYPE html>

        <html>

        <head>

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <style>

            html, body {

                margin: 0;
                padding: 0;

                width: 100%;
                height: 100%;

                background: white;
                overflow: auto;
            }

            svg {

                width: 100%;
                height: auto;

                display: block;
            }

        </style>

        </head>

        <body>

            \(svgString)

        </body>

        </html>
        """

        webView.loadHTMLString(
            html,
            baseURL:
                svgURL.deletingLastPathComponent()
        )
    }
}
