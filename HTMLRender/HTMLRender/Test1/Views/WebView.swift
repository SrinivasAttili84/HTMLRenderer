//
//  WebView.swift
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let html: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()

        let webView = WKWebView(frame: .zero,
                                configuration: config)

        webView.navigationDelegate = context.coordinator

        if let baseURL = Bundle.main.resourceURL {

            webView.loadHTMLString(html,
                                   baseURL: baseURL)

        }

        return webView
    }

    func updateUIView(_ webView: WKWebView,
                      context: Context) {

        if let baseURL = Bundle.main.resourceURL {

            webView.loadHTMLString(html,
                                   baseURL: baseURL)

        }

    }

}

// MARK: Coordinator

extension WebView {

    final class Coordinator: NSObject,
                             WKNavigationDelegate {

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            guard let url = navigationAction.request.url else {

                decisionHandler(.allow)
                return

            }

            if url.scheme == "reference" {

                print("Reference : \(url.absoluteString)")

                decisionHandler(.cancel)

                return
            }

            if url.scheme == "equipment" {

                print("Equipment : \(url.absoluteString)")

                decisionHandler(.cancel)

                return
            }

            decisionHandler(.allow)

        }

    }

}
