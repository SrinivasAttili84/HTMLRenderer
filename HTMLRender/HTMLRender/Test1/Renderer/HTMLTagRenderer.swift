//
//  HTMLTagRenderer.swift
//  HTMLRenderer
//

import Foundation

struct HTMLTagRenderer {

    func generateHTML(from node: XMLNode) -> String {

        switch node.name {

        case "task":

            return node.children.map { generateHTML(from: $0) }.joined()

        case "title":

            return "<h2>\(escape(node.text))</h2>"

        case "subtask":

            return "<section>\(node.children.map { generateHTML(from: $0) }.joined())</section>"

        case "para":

            if node.children.isEmpty {
                return "<p>\(escape(node.text))</p>"
            }

            var html = "<p>"

            if !node.text.isEmpty {
                html += escape(node.text)
            }

            html += node.children.map { generateHTML(from: $0) }.joined()

            html += "</p>"

            return html

        case "list1":

            return """
            <ol>
            \(node.children.map { generateHTML(from: $0) }.joined())
            </ol>
            """

        case "l1item":

            return """
            <li>
            \(escape(node.text))
            \(node.children.map { generateHTML(from: $0) }.joined())
            </li>
            """

        case "ein":

            return "<b>\(escape(node.text))</b>"

        case "equname":

            return "<span class='equname'>\(escape(node.text))</span>"

        case "refint":

            return "<a href='#'>\(escape(node.text))</a>"

        case "refext":

            if let href = node.attributes["href"] {
                return "<a href='\(href)'>\(escape(node.text))</a>"
            }

            return "<a href='#'>\(escape(node.text))</a>"

        default:

            var html = ""

            if !node.text.isEmpty {
                html += escape(node.text)
            }

            html += node.children.map { generateHTML(from: $0) }.joined()

            return html
        }
    }
    
    func escape(_ text: String) -> String {

        return text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}

/**
 let parser = XMLTreeParser()

 if let root = parser.parse(data: data) {
     let generatedHTML = generateHTML(from: root)
     webView.loadHTMLString(generatedHTML, baseURL: nil)
 }
 */
