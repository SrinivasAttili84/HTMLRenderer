//
//  TOCTreeScrollView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 20/07/26.
//

import SwiftUI

struct TOCTreeScrollView: View {

    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        ScrollViewReader { proxy in

            ScrollView {

                LazyVStack(
                    alignment: .leading,
                    spacing: 0
                ) {

                    ForEach(viewModel.rootNodes) { node in

                        TOCNodeTreeView(
                            node: node,
                            level: 0,
                            viewModel: viewModel
                        )
                    }
                }
            }
            .onChange(of: viewModel.selectedNodeId) { _, newValue in

                guard let newValue else {
                    return
                }

                withAnimation {

                    proxy.scrollTo(
                        newValue,
                        anchor: .center
                    )
                }
            }
        }
    }
}
