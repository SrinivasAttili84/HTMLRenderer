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
//            ContentView()
        }
    }
}
/**
 Package/

 ├── toc/
 │   └── toc.json

 ├── views/
 │   ├── VIEW001.html
 │   ├── VIEW002.html
 │   ├── VIEW003.html
 │   └── ...

 ├── figures/
 │   ├── figures.json
 │   ├── FIG100.svg
 │   ├── FIG101.svg
 │   ├── FIG102.svg
 │   └── ...

 └── metadata/
     └── manual.json
 */


/**
 | Key         | Required        | Purpose                                |
 | ----------- | --------------- | -------------------------------------- |
 | `id`        | ✅               | Stable unique identifier               |
 | `title`     | ✅               | Display name shown in TOC              |
 | `type`  | ✅    optional           | Business meaning (`solution`) |
 | `items`     | ✅ for groups    | Recursive hierarchy                    |
 | `viewId`    | ✅ for solutions | Maps solution to HTML content          |
 | `figureIds` | Optional        | Maps solution to illustrations         |

 */
