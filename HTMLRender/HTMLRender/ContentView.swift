//
//  ContentView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 13/08/26.
//

import SwiftUI

struct ContentView: View {

    @State private var showPopup = false

    var body: some View {

        ZStack {

            VStack {

                Button("Open Manual Selection") {
                    showPopup = true
                }
            }

            if showPopup {

                ManualSelectionPopupView(
                    isPresented: $showPopup
                )
            }
        }
    }
}
