//
//  ManualTextSearchView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct ManualTextSearchView: View {

    @ObservedObject var viewModel: ManualSearchViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundStyle(AirNavXColor.textSecondary)

                    TextField("Search in \(viewModel.capability.manualType.rawValue)", text: $viewModel.searchText)
                        .font(.system(size: 18))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    Button {
                        viewModel.performTextSearch()
                    } label: {
                        Text("Search")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 110, height: 44)
                            .background(AirNavXColor.primaryBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AirNavXColor.border, lineWidth: 1)
                }

                Text("Results: \(viewModel.searchResults.count)")
                    .font(.system(size: 20))
                    .foregroundStyle(AirNavXColor.textSecondary)

                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(viewModel.searchResults) { result in
                            ManualSearchResultCardView(result: result)
                        }
                    }
                }
            }
            .padding(28)

            Spacer()
        }
    }
}
