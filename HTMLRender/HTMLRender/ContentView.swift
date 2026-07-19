//
//  ContentView.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 10/07/26.
//

import SwiftUI

struct ContentView1: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView1()
}

/**
 | Method | Understanding | Data Risk |
 |----------|-------------|-----------|
 | **USB Deployment** | iPad is connected to MacBook via USB to install and debug the app. Connection is required. | **Low** – App deployment does not automatically transfer office files. |
 | **Wireless Deployment** | Requires one-time USB pairing. Afterwards, MacBook and iPad must be connected over the same network to deploy the app. | **Low** – Used for app testing, not for file transfer. |
 | **iPad Simulator** | App runs on the MacBook itself without a physical iPad. | **Very Low** – No data leaves the MacBook. |
 | **File Sharing (AirDrop, OneDrive, Email, Files App)** | Separate mechanisms used to transfer files. | **Medium/High** – Potential path for corporate data movement if allowed by policy. |
 */
