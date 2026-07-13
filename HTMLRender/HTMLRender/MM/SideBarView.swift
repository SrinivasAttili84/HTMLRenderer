//
//  SideBarView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI
struct SidebarView: View {

    @ObservedObject var vm: TOCViewModel

    var body: some View {

        List(vm.visibleNodes) { item in

            TOCRow(item: item)
                .contentShape(Rectangle())
                .onTapGesture {

                    vm.tap(item.node)
                }
        }
        .listStyle(.plain)
    }
}

struct TOCRow: View {

    let item: VisibleNode

    var body: some View {

        HStack(spacing: 8) {

            Color.clear
                .frame(width: CGFloat(item.level) * 18)

            if item.node.hasChildren {

                Image(systemName:
                        item.expanded ?
                        "chevron.down" :
                        "chevron.right")
                    .font(.caption)

            } else {

                Image(systemName: "doc.text")
                    .font(.caption)
            }

            Text(item.node.title)

            Spacer()
        }
        .padding(.vertical,6)
    }
}
