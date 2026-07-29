//
//  CGMPrimitive.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation
import CoreGraphics
import SwiftUI

enum CGMInteriorStyle: Equatable {
    case hollow
    case solid
}

struct CGMTextOrientation {
    var up: CGPoint = CGPoint(x: 0, y: 1)
    var base: CGPoint = CGPoint(x: 1, y: 0)
}

struct CGMGraphicStyle {
    var lineColor: Color = .black
    var fillColor: Color = .clear
    var textColor: Color = .black
    var edgeColor: Color = .black

    var interiorStyle: CGMInteriorStyle = .hollow

    var lineWidth: CGFloat = 1
    var edgeWidth: CGFloat = 1
    var markerSize: CGFloat = 5
    var characterHeight: CGFloat = 24

    var edgeVisible: Bool = true
    var textOrientation = CGMTextOrientation()
}

enum CGMPrimitive {

    case polyline([CGPoint], CGMGraphicStyle)
    case markers([CGPoint], CGMGraphicStyle)
    case polygon(
        [CGPoint],
        CGMGraphicStyle
    )

    case rectangle(
        CGRect,
        CGMGraphicStyle
    )

    case circle(
        center: CGPoint,
        radius: CGFloat,
        CGMGraphicStyle
    )

    case ellipse(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        CGMGraphicStyle
    )

    case text(
        position: CGPoint,
        value: String,
        CGMGraphicStyle
    )

    case circularArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        closeType: Int?,
        CGMGraphicStyle
    )

    case cellArray(
        origin: CGPoint,
        width: CGFloat,
        height: CGFloat,
        columns: Int,
        rows: Int,
        colors: [Color]
    )
    
    case ellipticalArc(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        closeType: Int?,
        CGMGraphicStyle
    )
}

struct CGMDocument {
    var vdcExtent: CGRect?
    var primitives: [CGMPrimitive] = []
}
