//
//  HTMLBuilder.swift
//  HTMLRenderer
//

import Foundation

final class HTMLBuilder {

    // MARK: - Public

    func build(document: XMLDocument) -> String {

        guard let root = document.root else {

            return ""

        }

        var html = ""

        html += render(node: root,
                       level: 1)

        guard let templateURL = Bundle.main.url(forResource: "HTMLTemplate",
                                                withExtension: "html"),

              var template = try? String(contentsOf: templateURL)

        else {

            return html

        }

        template = template.replacingOccurrences(of: "{{CONTENT}}",
                                                 with: html)

        return template
    }
}

// MARK: - Private

private extension HTMLBuilder {

    func render(node: XMLNode,
                level: Int) -> String {

        var html = ""

        html += HTMLTagRenderer.startTag(for: node,
                                         level: level)

        if !node.text.isEmpty {

            html += escape(node.text)

        }

        for child in node.children {

            html += render(node: child,
                           level: level + 1)

        }

        html += HTMLTagRenderer.endTag(for: node)

        return html
    }

}

// MARK: - HTML Escape

private extension HTMLBuilder {

    func escape(_ text: String) -> String {

        var value = text

        value = value.replacingOccurrences(of: "&",
                                           with: "&amp;")

        value = value.replacingOccurrences(of: "<",
                                           with: "&lt;")

        value = value.replacingOccurrences(of: ">",
                                           with: "&gt;")

        value = value.replacingOccurrences(of: "\"",
                                           with: "&quot;")

        value = value.replacingOccurrences(of: "'",
                                           with: "&#39;")

        return value

    }

}
