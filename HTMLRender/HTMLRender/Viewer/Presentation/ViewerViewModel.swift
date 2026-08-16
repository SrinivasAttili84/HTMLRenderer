//
//  ViewerViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

@MainActor
final class ViewerViewModel: ObservableObject {

    @Published private(set) var layout: ViewerLayoutState = .initial

    @Published private(set) var selectedRevision: ManualRevisionSelection?
    @Published private(set) var selectedTOCElement: TOCElementSelection?
    @Published private(set) var selectedIllustration: IllustrationSelection?

    @Published private(set) var activeToolbarItem: ViewerPanel = .search

    init() { }

    // MARK: - Toolbar Actions

    func didTapSearch() {
        layout = ViewerLayoutState(
            leftPanel: .search,
            rightPanel: .toc
        )
        activeToolbarItem = .search
    }

    func didTapTOC() {
        if selectedTOCElement != nil {
            layout = ViewerLayoutState(
                leftPanel: .toc,
                rightPanel: .html
            )
        } else {
            layout = ViewerLayoutState(
                leftPanel: .search,
                rightPanel: .toc
            )
        }

        activeToolbarItem = .toc
    }

    func didTapHTML() {
        guard selectedTOCElement != nil else {
            layout = ViewerLayoutState(
                leftPanel: .search,
                rightPanel: .toc
            )
            activeToolbarItem = .toc
            return
        }

        layout = ViewerLayoutState(
            leftPanel: .toc,
            rightPanel: .html
        )

        activeToolbarItem = .html
    }

    func didTapIllustration() {
        guard selectedTOCElement != nil else {
            layout = ViewerLayoutState(
                leftPanel: .search,
                rightPanel: .toc
            )
            activeToolbarItem = .toc
            return
        }

        layout = ViewerLayoutState(
            leftPanel: .html,
            rightPanel: .illustration
        )

        activeToolbarItem = .illustration
    }

    // MARK: - Search Flow

    func didSelectRevision(_ revision: ManualRevisionSelection) {
        selectedRevision = revision

        layout = ViewerLayoutState(
            leftPanel: .search,
            rightPanel: .toc
        )

        activeToolbarItem = .search

        // Later:
        // loadTOC(for: revision)
    }

    // MARK: - TOC Flow

    func didSelectTOCElement(_ element: TOCElementSelection) {
        selectedTOCElement = element

        layout = ViewerLayoutState(
            leftPanel: .toc,
            rightPanel: .html
        )

        activeToolbarItem = .html

        // Later:
        // loadHTML(for: element)
    }

    // MARK: - HTML Flow

    func didSelectIllustration(_ illustration: IllustrationSelection) {
        selectedIllustration = illustration

        layout = ViewerLayoutState(
            leftPanel: .html,
            rightPanel: .illustration
        )

        activeToolbarItem = .illustration

        // Later:
        // loadIllustration(for: illustration)
    }
}
