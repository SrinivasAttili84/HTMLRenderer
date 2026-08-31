//
//  ViewerViewModel.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 16/08/26.
//

import SwiftUI

@MainActor
final class ViewerViewModel: ObservableObject {

    @Published private(set)
    var layout: ViewerLayoutState = .initial

    @Published private(set)
    var selectedRevision: ManualRevisionSelection?

    @Published private(set)
    var selectedTOCElement: TOCElementSelection?

    @Published private(set)
    var selectedIllustration: IllustrationSelection?

    init() { }

    // MARK: - Toolbar Actions

    func didTapSearch() {

        // Search always restores the navigation workspace.
        //
        // Any state -> Search | TOC
        showPanels(
            .search,
            .toc
        )
    }

    func didTapTOC() {

        /*
         The TOC button restores TOC beside the content
         currently visible on screen.

         HTML -> TOC | HTML

         Illustration -> TOC | Illustration

         TOC | HTML -> no change

         Search | HTML -> TOC | HTML

         Otherwise -> Search | TOC
         */

        if layout.contains(.html) {
            showPanels(
                .toc,
                .html
            )
            return
        }

        if layout.contains(.illustration) {
            showPanels(
                .toc,
                .illustration
            )
            return
        }

        showPanels(
            .search,
            .toc
        )
    }

    func didTapHTML() {

        guard selectedTOCElement != nil else {
            return
        }

        /*
         HTML toolbar button focuses HTML.

         TOC | HTML -> HTML
         Search | HTML -> HTML
         HTML | Illustration -> HTML
         Illustration -> HTML, if HTML was loaded
         */

        showOnly(.html)
    }

    func didTapIllustration() {

        guard selectedIllustration != nil else {
            return
        }

        /*
         Illustration toolbar button focuses illustration.

         HTML | Illustration -> Illustration
         TOC | Illustration -> Illustration
         */

        showOnly(.illustration)
    }

    // MARK: - Swipe

    func didSwipeRightToLeft() {

        guard layout.isSplit else {
            return
        }

        /*
         Search | TOC         -> TOC
         Search | HTML        -> HTML
         TOC | HTML           -> HTML
         HTML | Illustration  -> Illustration
         TOC | Illustration   -> Illustration
         */

        layout = layout.collapsingLeftPanel()
    }

    // MARK: - Search Flow

    func didSelectRevision(
        _ revision: ManualRevisionSelection
    ) {

        selectedRevision = revision

        // Revision selection keeps Search and TOC visible.
        showPanels(
            .search,
            .toc
        )

        // Later:
        // loadTOC(for: revision)
    }

    func didSelectSearchElement(
        _ element: TOCElementSelection
    ) {

        selectedTOCElement = element

        // New HTML selection invalidates the previous figure context.
        selectedIllustration = nil

        /*
         Search result was selected.

         Search stays on left.
         HTML opens on right.
         */

        showPanels(
            .search,
            .html
        )

        // Later:
        // loadHTML(for: element)
    }

    // MARK: - TOC Flow

    func didSelectTOCElement(
        _ element: TOCElementSelection
    ) {

        selectedTOCElement = element

        // New HTML selection invalidates the previous figure context.
        selectedIllustration = nil

        /*
         TOC element was selected.

         TOC stays on left.
         HTML opens on right.
         */

        showPanels(
            .toc,
            .html
        )

        // Later:
        // loadHTML(for: element)
    }

    func didSelectTOCIllustration(
        _ illustration: IllustrationSelection
    ) {

        selectedIllustration = illustration

        /*
         Illustration was selected directly from TOC.

         TOC remains on left.
         Illustration opens on right.
         */

        showPanels(
            .toc,
            .illustration
        )

        // Later:
        // loadIllustration(for: illustration)
    }

    // MARK: - HTML Flow

    func didSelectIllustration(
        _ illustration: IllustrationSelection
    ) {

        selectedIllustration = illustration

        /*
         Figure was selected inside HTML.

         HTML remains on left.
         Illustration opens on right.
         */

        showPanels(
            .html,
            .illustration
        )

        // Later:
        // loadIllustration(for: illustration)
    }
}

// MARK: - Layout Helpers

private extension ViewerViewModel {

    func showPanels(
        _ leftPanel: ViewerPanel,
        _ rightPanel: ViewerPanel
    ) {

        layout = ViewerLayoutState(
            visiblePanels: [
                leftPanel,
                rightPanel
            ]
        )
    }

    func showOnly(
        _ panel: ViewerPanel
    ) {

        layout = ViewerLayoutState(
            visiblePanels: [panel]
        )
    }
}
