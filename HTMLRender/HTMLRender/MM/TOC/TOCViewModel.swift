//
//  TOCViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation
import SwiftUI

@MainActor
final class TOCViewModel: ObservableObject {
    
    @Published var rootNodes: [TOCNode] = []
    
    func load() {
        
        Task.detached {
            
            let start =
            CFAbsoluteTimeGetCurrent()
            
            let rows =
            CSVParser.parseTocItems(
                fileName: "TocItem"
            )
            
            print(
                "CSV:",
                CFAbsoluteTimeGetCurrent()
                - start
            )
            
            let tree =
            TOCTreeBuilder.build(
                from: rows
            )
            
            await MainActor.run {
                
                self.rootNodes = tree
            }
        }
    }
}
