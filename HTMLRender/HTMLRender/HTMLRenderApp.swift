//
//  HTMLRenderApp.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 10/07/26.
//

import SwiftUI

@main
struct HTMLRenderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView1()
        }
    }
}

import SwiftUI

struct ContentView: View {

    var body: some View {

        if let url = Bundle.main.url(
            forResource: "allelm01",
            withExtension: "cgm"
        ) {

            CGMViewerScreen(cgmURL: url)

        } else {

            Text("CGM file not found")
                .foregroundColor(.red)
                .padding()
        }
    }
}
