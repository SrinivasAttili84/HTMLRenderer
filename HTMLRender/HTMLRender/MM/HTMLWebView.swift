//
//  HTMLWebView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI
import WebKit

struct HTMLWebView: UIViewRepresentable {

    let page: String?

    func makeUIView(context: Context) -> WKWebView {

        WKWebView()
    }

    func updateUIView(_ webView: WKWebView,
                      context: Context) {

        guard let url = Bundle.main.url(
            forResource: "sample",
            withExtension: "html"
        ) else {
            print("HTML not found")
            return
        }

        print(url.path)

        webView.loadFileURL(
            url,
            allowingReadAccessTo: url.deletingLastPathComponent()
        )
    }
}
