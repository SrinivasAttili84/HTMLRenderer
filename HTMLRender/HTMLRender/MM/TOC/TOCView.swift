//
//  TOCView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//


import SwiftUI

struct TOCView: View {
    
    @StateObject
    private var vm = TOCViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                OutlineGroup(
                    vm.rootNodes,
                    children: \.children
                ) { node in
                    
                    HStack {
                        
                        Text(node.ataCode)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(
                                width: 120,
                                alignment: .leading
                            )
                        
                        Text(node.title)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("TOC")
            .task {
                
                vm.load()
            }
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        
        TOCView()
    }
}
