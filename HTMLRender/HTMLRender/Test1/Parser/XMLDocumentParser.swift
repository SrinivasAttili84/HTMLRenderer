//
//  XMLDocumentParser.swift
//  HTMLRenderer
//

import Foundation

final class XMLDocumentParser: NSObject {

    // MARK: - Properties

    private var nodeStack: [XMLNode] = []

    private var document = XMLDocument()

    // MARK: - Parse

    func parse(url: URL) -> XMLDocument {

        nodeStack.removeAll()
        document = XMLDocument()

        guard let parser = XMLParser(contentsOf: url) else {
            return document
        }

        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false

        parser.parse()

        return document
    }
}

// MARK: - XMLParserDelegate

extension XMLDocumentParser: XMLParserDelegate {

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {

        let node = XMLNode(tag: elementName,
                           attributes: attributeDict)

        if let parent = nodeStack.last {

            parent.addChild(node)

        } else {

            document.root = node
        }

        nodeStack.append(node)
    }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) {

        guard let node = nodeStack.last else {
            return
        }

        node.text += string
    }

    func parser(_ parser: XMLParser,
                foundCDATA CDATABlock: Data) {

        guard let node = nodeStack.last else {
            return
        }

        if let value = String(data: CDATABlock,
                              encoding: .utf8) {

            node.text += value

        }

    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        guard let node = nodeStack.last else {
            return
        }

        node.text = node.text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        nodeStack.removeLast()
    }

    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {

        print("XML Parse Error : \(parseError.localizedDescription)")

    }

}
