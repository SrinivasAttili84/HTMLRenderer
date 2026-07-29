//
//  CGMContentView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI

struct ContentView1: View {

    var body: some View {

        if let url = Bundle.main.url(
            forResource: "ICN-07GB6-BIKECI0001-001-01",
            withExtension: "CGM"
        ) {

            CGMDisplayListViewerScreen(
                cgmURL: url
            )

        } else {

            Text("CGM file not found")
                .foregroundColor(.red)
                .padding()
        }
    }
}
