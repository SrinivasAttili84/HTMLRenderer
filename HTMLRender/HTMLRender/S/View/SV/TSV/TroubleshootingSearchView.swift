//
//  TroubleshootingSearchView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct TroubleshootingSearchView: View {

    @ObservedObject var viewModel: ManualSearchViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if viewModel.filters.count > 1 {
                        FilterChipRowView(
                            filters: viewModel.filters,
                            onRemove: viewModel.removeFilter
                        )
                    }

                    ForEach($viewModel.filters) { $filter in
                        TroubleshootingFilterCardView(
                            filter: $filter,
                            onDelete: {
                                viewModel.removeFilter(filter)
                            },
                            onToggle: {
                                viewModel.toggleFilter(filter)
                            }
                        )
                    }

                    Text("Results: \(viewModel.troubleshootingResults.count)")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(AirNavXColor.textSecondary)

                    VStack(spacing: 14) {
                        ForEach(viewModel.troubleshootingResults) { result in
                            TroubleshootingResultCardView(
                                result: result,
                                onReferenceTap: {
                                    viewModel.openReferenceTask(result.referenceTask)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }

            TroubleshootingBottomActionBar(
                onAdd: viewModel.addFilter,
                onReset: viewModel.resetFilters,
                onApply: viewModel.applyTroubleshootingFilters
            )
        }
    }
}
