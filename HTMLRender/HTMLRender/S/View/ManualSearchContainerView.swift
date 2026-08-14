//
//  ManualSearchContainerView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct ManualSearchContainerView: View {

    @StateObject private var viewModel: ManualSearchViewModel

    init(
        manualType: ManualType,
        repository: ManualSearchRepositoryProtocol = MockManualSearchRepository()
    ) {
        _viewModel = StateObject(
            wrappedValue: ManualSearchViewModel(
                manualType: manualType,
                repository: repository
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.capability.supportsTabs {
                ManualSearchTabBar(
                    modes: viewModel.capability.supportedModes,
                    selectedMode: viewModel.selectedMode,
                    onSelect: viewModel.selectMode
                )
            } else {
                SingleSearchHeaderView(title: "Search")
            }

            Group {
                switch viewModel.selectedMode {
                case .troubleshooting:
                    TroubleshootingSearchView(viewModel: viewModel)

                case .search:
                    ManualTextSearchView(viewModel: viewModel)
                }
            }
        }
        .background(AirNavXColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(AirNavXColor.border, lineWidth: 1)
        }
    }
}
