//
//  TOCRowView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

struct TOCRowView: View {

    @ObservedObject var node: TOCNode

    @State private var expanded = false

    var body: some View {

        VStack(alignment: .leading) {

            if node.children.isEmpty {

                HStack {

                    Image(systemName: "doc.text")

                    Text(node.title)
                }

            } else {

                DisclosureGroup(
                    isExpanded: $expanded
                ) {

                    ForEach(node.children) { child in

                        TOCRowView(node: child)
                            .padding(.leading, 20)
                    }

                } label: {

                    HStack {

                        Image(systemName: "folder")

                        Text(node.title)
                    }
                }
            }
        }
    }
}
