//
//  Viewer.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI

struct Viewer: View {
    
    var body: some View {
        
        if let url = Bundle.main.url(
            forResource: "allelm01",
            withExtension: "cgm"
        ) {
            CGMViewerScreen(cgmURL: url)
        } else {
            Text("CGM file not found")
        }
    }
}

#Preview {
    Viewer()
}
