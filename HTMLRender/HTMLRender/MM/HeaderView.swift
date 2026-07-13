//
//  HeaderView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 13/07/26.
//

import SwiftUI

struct DocumentHeaderView: View {

    let title: String

    var body: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("AIRCRAFT MAINTENANCE MANUAL")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "square.and.arrow.up")
            }

            Button {
            } label: {
                Image(systemName: "printer")
            }

            Button {
            } label: {
                Image(systemName: "bookmark")
            }
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(.bar)
    }
}


struct DocumentToolbarView: View {

    var body: some View {

        HStack(spacing: 20) {

            Button {

            } label: {
                Image(systemName: "chevron.left")
            }

            Button {

            } label: {
                Image(systemName: "chevron.right")
            }

            Divider()

            Button {

            } label: {
                Image(systemName: "minus.magnifyingglass")
            }

            Button {

            } label: {
                Image(systemName: "plus.magnifyingglass")
            }

            Divider()

            Button {

            } label: {
                Image(systemName: "arrow.clockwise")
            }

            Spacer()

            Button {

            } label: {
                Image(systemName: "magnifyingglass")
            }

        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(Color(.secondarySystemBackground))
    }
}

struct PageNavigatorView: View {

    var body: some View {

        HStack {

            Button("Previous") {

            }

            Spacer()

            Text("Page 3 of 18")

            Spacer()

            Button("Next") {

            }

        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(.bar)
    }
}
