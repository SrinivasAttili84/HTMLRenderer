//
//  CSVParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import Foundation

final class CSVParser {
    
    private static func clean(
        _ value: String
    ) -> String? {
        
        let cleaned = value
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        return cleaned.isEmpty ? nil : cleaned
    }
    
    static func parseTocItems(
        fileName: String
    ) -> [TocItemCSV] {
        
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "csv"
        ) else {
            
            return []
        }
        
        do {
            
            let text = try String(
                contentsOf: url,
                encoding: .utf8
            )
            
            let rows = text
                .components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
            
            guard rows.count > 1 else {
                return []
            }
            
            let headers = rows[0]
                .components(separatedBy: ",")
            
            guard
                let idIndex = headers.firstIndex(of: "Id"),
                let level1Index = headers.firstIndex(of: "LevelId1"),
                let level2Index = headers.firstIndex(of: "LevelId2"),
                let level3Index = headers.firstIndex(of: "LevelId3"),
                let level4Index = headers.firstIndex(of: "LevelId4"),
                let titleIndex = headers.firstIndex(of: "Title")
            else {
                return []
            }
            
            var items: [TocItemCSV] = []
            
            for row in rows.dropFirst() {
                
                let columns = row.components(
                    separatedBy: ","
                )
                
                if columns.count <= titleIndex {
                    continue
                }
                
                items.append(
                    TocItemCSV(
                        
                        id:
                            clean(
                                columns[idIndex]
                            ) ?? UUID().uuidString,
                        
                        level1:
                            clean(
                                columns[level1Index]
                            ),
                        
                        level2:
                            clean(
                                columns[level2Index]
                            ),
                        
                        level3:
                            clean(
                                columns[level3Index]
                            ),
                        
                        level4:
                            clean(
                                columns[level4Index]
                            ),
                        
                        title:
                            clean(
                                columns[titleIndex]
                            ) ?? ""
                    )
                )
            }
            
            print("Rows:", items.count)
            
            return items
            
        } catch {
            
            print(error)
            return []
        }
    }
}
