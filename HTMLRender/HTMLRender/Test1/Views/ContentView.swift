//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {

    @State private var html = "<h1>Loading...</h1>"

    var body: some View {

        WebView(html: html)
            .onAppear {

                loadXML()

            }

    }

}

private extension ContentView {

    func loadXML() {

        guard let url = Bundle.main.url(forResource: "sample",
                                        withExtension: "xml")

        else {

            print("sample.xml not found")

            return
        }

        let parser = XMLDocumentParser()

        let document = parser.parse(url: url)

        let builder = HTMLBuilder()

        html = builder.build(document: document)

        print(html)

    }

}
