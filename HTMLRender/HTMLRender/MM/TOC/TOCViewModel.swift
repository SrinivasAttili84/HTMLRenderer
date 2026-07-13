//
//  TOCViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCViewModel: ObservableObject {

    @Published var rootNodes: [TOCNode] = []

    init() {

        let csvRows = CSVParser.parseTocItems(
            fileName: "TocItem"
        )

        rootNodes = TOCTreeBuilder.build(
            from: csvRows
        )
    }
}
