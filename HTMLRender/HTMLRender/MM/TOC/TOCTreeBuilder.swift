//
//  TOCTreeBuilder.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class TOCTreeBuilder {
    
    static func build(
        from rows: [TocItemCSV]
    ) -> [TOCNode] {
        
        var roots: [TOCNode] = []
        
        var level1Map = [String:Int]()
        var level2Map = [String:(Int,Int)]()
        var level3Map = [String:(Int,Int,Int)]()
        
        let sortedRows = rows.sorted {
            
            let lhs =
            ($0.level1 ?? "")
            + ($0.level2 ?? "")
            + ($0.level3 ?? "")
            + ($0.level4 ?? "")
            
            let rhs =
            ($1.level1 ?? "")
            + ($1.level2 ?? "")
            + ($1.level3 ?? "")
            + ($1.level4 ?? "")
            
            return lhs < rhs
        }
        
        for row in sortedRows {
            
            guard let l1 = row.level1 else {
                continue
            }
            
            //---------------------------------------------------
            // LEVEL 1
            //---------------------------------------------------
            
            if row.level2 == nil {
                
                let node = TOCNode(
                    id: row.id,
                    ataCode: l1,
                    title: row.title,
                    type: .level1,
                    children: []
                )
                
                roots.append(node)
                
                level1Map[l1] =
                roots.count - 1
                
                continue
            }
            
            guard let rootIndex =
                    level1Map[l1],
                  let l2 = row.level2
            else {
                continue
            }
            
            //---------------------------------------------------
            // LEVEL 2
            //---------------------------------------------------
            
            let level2Key =
            "\(l1)-\(l2)"
            
            if row.level3 == nil {
                
                let node = TOCNode(
                    id: row.id,
                    ataCode: level2Key,
                    title: row.title,
                    type: .level2,
                    children: []
                )
                
                roots[rootIndex]
                    .children?
                    .append(node)
                
                let childIndex =
                roots[rootIndex]
                    .children!.count - 1
                
                level2Map[level2Key] =
                (rootIndex, childIndex)
                
                continue
            }
            
            guard
                let l3 = row.level3,
                let parent =
                    level2Map[level2Key]
            else {
                continue
            }
            
            //---------------------------------------------------
            // LEVEL 3
            //---------------------------------------------------
            
            let level3Key =
            "\(l1)-\(l2)-\(l3)"
            
            if row.level4 == nil {
                
                let node = TOCNode(
                    id: row.id,
                    ataCode: level3Key,
                    title: row.title,
                    type: .level3,
                    children: []
                )
                
                roots[parent.0]
                    .children?[parent.1]
                    .children?
                    .append(node)
                
                let childIndex =
                roots[parent.0]
                    .children![parent.1]
                    .children!.count - 1
                
                level3Map[level3Key] =
                (
                    parent.0,
                    parent.1,
                    childIndex
                )
                
                continue
            }
            
            //---------------------------------------------------
            // LEVEL 4
            //---------------------------------------------------
            
            guard
                let l4 = row.level4,
                let parent =
                    level3Map[level3Key]
            else {
                continue
            }
            
            let node = TOCNode(
                id: row.id,
                ataCode:
                    "\(l1)-\(l2)-\(l3)-\(l4)",
                title: row.title,
                type: .level4
            )
            
            roots[parent.0]
                .children?[parent.1]
                .children?[parent.2]
                .children?
                .append(node)
        }
        
        print(
            "Root Nodes:",
            roots.count
        )
        
        return roots
    }
}
