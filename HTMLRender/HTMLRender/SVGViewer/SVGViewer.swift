//
//  SVGViewer.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 01/09/26.
//

import SwiftUI
import WebKit

struct SVGViewer: UIViewRepresentable {

    func makeUIView(context: Context) -> WKWebView {

        let webView = WKWebView()

        loadSVG(in: webView)

        return webView
    }

    func updateUIView(
        _ uiView: WKWebView,
        context: Context
    ) {
    }

    private func loadSVG(
        in webView: WKWebView
    ) {

        guard let url = Bundle.main.url(
            forResource: "sample1",
            withExtension: "svg"
        ) else {
            return
        }

        guard let svgText = try? String(contentsOf: url) else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport"
              content="width=device-width,
                       initial-scale=1.0,
                       maximum-scale=10.0,
                       user-scalable=yes">

        <style>
        body {
            margin:0;
            padding:0;
            background:white;
            overflow:auto;
        }

        svg {
            width:100%;
            height:auto;
        }
        </style>
        </head>

        <body>
        \(svgText)
        </body>
        </html>
        """

        webView.loadHTMLString(
            html,
            baseURL: nil
        )
    }
}
