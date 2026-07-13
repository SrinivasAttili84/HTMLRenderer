//
//  TOCTreeView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI


struct TOCTreeView: View {

    let toc: [TOCNode]

    var body: some View {

        List {

            OutlineGroup(
                toc,
                children: \.children
            ) { node in

                Label(
                    node.title,
                    systemImage: node.children?.isEmpty == false
                    ? "folder"
                    : "doc.text"
                )
            }
        }
    }
}

struct ContentView: View {

    @State private var toc: [TOCNode] = []

    var body: some View {

        NavigationStack {

            TOCTreeView(toc: toc)
        }
        .onAppear {

            let parser = TocCSVParser()

            do {

                let rows = try parser.parse(fileURL: csvURL)

                toc = TOCTreeBuilder().build(rows: rows)

            } catch {

                print(error)
            }
        }
    }
}
