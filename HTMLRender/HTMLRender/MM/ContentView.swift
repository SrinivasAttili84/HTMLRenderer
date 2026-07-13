//
//  ContentView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var vm =
            TOCViewModel(nodes: TOCParser.load(from: "manual"))
    
    var body: some View {

        NavigationSplitView {

            SidebarView(vm: vm)
                .toolbar(.hidden, for: .navigationBar)
        } detail: {

            DetailView(viewModel: vm)
        }
    }
}
