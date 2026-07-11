import Foundation

final class XMLTreeParser: NSObject {

    private var stack: [XMLNode] = []

    private(set) var root: XMLNode?

    func parse(data: Data) -> XMLNode? {

        let parser = XMLParser(data: data)
        parser.delegate = self

        if parser.parse() {
            return root
        }

        print(parser.parserError ?? "Unknown Error")
        return nil
    }
}

extension XMLTreeParser: XMLParserDelegate {

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {

        let node = XMLNode(name: elementName,
                           attributes: attributeDict)

        if let parent = stack.last {
            parent.addChild(node)
        } else {
            root = node
        }

        stack.append(node)
    }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) {

        guard let current = stack.last else { return }

        current.text += string
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        if let current = stack.last {
            current.text = current.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        stack.removeLast()
    }

    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {

        print(parseError)
    }
}

/*
 usage
 let url = Bundle.main.url(forResource: "sample", withExtension: "xml")!

 let data = try Data(contentsOf: url)

 let parser = XMLTreeParser()

 if let root = parser.parse(data: data) {
     printTree(root)
 }
 */
