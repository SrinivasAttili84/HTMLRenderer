//
//  ManualSelectionPopupView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 15/08/26.
//

import Foundation
import SwiftUI

struct ManualSelectionPopupView: View {

    @Binding var isPresented: Bool

    var body: some View {

        ZStack {

            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                header

                searchSection

                manualList
            }
            .frame(width: 1120, height: 760)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.15), radius: 20)
        }
    }
}

// MARK: - Header

extension ManualSelectionPopupView {

    private var header: some View {

        HStack {

            Text("Select AMM Manuals")
                .font(.system(size: 32, weight: .medium))

            Spacer()

            Button {
                isPresented = false
            } label: {

                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
    }
}

// MARK: - Search

extension ManualSelectionPopupView {

    private var searchSection: some View {

        VStack(spacing: 24) {

            HStack {

                TextField(
                    "Search by Customisation, Aircraft Type, MSN, TN, FSN...",
                    text: .constant("")
                )
                .font(.system(size: 18))

                Spacer()

                Button {

                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "slider.horizontal.3")

                        Text("Filters")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 0.00, green: 0.05, blue: 0.40))
                    .frame(width: 140, height: 48)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue.opacity(0.6))
                    }
                }
            }

            HStack(spacing: 24) {

                VStack(alignment: .leading) {

                    Text("Customisation")
                        .font(.system(size: 15, weight: .semibold))

                    Menu("Choose your item") {

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                }

                VStack(alignment: .leading) {

                    Text("Aircraft Type")
                        .font(.system(size: 15, weight: .semibold))

                    Menu("Choose your item") {

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 30)
        .padding(.bottom, 20)
    }
}

// MARK: - List

extension ManualSelectionPopupView {

    private var manualList: some View {

        ScrollView {

            LazyVStack(spacing: 16) {

                ForEach(0..<10, id: \.self) { _ in

                    ManualRowView()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
