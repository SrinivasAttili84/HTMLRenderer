import Foundation

final class XMLNode {

    let name: String
    var attributes: [String: String]
    var text: String = ""
    weak var parent: XMLNode?
    var children: [XMLNode] = []

    init(name: String, attributes: [String: String] = [:]) {
        self.name = name
        self.attributes = attributes
    }

    func addChild(_ child: XMLNode) {
        child.parent = self
        children.append(child)
    }
}
