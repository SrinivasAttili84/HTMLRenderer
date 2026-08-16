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


struct ContentView1: View {
    
    @State private var aircraftType: String?
    @State private var customisation: String?
    
    var body: some View {
    
        HStack(alignment: .top, spacing: 32) {

            AirNavXDropdown(
                title: "Customisation",
                selectedItem: $customisation,
                items: [
                    "BGA",
                    "KLM",
                    "QATAR"
                ]
            )

            AirNavXDropdown(
                title: "Aircraft Type",
                selectedItem: $aircraftType,
                items: [
                    "A220",
                    "A320",
                    "A321",
                    "A330",
                    "A350",
                    "A380"
                ]
            )
        }
        .padding(.horizontal, 32)
    }
}
