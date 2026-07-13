//
//  TOCView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

struct TOCView: View {

    @StateObject private var viewModel = TOCViewModel()

    var body: some View {

        NavigationStack {

            List {

                ForEach(viewModel.rootNodes) { node in

                    TOCRowView(node: node)
                }
            }
            .navigationTitle("Table Of Contents")
        }
    }
}

import SwiftUI

struct ContentView4: View {

    var body: some View {

        TOCView()
    }
}
