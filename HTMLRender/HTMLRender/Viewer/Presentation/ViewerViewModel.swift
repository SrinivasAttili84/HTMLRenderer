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

    // MARK: - Toolbar Actions

    func didTapSearch() {

        /*
         Search always restores the initial navigation workspace.

         Any state -> Search | TOC
         */

        showPanels(
            .search,
            .toc
        )
    }

    func didTapTOC() {

        /*
         TOC opens beside the content currently visible.

         HTML                  -> TOC | HTML
         Search | HTML         -> TOC | HTML
         TOC | HTML            -> TOC | HTML
         HTML | Illustration   -> TOC | HTML

         Illustration          -> TOC | Illustration
         TOC | Illustration    -> TOC | Illustration

         Search | TOC          -> Search | TOC
         TOC only              -> Search | TOC

         HTML is checked before Illustration because when
         HTML | Illustration is visible, HTML is still the
         originating document content.
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
         If an Illustration is currently visible, tapping HTML
         restores HTML beside that Illustration.

         Illustration          -> HTML | Illustration
         TOC | Illustration    -> HTML | Illustration
         HTML | Illustration   -> HTML | Illustration

         Otherwise HTML receives the full workspace.

         Search | HTML         -> HTML
         TOC | HTML            -> HTML
         HTML                  -> HTML
         */

        if layout.contains(.illustration),
           selectedIllustration != nil {

            showPanels(
                .html,
                .illustration
            )
            return
        }

        showOnly(.html)
    }

    func didTapIllustration() {

        guard selectedIllustration != nil else {
            return
        }

        /*
         Illustration toolbar focuses the Illustration.

         HTML | Illustration   -> Illustration
         TOC | Illustration    -> Illustration
         Illustration          -> Illustration
         */

        showOnly(.illustration)
    }

    // MARK: - Swipe

    func didSwipeRightToLeft() {

        /*
         Swipe is accepted whenever the right pane is
         HTML or Illustration.

         Search | HTML         -> HTML
         TOC | HTML            -> HTML
         TOC | Illustration    -> Illustration
         HTML | Illustration   -> Illustration

         Search | TOC          -> no action
         */

        guard layout.allowsContentCollapseSwipe else {
            return
        }

        layout = layout.collapsingToRightContent()
    }

    // MARK: - Search Flow

    func didSelectRevision(
        _ revision: ManualRevisionSelection
    ) {

        selectedRevision = revision

        /*
         Revision selection keeps the initial workspace.

         Search | TOC
         */

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

        /*
         The previously selected Illustration belongs to
         previously opened content, so clear it.
         */

        selectedIllustration = nil

        /*
         Search result selected:

         Search remains on the left.
         HTML opens on the right.
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
        selectedIllustration = nil

        /*
         TOC element selected:

         TOC remains on the left.
         HTML opens on the right.
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
         Illustration selected directly from TOC:

         TOC remains on the left.
         Illustration opens on the right.
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
         Illustration selected from HTML:

         HTML remains on the left.
         Illustration opens on the right.
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
