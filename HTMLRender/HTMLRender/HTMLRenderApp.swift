//
//  HTMLRenderApp.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 10/07/26.
//

import SwiftUI

@main
struct AirNavXSampleApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ManualSearchContainerView(
                    manualType: .tsm
                )
                .padding(20)
            }
        }
    }
}

//
//@main
//struct HTMLRenderApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
