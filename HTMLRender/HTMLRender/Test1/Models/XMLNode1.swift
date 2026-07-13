//
////
////  XMLNode.swift
////  HTMLRenderer
////
//
//import Foundation
//
//final class XMLNode {
//
//    // MARK: Properties
//
//    let tag: String
//
//    var text: String = ""
//
//    var attributes: [String: String]
//
//    weak var parent: XMLNode?
//
//    var children: [XMLNode] = []
//
//    // MARK: Init
//
//    init(tag: String,
//         attributes: [String: String] = [:]) {
//
//        self.tag = tag
//        self.attributes = attributes
//    }
//
//    // MARK: Add Child
//
//    func addChild(_ node: XMLNode) {
//
//        node.parent = self
//        children.append(node)
//
//    }
//
//    // MARK: Helpers
//
//    func child(named name: String) -> XMLNode? {
//
//        children.first { $0.tag == name }
//
//    }
//
//    func children(named name: String) -> [XMLNode] {
//
//        children.filter { $0.tag == name }
//
//    }
//
//    var hasChildren: Bool {
//
//        !children.isEmpty
//
//    }
//
//}
//
//extension XMLNode {
//
//    func printTree(level: Int = 0) {
//
//        let prefix = String(repeating: "   ", count: level)
//
//        print("\(prefix)<\(tag)> \(text)")
//
//        children.forEach {
//
//            $0.printTree(level: level + 1)
//
//        }
//
//    }
//
//}
