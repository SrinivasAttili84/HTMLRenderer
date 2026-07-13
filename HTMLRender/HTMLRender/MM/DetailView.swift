//
//  DetailView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

struct DetailView: View {

    @ObservedObject var viewModel: TOCViewModel

    var body: some View {

        if let page = viewModel.selectedNode?.page {

            HTMLWebView(page: page)

        } else {

            ContentUnavailableView(
                "Select a topic",
                systemImage: "doc.text"
            )
        }
    }
}

//struct DetailContainerView: View {
//
//    @ObservedObject var vm: TOCViewModel
//
//    var body: some View {
//
//        VStack(spacing: 0) {
//
//            DocumentHeaderView(
//                title: vm.selectedNode?.title ?? "Select Topic"
//            )
//
//            Divider()
//
//            DocumentToolbarView()
//
//            Divider()
//
//            HTMLWebView(page: vm.selectedNode?.page)
//                .frame(maxWidth: .infinity,
//                       maxHeight: .infinity)
//
//            Divider()
//
//            PageNavigatorView()
//        }
//    }
//}
